from sqlalchemy import Column, Integer, String, Float, Boolean, Text
from backend.database import Base

class Startup(Base):
    __tablename__ = "startups"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    sector = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    valuation = Column(Float, nullable=False)  # in millions
    revenue = Column(Float, nullable=False)  # in millions
    growth_rate = Column(Float, nullable=False)  # percentage
    funding_stage = Column(String, nullable=False)
    employees = Column(Integer, nullable=False)
    website = Column(String, nullable=True)
    location = Column(String, nullable=False)
    user_interest_score = Column(Float, default=0.0)
    ai_summary = Column(Text, nullable=True)  # JSON string
    similarity_vector = Column(Text, nullable=True)  # JSON string for embeddings
    is_saved = Column(Boolean, default=False)

