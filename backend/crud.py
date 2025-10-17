from sqlalchemy.orm import Session
from backend.models import Startup
from typing import List, Optional

def get_startups(db: Session, limit: int = 10, offset: int = 0) -> List[Startup]:
    """Get a list of startups for swiping"""
    return db.query(Startup).filter(Startup.is_saved == False).offset(offset).limit(limit).all()

def get_startup_by_id(db: Session, startup_id: int) -> Optional[Startup]:
    """Get a single startup by ID"""
    return db.query(Startup).filter(Startup.id == startup_id).first()

def save_startup(db: Session, startup_id: int) -> Optional[Startup]:
    """Mark a startup as saved"""
    startup = db.query(Startup).filter(Startup.id == startup_id).first()
    if startup:
        startup.is_saved = True
        db.commit()
        db.refresh(startup)
    return startup

def unsave_startup(db: Session, startup_id: int) -> bool:
    """Remove a startup from saved"""
    startup = db.query(Startup).filter(Startup.id == startup_id).first()
    if startup:
        startup.is_saved = False
        db.commit()
        return True
    return False

def get_saved_startups(db: Session) -> List[Startup]:
    """Get all saved startups"""
    return db.query(Startup).filter(Startup.is_saved == True).all()

def get_sector_distribution(db: Session) -> dict:
    """Get count of startups by sector"""
    result = {}
    startups = db.query(Startup).all()
    for startup in startups:
        if startup.sector in result:
            result[startup.sector] += 1
        else:
            result[startup.sector] = 1
    return result

def get_avg_growth_by_sector(db: Session) -> dict:
    """Get average growth rate by sector"""
    result = {}
    sector_totals = {}
    sector_counts = {}
    
    startups = db.query(Startup).all()
    for startup in startups:
        if startup.sector not in sector_totals:
            sector_totals[startup.sector] = 0
            sector_counts[startup.sector] = 0
        sector_totals[startup.sector] += startup.growth_rate
        sector_counts[startup.sector] += 1
    
    for sector in sector_totals:
        result[sector] = sector_totals[sector] / sector_counts[sector]
    
    return result

def get_funding_stage_counts(db: Session) -> dict:
    """Get count of startups by funding stage"""
    result = {}
    startups = db.query(Startup).all()
    for startup in startups:
        if startup.funding_stage in result:
            result[startup.funding_stage] += 1
        else:
            result[startup.funding_stage] = 1
    return result

