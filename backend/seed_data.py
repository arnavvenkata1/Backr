from backend.database import engine, SessionLocal
from backend.models import Base, Startup
import json

def create_tables():
    Base.metadata.create_all(bind=engine)

def seed_startups():
    db = SessionLocal()
    
    # Check if data already exists
    if db.query(Startup).count() > 0:
        print("Database already seeded")
        db.close()
        return
    
    startups_data = [
        # FinTech
        {
            "name": "PayNova", "sector": "FinTech", 
            "description": "AI-powered payment processing platform reducing transaction fees by 60% through blockchain optimization.",
            "valuation": 850.0, "revenue": 120.0, "growth_rate": 340.0,
            "funding_stage": "Series B", "employees": 145, 
            "website": "paynova.io", "location": "San Francisco, CA"
        },
        {
            "name": "CreditWise AI", "sector": "FinTech",
            "description": "Machine learning credit scoring for underbanked populations in emerging markets.",
            "valuation": 420.0, "revenue": 48.0, "growth_rate": 280.0,
            "funding_stage": "Series A", "employees": 78,
            "website": "creditwise.ai", "location": "New York, NY"
        },
        {
            "name": "WealthFlow", "sector": "FinTech",
            "description": "Automated investment platform with personalized portfolio management for millennials.",
            "valuation": 1200.0, "revenue": 180.0, "growth_rate": 220.0,
            "funding_stage": "Series C", "employees": 230,
            "website": "wealthflow.com", "location": "Austin, TX"
        },
        {
            "name": "BlockTrade", "sector": "FinTech",
            "description": "Decentralized trading platform for crypto derivatives and tokenized assets.",
            "valuation": 650.0, "revenue": 95.0, "growth_rate": 410.0,
            "funding_stage": "Series B", "employees": 112,
            "website": "blocktrade.io", "location": "Miami, FL"
        },
        
        # HealthTech
        {
            "name": "MediScan Pro", "sector": "HealthTech",
            "description": "AI diagnostic imaging tool with 98% accuracy in early cancer detection.",
            "valuation": 1500.0, "revenue": 210.0, "growth_rate": 195.0,
            "funding_stage": "Series C", "employees": 340,
            "website": "mediscanpro.health", "location": "Boston, MA"
        },
        {
            "name": "TeleCare Now", "sector": "HealthTech",
            "description": "24/7 virtual healthcare platform connecting patients with specialists instantly.",
            "valuation": 890.0, "revenue": 145.0, "growth_rate": 310.0,
            "funding_stage": "Series B", "employees": 189,
            "website": "telecarenow.com", "location": "Seattle, WA"
        },
        {
            "name": "GenomeHealth", "sector": "HealthTech",
            "description": "Personalized medicine platform using genetic data to optimize treatment plans.",
            "valuation": 2100.0, "revenue": 280.0, "growth_rate": 160.0,
            "funding_stage": "Series D", "employees": 450,
            "website": "genomehealth.bio", "location": "San Diego, CA"
        },
        {
            "name": "MindfulAI", "sector": "HealthTech",
            "description": "Mental health app using AI to provide personalized therapy and meditation.",
            "valuation": 380.0, "revenue": 52.0, "growth_rate": 390.0,
            "funding_stage": "Series A", "employees": 65,
            "website": "mindfulai.app", "location": "Los Angeles, CA"
        },
        
        # AI & Machine Learning
        {
            "name": "NeuralForge", "sector": "AI & ML",
            "description": "Enterprise AI platform automating complex business processes with custom models.",
            "valuation": 1800.0, "revenue": 240.0, "growth_rate": 270.0,
            "funding_stage": "Series C", "employees": 380,
            "website": "neuralforge.ai", "location": "Palo Alto, CA"
        },
        {
            "name": "DataMesh", "sector": "AI & ML",
            "description": "Real-time data analytics platform with predictive modeling for retail and e-commerce.",
            "valuation": 950.0, "revenue": 135.0, "growth_rate": 300.0,
            "funding_stage": "Series B", "employees": 175,
            "website": "datamesh.io", "location": "Chicago, IL"
        },
        {
            "name": "VisionAI Labs", "sector": "AI & ML",
            "description": "Computer vision solutions for autonomous vehicles and industrial automation.",
            "valuation": 1350.0, "revenue": 190.0, "growth_rate": 245.0,
            "funding_stage": "Series C", "employees": 280,
            "website": "visionailabs.com", "location": "Detroit, MI"
        },
        {
            "name": "ChatGenius", "sector": "AI & ML",
            "description": "Conversational AI for customer service with multi-language support and sentiment analysis.",
            "valuation": 720.0, "revenue": 98.0, "growth_rate": 350.0,
            "funding_stage": "Series B", "employees": 140,
            "website": "chatgenius.tech", "location": "San Francisco, CA"
        },
        
        # GreenTech
        {
            "name": "SolarGrid", "sector": "GreenTech",
            "description": "Smart solar panel network with AI-optimized energy distribution and storage.",
            "valuation": 1600.0, "revenue": 220.0, "growth_rate": 210.0,
            "funding_stage": "Series C", "employees": 310,
            "website": "solargrid.energy", "location": "Phoenix, AZ"
        },
        {
            "name": "OceanClean", "sector": "GreenTech",
            "description": "Autonomous drones removing plastic waste from oceans with biodegradable collection systems.",
            "valuation": 480.0, "revenue": 62.0, "growth_rate": 425.0,
            "funding_stage": "Series A", "employees": 95,
            "website": "oceanclean.eco", "location": "San Diego, CA"
        },
        {
            "name": "CarbonNeutral", "sector": "GreenTech",
            "description": "Carbon offset marketplace connecting businesses with verified green projects worldwide.",
            "valuation": 780.0, "revenue": 115.0, "growth_rate": 290.0,
            "funding_stage": "Series B", "employees": 155,
            "website": "carbonneutral.green", "location": "Portland, OR"
        },
        {
            "name": "BatteryNext", "sector": "GreenTech",
            "description": "Next-gen solid-state batteries with 3x longer life and 50% faster charging.",
            "valuation": 2400.0, "revenue": 310.0, "growth_rate": 180.0,
            "funding_stage": "Series D", "employees": 520,
            "website": "batterynext.tech", "location": "Austin, TX"
        },
        
        # Consumer Tech
        {
            "name": "ShopSmart", "sector": "Consumer Tech",
            "description": "AR shopping app that lets users visualize products in their home before buying.",
            "valuation": 620.0, "revenue": 88.0, "growth_rate": 360.0,
            "funding_stage": "Series B", "employees": 125,
            "website": "shopsmart.app", "location": "New York, NY"
        },
        {
            "name": "FoodieAI", "sector": "Consumer Tech",
            "description": "Personalized meal planning app with AI nutritionist and grocery delivery integration.",
            "valuation": 340.0, "revenue": 45.0, "growth_rate": 410.0,
            "funding_stage": "Series A", "employees": 68,
            "website": "foodieai.app", "location": "Los Angeles, CA"
        },
        {
            "name": "HomeSync", "sector": "Consumer Tech",
            "description": "Smart home ecosystem unifying all IoT devices with voice and gesture control.",
            "valuation": 1100.0, "revenue": 165.0, "growth_rate": 255.0,
            "funding_stage": "Series B", "employees": 215,
            "website": "homesync.io", "location": "Seattle, WA"
        },
        {
            "name": "FitTrack Pro", "sector": "Consumer Tech",
            "description": "Wearable fitness tracker with real-time health coaching and doctor integration.",
            "valuation": 580.0, "revenue": 78.0, "growth_rate": 330.0,
            "funding_stage": "Series B", "employees": 105,
            "website": "fittrackpro.fit", "location": "Denver, CO"
        },
        
        # B2B SaaS
        {
            "name": "CloudOps", "sector": "B2B SaaS",
            "description": "DevOps automation platform reducing deployment time by 80% with zero downtime.",
            "valuation": 1450.0, "revenue": 200.0, "growth_rate": 235.0,
            "funding_stage": "Series C", "employees": 295,
            "website": "cloudops.dev", "location": "San Francisco, CA"
        },
        {
            "name": "SalesForce AI", "sector": "B2B SaaS",
            "description": "AI-powered CRM predicting customer behavior and automating outreach campaigns.",
            "valuation": 890.0, "revenue": 128.0, "growth_rate": 310.0,
            "funding_stage": "Series B", "employees": 168,
            "website": "salesforceai.biz", "location": "Austin, TX"
        },
        {
            "name": "TeamFlow", "sector": "B2B SaaS",
            "description": "Collaborative workspace with integrated project management and communication tools.",
            "valuation": 725.0, "revenue": 102.0, "growth_rate": 275.0,
            "funding_stage": "Series B", "employees": 142,
            "website": "teamflow.work", "location": "Boston, MA"
        },
        {
            "name": "SecureCloud", "sector": "B2B SaaS",
            "description": "Enterprise cybersecurity platform with AI threat detection and automated response.",
            "valuation": 1950.0, "revenue": 265.0, "growth_rate": 190.0,
            "funding_stage": "Series C", "employees": 410,
            "website": "securecloud.security", "location": "Washington, DC"
        },
        
        # EdTech
        {
            "name": "LearnLab", "sector": "EdTech",
            "description": "Adaptive learning platform personalizing education paths with AI tutoring.",
            "valuation": 560.0, "revenue": 75.0, "growth_rate": 380.0,
            "funding_stage": "Series A", "employees": 92,
            "website": "learnlab.edu", "location": "Cambridge, MA"
        },
        {
            "name": "SkillBridge", "sector": "EdTech",
            "description": "Corporate training platform with VR simulations and skill certification.",
            "valuation": 810.0, "revenue": 118.0, "growth_rate": 295.0,
            "funding_stage": "Series B", "employees": 158,
            "website": "skillbridge.learn", "location": "Atlanta, GA"
        },
        {
            "name": "CodeAcademy Pro", "sector": "EdTech",
            "description": "Interactive coding bootcamp with guaranteed job placement and mentorship.",
            "valuation": 680.0, "revenue": 95.0, "growth_rate": 320.0,
            "funding_stage": "Series B", "employees": 128,
            "website": "codeacademypro.dev", "location": "San Francisco, CA"
        },
        {
            "name": "MathMaster AI", "sector": "EdTech",
            "description": "Math education app for K-12 with gamification and real-time progress tracking.",
            "valuation": 290.0, "revenue": 38.0, "growth_rate": 450.0,
            "funding_stage": "Seed", "employees": 48,
            "website": "mathmaster.app", "location": "Chicago, IL"
        },
        
        # AgriTech
        {
            "name": "FarmBot", "sector": "AgriTech",
            "description": "Autonomous farming robots with precision planting and harvesting capabilities.",
            "valuation": 920.0, "revenue": 135.0, "growth_rate": 285.0,
            "funding_stage": "Series B", "employees": 182,
            "website": "farmbot.ag", "location": "Des Moines, IA"
        },
        {
            "name": "CropSense", "sector": "AgriTech",
            "description": "IoT sensors and AI analytics optimizing crop yields and water usage.",
            "valuation": 540.0, "revenue": 72.0, "growth_rate": 340.0,
            "funding_stage": "Series A", "employees": 88,
            "website": "cropsense.farm", "location": "Sacramento, CA"
        },
        {
            "name": "AquaGrow", "sector": "AgriTech",
            "description": "Vertical farming system using hydroponic technology for urban agriculture.",
            "valuation": 710.0, "revenue": 98.0, "growth_rate": 305.0,
            "funding_stage": "Series B", "employees": 135,
            "website": "aquagrow.green", "location": "Portland, OR"
        },
        {
            "name": "BioFertilize", "sector": "AgriTech",
            "description": "Organic fertilizer from food waste with microbial enhancement for soil health.",
            "valuation": 380.0, "revenue": 48.0, "growth_rate": 395.0,
            "funding_stage": "Series A", "employees": 62,
            "website": "biofertilize.eco", "location": "Madison, WI"
        },
        
        # FashionTech
        {
            "name": "StyleAI", "sector": "FashionTech",
            "description": "AI personal stylist app creating outfits from your wardrobe with trend predictions.",
            "valuation": 450.0, "revenue": 58.0, "growth_rate": 370.0,
            "funding_stage": "Series A", "employees": 75,
            "website": "styleai.fashion", "location": "New York, NY"
        },
        {
            "name": "EcoWear", "sector": "FashionTech",
            "description": "Sustainable fashion marketplace with blockchain-verified ethical sourcing.",
            "valuation": 620.0, "revenue": 85.0, "growth_rate": 325.0,
            "funding_stage": "Series B", "employees": 118,
            "website": "ecowear.shop", "location": "Los Angeles, CA"
        },
        {
            "name": "VirtualFit", "sector": "FashionTech",
            "description": "AR virtual fitting room reducing returns by 70% with accurate body scanning.",
            "valuation": 530.0, "revenue": 68.0, "growth_rate": 355.0,
            "funding_stage": "Series A", "employees": 92,
            "website": "virtualfit.tech", "location": "San Francisco, CA"
        },
        {
            "name": "ThreadLink", "sector": "FashionTech",
            "description": "B2B platform connecting fashion designers with sustainable fabric suppliers.",
            "valuation": 340.0, "revenue": 42.0, "growth_rate": 420.0,
            "funding_stage": "Seed", "employees": 58,
            "website": "threadlink.supply", "location": "Miami, FL"
        },
        
        # PropTech
        {
            "name": "HomeMatch", "sector": "PropTech",
            "description": "AI-powered real estate platform matching buyers with perfect properties instantly.",
            "valuation": 1250.0, "revenue": 175.0, "growth_rate": 250.0,
            "funding_stage": "Series C", "employees": 245,
            "website": "homematch.realty", "location": "New York, NY"
        },
        {
            "name": "RentEasy", "sector": "PropTech",
            "description": "Digital rental platform with virtual tours, instant approval, and smart contracts.",
            "valuation": 680.0, "revenue": 92.0, "growth_rate": 315.0,
            "funding_stage": "Series B", "employees": 132,
            "website": "renteasy.app", "location": "Austin, TX"
        },
        {
            "name": "BuildSmart", "sector": "PropTech",
            "description": "Construction project management with AI cost prediction and resource optimization.",
            "valuation": 840.0, "revenue": 122.0, "growth_rate": 280.0,
            "funding_stage": "Series B", "employees": 165,
            "website": "buildsmart.pro", "location": "Seattle, WA"
        },
        {
            "name": "CoLive", "sector": "PropTech",
            "description": "Co-living spaces for digital nomads with flexible leases and community events.",
            "valuation": 490.0, "revenue": 64.0, "growth_rate": 365.0,
            "funding_stage": "Series A", "employees": 82,
            "website": "colive.space", "location": "Miami, FL"
        },
    ]
    
    for data in startups_data:
        startup = Startup(**data)
        db.add(startup)
    
    db.commit()
    print(f"Successfully seeded {len(startups_data)} startups")
    db.close()

if __name__ == "__main__":
    create_tables()
    seed_startups()

