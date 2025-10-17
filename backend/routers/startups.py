from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from backend.database import get_db
from backend import crud, schemas

router = APIRouter(prefix="/api", tags=["startups"])

@router.get("/startups", response_model=List[schemas.StartupCard])
def list_startups(limit: int = 10, offset: int = 0, db: Session = Depends(get_db)):
    """Get a list of startups for swiping"""
    startups = crud.get_startups(db, limit=limit, offset=offset)
    return startups

@router.get("/startup/{startup_id}", response_model=schemas.StartupDetail)
def get_startup(startup_id: int, db: Session = Depends(get_db)):
    """Get detailed information about a specific startup"""
    startup = crud.get_startup_by_id(db, startup_id)
    if not startup:
        raise HTTPException(status_code=404, detail="Startup not found")
    return startup

@router.post("/save/{startup_id}", response_model=schemas.SaveResponse)
def save_startup(startup_id: int, db: Session = Depends(get_db)):
    """Save a startup to favorites"""
    startup = crud.save_startup(db, startup_id)
    if not startup:
        raise HTTPException(status_code=404, detail="Startup not found")
    return schemas.SaveResponse(success=True, message=f"Saved {startup.name}")

@router.delete("/save/{startup_id}", response_model=schemas.SaveResponse)
def remove_saved_startup(startup_id: int, db: Session = Depends(get_db)):
    """Remove a startup from saved"""
    success = crud.unsave_startup(db, startup_id)
    if not success:
        raise HTTPException(status_code=404, detail="Startup not found")
    return schemas.SaveResponse(success=True, message="Startup removed from saved")

@router.get("/saved", response_model=List[schemas.StartupCard])
def list_saved(db: Session = Depends(get_db)):
    """Get all saved startups"""
    return crud.get_saved_startups(db)

