from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
import json

from backend.database import get_db
from backend import crud, schemas
from backend.openai_utils import analyze_startup, find_similar_startups

router = APIRouter(prefix="/api", tags=["ai"])

@router.get("/ai-analysis/{startup_id}", response_model=schemas.AIAnalysis)
def ai_analysis(startup_id: int, db: Session = Depends(get_db)):
    """Get AI-powered analysis of a startup"""
    startup = crud.get_startup_by_id(db, startup_id)
    if not startup:
        raise HTTPException(status_code=404, detail="Startup not found")
    
    # Check if analysis already exists
    if startup.ai_summary:
        return schemas.AIAnalysis(**json.loads(startup.ai_summary))
    
    # Generate new analysis
    analysis = analyze_startup(startup)
    startup.ai_summary = json.dumps(analysis)
    db.commit()
    
    return schemas.AIAnalysis(**analysis)

@router.get("/similar/{startup_id}", response_model=List[schemas.SimilarStartup])
def similar_startups(startup_id: int, db: Session = Depends(get_db)):
    """Get similar startups based on AI embeddings"""
    startup = crud.get_startup_by_id(db, startup_id)
    if not startup:
        raise HTTPException(status_code=404, detail="Startup not found")
    
    similar = find_similar_startups(db, startup, limit=3)
    
    return [
        schemas.SimilarStartup(
            id=s.id,
            name=s.name,
            sector=s.sector,
            similarity_score=round(score * 100, 1)
        )
        for s, score in similar
    ]

