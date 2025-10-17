from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.database import engine
from backend.models import Base
from backend.routers import startups, analytics, ai, preferences
from backend.seed_data import seed_startups

app = FastAPI(
    title="StartupSwipe API",
    description="Backend API for the StartupSwipe mobile app",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(startups.router)
app.include_router(analytics.router)
app.include_router(ai.router)
app.include_router(preferences.router)

@app.on_event("startup")
async def startup_event():
    """Create tables and seed data on startup"""
    Base.metadata.create_all(bind=engine)
    seed_startups()

@app.get("/")
def root():
    return {
        "message": "Welcome to StartupSwipe API",
        "docs": "/docs",
        "version": "1.0.0"
    }

@app.get("/health")
def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

