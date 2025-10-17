# StartupSwipe - Tinder for Startups

A modern iOS app for discovering and investing in startups with a swipe-based interface, powered by FastAPI backend and AI-driven insights.

## Features

### Frontend (iOS - SwiftUI)
- 🎯 **Smart Onboarding Survey** - 7-step personalized questionnaire to understand your:
  - Sector interests (FinTech, HealthTech, AI, Fashion, etc.)
  - Work field and expertise
  - Investment stage preferences (Seed, Series A/B/C, etc.)
  - Investment range and risk tolerance
  - Preferred locations
  - Investment goals
- 🔥 **Tinder-like swiping interface** for discovering startups
- 💼 **Detailed company profiles** with AI analysis, mission statements, and 5-year vision
- 📊 **Personalized match scores** (AI-powered similarity scoring)
- 💾 **Save companies** you're interested in
- 📈 **Investment insights** dashboard with activity tracking
- 🎨 **Modern, clean UI** with light theme, emoji logos, and sector-specific colors

### Backend (Python - FastAPI)
- 🚀 40 seed startups across 11 sectors (FinTech, HealthTech, AI/ML, GreenTech, etc.)
- 🤖 AI-powered analysis using OpenAI GPT
- 📊 Analytics and sector insights
- 🔍 Similarity scoring using embeddings
- 💾 SQLite database with SQLAlchemy ORM

## Project Structure

```
Backr/
├── frontend/
│   ├── Sources/StartupSwipe/
│   │   ├── App/
│   │   │   └── StartupSwipeApp.swift
│   │   ├── Models/
│   │   │   └── Startup.swift
│   │   ├── Views/
│   │   │   ├── DiscoverView.swift
│   │   │   ├── SwipeDeckView.swift
│   │   │   ├── StartupCardView.swift
│   │   │   ├── SavedView.swift
│   │   │   ├── StartupDetailView.swift
│   │   │   ├── InsightsView.swift
│   │   │   └── MainTabView.swift
│   │   ├── ViewModels/
│   │   │   └── SwipeDeckViewModel.swift
│   │   └── Services/
│   │       └── APIService.swift
│   ├── Resources/
│   │   ├── Assets.xcassets/
│   │   └── Info.plist
│   └── project.yml (XcodeGen config)
│
└── backend/
    ├── main.py
    ├── models.py
    ├── schemas.py
    ├── crud.py
    ├── database.py
    ├── seed_data.py
    ├── openai_utils.py
    ├── requirements.txt
    └── routers/
        ├── startups.py
        ├── analytics.py
        └── ai.py
```

## Setup Instructions

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Create virtual environment:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

4. **Set up environment variables:**
   Create a `.env` file in the backend directory:
   ```
   OPENAI_API_KEY=your_openai_api_key_here
   ```

5. **Run the server:**
   ```bash
   python -m uvicorn backend.main:app --reload
   ```

   The API will be available at: `http://localhost:8000`
   API docs at: `http://localhost:8000/docs`

### Frontend Setup

1. **Install XcodeGen** (if not already installed):
   ```bash
   brew install xcodegen
   ```

2. **Navigate to frontend directory:**
   ```bash
   cd frontend
   ```

3. **Generate Xcode project:**
   ```bash
   xcodegen generate
   ```

4. **Open in Xcode:**
   ```bash
   open StartupSwipe.xcodeproj
   ```

5. **Run the app:**
   - Select a simulator (iPhone 15 Pro recommended)
   - Press `Cmd+R` to build and run

## API Endpoints

### Startups
- `GET /api/startups` - Get list of startups for swiping
- `GET /api/startup/{id}` - Get detailed startup info
- `POST /api/save/{id}` - Save a startup
- `DELETE /api/save/{id}` - Remove saved startup
- `GET /api/saved` - Get all saved startups

### Analytics
- `GET /api/analytics` - Get sector distribution and metrics

### AI
- `GET /api/ai-analysis/{id}` - Get AI-powered startup analysis
- `GET /api/similar/{id}` - Get similar startups

## Features in Detail

### Discover Tab
- Swipe right (❤️) to save startups you're interested in
- Swipe left (❌) to skip
- Rewind button (↩️) to undo last action
- Each card shows:
  - Company name and sector
  - Match score (AI-calculated)
  - Description
  - Location and momentum indicator
  - Key metrics (Valuation, Revenue, Growth, Stage)

### Saved Tab
- View all saved companies
- Tap any company to see detailed analysis
- Remove companies from saved list

### Detailed View (tap on saved company)
- Comprehensive company information
- Financial metrics with trends
- AI-powered analysis (Investment Score, Risk Level, Exit Potential)
- Team & culture insights
- Market analysis

### Insights Tab
- Track saved vs skipped count
- View recent activity
- Investment statistics

## Technologies Used

### Frontend
- SwiftUI (iOS 17.0+)
- XcodeGen for project management
- URLSession for networking
- Codable for JSON parsing

### Backend
- FastAPI (async Python web framework)
- SQLAlchemy (ORM)
- SQLite (database)
- OpenAI API (GPT-4 for analysis, embeddings for similarity)
- Pydantic (data validation)
- NumPy & scikit-learn (similarity calculations)

## Development Notes

- The app falls back to mock data if the backend is unavailable
- All colors are defined in Assets.xcassets for easy theming
- The UI is optimized for iPhone but works on all iOS devices
- Backend automatically seeds database on first run

## Future Enhancements

- [ ] User authentication
- [ ] Investment portfolio tracking
- [ ] Push notifications for new startups
- [ ] Advanced filtering by sector/stage
- [ ] Social features (share startups)
- [ ] Integration with actual startup databases
- [ ] Real-time collaboration features

## License

MIT License - Feel free to use this project for learning and development.

