from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from pydantic import BaseModel

from backend.database import get_db
from backend.openai_utils import get_personalized_recommendations

router = APIRouter(prefix="/api", tags=["preferences"])

class UserPreferences(BaseModel):
    selected_sectors: List[str]
    work_field: str
    investment_stage: List[str]
    investment_range: str
    risk_tolerance: str
    investment_goal: str
    experience_level: str
    preferred_locations: List[str]

@router.post("/save-preferences")
def save_user_preferences(preferences: UserPreferences):
    """Save user preferences (can be enhanced to store in DB later)"""
    return {
        "success": True,
        "message": "Preferences saved successfully"
    }

@router.post("/personalized-startups")
def get_personalized_startups(preferences: UserPreferences, db: Session = Depends(get_db)):
    """Get personalized startup recommendations based on user preferences"""
    from backend.crud import get_startups
    
    # Get all startups
    startups = get_startups(db, limit=100)
    
    # Filter by sector if specified
    if preferences.selected_sectors:
        startups = [s for s in startups if s.sector in preferences.selected_sectors]
    
    # Filter by funding stage if specified
    if preferences.investment_stage:
        startups = [s for s in startups if s.funding_stage in preferences.investment_stage]
    
    # Filter by location if specified (basic matching)
    if preferences.preferred_locations:
        location_filter = []
        for startup in startups:
            for pref_loc in preferences.preferred_locations:
                if pref_loc.split(',')[0] in startup.location:
                    location_filter.append(startup)
                    break
        if location_filter:
            startups = location_filter
    
    # Return top matches (can be enhanced with AI scoring later)
    return startups[:20]

@router.post("/ai-match-score")
async def get_ai_match_score(startup_id: int, preferences: UserPreferences, db: Session = Depends(get_db)):
    """Get AI-calculated match score for a startup based on user preferences"""
    from backend.crud import get_startup_by_id
    
    startup = get_startup_by_id(db, startup_id)
    if not startup:
        return {"error": "Startup not found"}
    
    # Generate match score using OpenAI
    score = await get_personalized_recommendations(startup, preferences)
    
    return {
        "startup_id": startup_id,
        "match_score": score,
        "reasoning": "Based on your preferences and the startup's profile"
    }

