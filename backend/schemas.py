from pydantic import BaseModel
from typing import Optional, List, Dict

class StartupBase(BaseModel):
    name: str
    sector: str
    description: str
    valuation: float
    revenue: float
    growth_rate: float
    funding_stage: str
    employees: int
    website: Optional[str] = None
    location: str

class StartupCard(StartupBase):
    id: int
    
    class Config:
        from_attributes = True

class StartupDetail(StartupCard):
    ai_summary: Optional[str] = None
    is_saved: bool = False
    
    class Config:
        from_attributes = True

class SaveResponse(BaseModel):
    success: bool
    message: str

class AnalyticsResponse(BaseModel):
    sector_distribution: Dict[str, int]
    avg_growth_by_sector: Dict[str, float]
    funding_stage_counts: Dict[str, int]
    total_saved: int
    total_viewed: int

class AIAnalysis(BaseModel):
    strengths: List[str]
    risks: List[str]
    market_opportunity: str
    recommendation: str
    confidence_score: float

class SimilarStartup(BaseModel):
    id: int
    name: str
    sector: str
    similarity_score: float
    
    class Config:
        from_attributes = True

