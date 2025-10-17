from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from backend.database import get_db
from backend import crud, schemas

router = APIRouter(prefix="/api", tags=["analytics"])

@router.get("/analytics", response_model=schemas.AnalyticsResponse)
def get_analytics(db: Session = Depends(get_db)):
    """Get analytics data for saved startups"""
    sector_dist = crud.get_sector_distribution(db)
    avg_growth = crud.get_avg_growth_by_sector(db)
    funding_counts = crud.get_funding_stage_counts(db)
    saved = crud.get_saved_startups(db)
    
    return schemas.AnalyticsResponse(
        sector_distribution=sector_dist,
        avg_growth_by_sector=avg_growth,
        funding_stage_counts=funding_counts,
        total_saved=len(saved),
        total_viewed=db.query(crud.Startup).count()
    )

