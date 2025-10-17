import os
import json
from openai import OpenAI
from backend.models import Startup
from typing import List, Tuple
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def generate_embedding(text: str) -> List[float]:
    """Generate embedding vector for text using OpenAI"""
    try:
        response = client.embeddings.create(
            input=text,
            model="text-embedding-3-small"
        )
        return response.data[0].embedding
    except Exception as e:
        print(f"Error generating embedding: {e}")
        return []

def analyze_startup(startup: Startup) -> dict:
    """Generate AI analysis for a startup"""
    try:
        prompt = f"""
        Analyze this startup and provide a structured investment analysis:
        
        Company: {startup.name}
        Sector: {startup.sector}
        Description: {startup.description}
        Valuation: ${startup.valuation}M
        Revenue: ${startup.revenue}M ARR
        Growth Rate: {startup.growth_rate}% YoY
        Funding Stage: {startup.funding_stage}
        Employees: {startup.employees}
        Location: {startup.location}
        
        Provide a JSON response with:
        - strengths: array of 3 key strengths
        - risks: array of 3 potential risks
        - market_opportunity: brief market analysis (1-2 sentences)
        - recommendation: investment recommendation (Buy, Hold, or Pass)
        - confidence_score: confidence in recommendation (0-1)
        """
        
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "You are an expert venture capital analyst providing structured investment insights."},
                {"role": "user", "content": prompt}
            ],
            response_format={"type": "json_object"},
            temperature=0.7
        )
        
        analysis = json.loads(response.choices[0].message.content)
        return analysis
    except Exception as e:
        print(f"Error analyzing startup: {e}")
        return {
            "strengths": ["Innovative product", "Strong team", "Growing market"],
            "risks": ["Market competition", "Scaling challenges", "Regulatory concerns"],
            "market_opportunity": "The market shows significant growth potential with increasing demand.",
            "recommendation": "Hold",
            "confidence_score": 0.7
        }

def get_startup_embedding_text(startup: Startup) -> str:
    """Create text representation of startup for embedding"""
    return f"{startup.name} {startup.sector} {startup.description} {startup.location} {startup.funding_stage}"

def calculate_similarity(vector1: List[float], vector2: List[float]) -> float:
    """Calculate cosine similarity between two vectors"""
    if not vector1 or not vector2:
        return 0.0
    
    v1 = np.array(vector1).reshape(1, -1)
    v2 = np.array(vector2).reshape(1, -1)
    
    return float(cosine_similarity(v1, v2)[0][0])

def find_similar_startups(db, target_startup: Startup, limit: int = 3) -> List[Tuple[Startup, float]]:
    """Find similar startups based on embeddings"""
    from backend.crud import get_startups
    
    # Get target embedding
    if target_startup.similarity_vector:
        target_vector = json.loads(target_startup.similarity_vector)
    else:
        text = get_startup_embedding_text(target_startup)
        target_vector = generate_embedding(text)
    
    # Get all startups
    all_startups = db.query(Startup).filter(Startup.id != target_startup.id).all()
    
    similarities = []
    for startup in all_startups:
        if startup.similarity_vector:
            startup_vector = json.loads(startup.similarity_vector)
        else:
            text = get_startup_embedding_text(startup)
            startup_vector = generate_embedding(text)
            startup.similarity_vector = json.dumps(startup_vector)
            db.commit()
        
        similarity = calculate_similarity(target_vector, startup_vector)
        similarities.append((startup, similarity))
    
    # Sort by similarity and return top N
    similarities.sort(key=lambda x: x[1], reverse=True)
    return similarities[:limit]

async def get_personalized_recommendations(startup: Startup, preferences: dict) -> int:
    """Calculate personalized match score based on user preferences"""
    try:
        # Convert preferences dict to context string
        context = f"""
        User Preferences:
        - Interested Sectors: {', '.join(preferences.get('selected_sectors', []))}
        - Work Field: {preferences.get('work_field', 'N/A')}
        - Investment Stage: {', '.join(preferences.get('investment_stage', []))}
        - Investment Range: {preferences.get('investment_range', 'N/A')}
        - Risk Tolerance: {preferences.get('risk_tolerance', 'N/A')}
        - Investment Goal: {preferences.get('investment_goal', 'N/A')}
        - Experience Level: {preferences.get('experience_level', 'N/A')}
        - Preferred Locations: {', '.join(preferences.get('preferred_locations', []))}
        
        Startup:
        - Name: {startup.name}
        - Sector: {startup.sector}
        - Description: {startup.description}
        - Location: {startup.location}
        - Funding Stage: {startup.funding_stage}
        - Valuation: ${startup.valuation}M
        - Growth Rate: {startup.growth_rate}%
        
        Based on the user's preferences and this startup's profile, calculate a match score from 0-100.
        Consider sector alignment, location preferences, funding stage match, and investment goals.
        Return ONLY the numeric score.
        """
        
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "You are an investment matching algorithm. Return only a number between 0-100."},
                {"role": "user", "content": context}
            ],
            temperature=0.5,
            max_tokens=10
        )
        
        score = int(response.choices[0].message.content.strip())
        return max(0, min(100, score))  # Clamp between 0-100
    except Exception as e:
        print(f"Error calculating match score: {e}")
        return 75  # Default fallback score

