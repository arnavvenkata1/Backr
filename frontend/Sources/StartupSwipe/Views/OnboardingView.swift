import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            // Dark background
            Color.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                progressBar
                
                // Content
                TabView(selection: $viewModel.currentStep) {
                    WelcomeStep()
                        .tag(0)
                    SectorSelectionStep(preferences: $viewModel.preferences)
                        .tag(1)
                    WorkFieldStep(preferences: $viewModel.preferences)
                        .tag(2)
                    InvestmentStageStep(preferences: $viewModel.preferences)
                        .tag(3)
                    InvestmentDetailsStep(preferences: $viewModel.preferences)
                        .tag(4)
                    LocationStep(preferences: $viewModel.preferences)
                        .tag(5)
                    GoalsStep(preferences: $viewModel.preferences)
                        .tag(6)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.currentStep)
                
                // Navigation buttons
                navigationButtons
            }
        }
    }
    
    private var progressBar: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Step \(viewModel.currentStep + 1) of \(viewModel.totalSteps)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
                Spacer()
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.darkCard)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color.accentPrimary, Color.accentPrimary.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * viewModel.progressPercentage, height: 6)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.progressPercentage)
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if viewModel.currentStep > 0 {
                Button {
                    viewModel.previousStep()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.darkCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.textTertiary.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
            }
            
            Button {
                if viewModel.currentStep == viewModel.totalSteps - 1 {
                    viewModel.completeOnboarding()
                    viewModel.savePreferences()
                    showOnboarding = true // Set to true to indicate completion
                } else {
                    viewModel.nextStep()
                    viewModel.savePreferences()
                }
            } label: {
                HStack {
                    Text(viewModel.currentStep == viewModel.totalSteps - 1 ? "Get Started" : "Continue")
                    if viewModel.currentStep < viewModel.totalSteps - 1 {
                        Image(systemName: "chevron.right")
                    }
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: viewModel.canProceed() ? 
                                    [Color.accentPrimary, Color.accentPrimary.opacity(0.8)] :
                                    [Color.darkCard, Color.darkCard.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: viewModel.canProceed() ? Color.accentPrimary.opacity(0.3) : .clear, radius: 12, y: 6)
                )
            }
            .disabled(!viewModel.canProceed())
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
}

// MARK: - Welcome Step
struct WelcomeStep: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color("Accent").opacity(0.2), Color("Accent").opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                
                Text("🚀")
                    .font(.system(size: 70))
            }
            
            VStack(spacing: 16) {
                Text("Welcome to BackR")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Let's personalize your experience to help you discover startups that match your investment goals")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(24)
    }
}

// MARK: - Sector Selection Step
struct SectorSelectionStep: View {
    @Binding var preferences: UserPreferences
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("What sectors interest you?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("Select all that apply")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                }
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(OnboardingOptions.sectors, id: \.self) { sector in
                        SectorButton(
                            title: sector,
                            isSelected: preferences.selectedSectors.contains(sector)
                        ) {
                            if preferences.selectedSectors.contains(sector) {
                                preferences.selectedSectors.removeAll { $0 == sector }
                            } else {
                                preferences.selectedSectors.append(sector)
                            }
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}

struct SectorButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(isSelected ? Color.darkBackground : Color.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isSelected ? Color.accentPrimary : Color.darkCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.accentPrimary.opacity(0.3), lineWidth: 1.5)
                        )
                        .shadow(color: isSelected ? Color.accentPrimary.opacity(0.3) : .clear, radius: 8, y: 4)
                )
        }
    }
}

// MARK: - Work Field Step
struct WorkFieldStep: View {
    @Binding var preferences: UserPreferences
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("What field do you work in?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("This helps us understand your expertise")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                }
                
                VStack(spacing: 12) {
                    ForEach(OnboardingOptions.workFields, id: \.self) { field in
                        SelectionRow(
                            title: field,
                            isSelected: preferences.workField == field
                        ) {
                            preferences.workField = field
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}

// MARK: - Investment Stage Step
struct InvestmentStageStep: View {
    @Binding var preferences: UserPreferences
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Preferred funding stages?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("Select all stages you're interested in")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                }
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(OnboardingOptions.fundingStages, id: \.self) { stage in
                        SectorButton(
                            title: stage,
                            isSelected: preferences.investmentStage.contains(stage)
                        ) {
                            if preferences.investmentStage.contains(stage) {
                                preferences.investmentStage.removeAll { $0 == stage }
                            } else {
                                preferences.investmentStage.append(stage)
                            }
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}

// MARK: - Investment Details Step
struct InvestmentDetailsStep: View {
    @Binding var preferences: UserPreferences
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Investment preferences")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("Tell us about your investment style")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Investment Range")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    VStack(spacing: 10) {
                        ForEach(UserPreferences.InvestmentRange.allCases, id: \.self) { range in
                            SelectionRow(
                                title: range.rawValue,
                                isSelected: preferences.investmentRange == range
                            ) {
                                preferences.investmentRange = range
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Risk Tolerance")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    VStack(spacing: 10) {
                        ForEach(UserPreferences.RiskTolerance.allCases, id: \.self) { risk in
                            SelectionRow(
                                title: risk.rawValue,
                                isSelected: preferences.riskTolerance == risk
                            ) {
                                preferences.riskTolerance = risk
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Experience Level")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    VStack(spacing: 10) {
                        ForEach(UserPreferences.ExperienceLevel.allCases, id: \.self) { level in
                            SelectionRow(
                                title: level.rawValue,
                                isSelected: preferences.experienceLevel == level
                            ) {
                                preferences.experienceLevel = level
                            }
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}

// MARK: - Location Step
struct LocationStep: View {
    @Binding var preferences: UserPreferences
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Preferred locations?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("Where do you want to invest?")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                }
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(OnboardingOptions.locations, id: \.self) { location in
                        SectorButton(
                            title: location,
                            isSelected: preferences.preferredLocations.contains(location)
                        ) {
                            if preferences.preferredLocations.contains(location) {
                                preferences.preferredLocations.removeAll { $0 == location }
                            } else {
                                preferences.preferredLocations.append(location)
                            }
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}

// MARK: - Goals Step
struct GoalsStep: View {
    @Binding var preferences: UserPreferences
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your investment goal?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("What matters most to you?")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                }
                
                VStack(spacing: 12) {
                    ForEach(OnboardingOptions.investmentGoals, id: \.self) { goal in
                        SelectionRow(
                            title: goal,
                            isSelected: preferences.investmentGoal == goal
                        ) {
                            preferences.investmentGoal = goal
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}

// MARK: - Reusable Components
struct SelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.accentPrimary : Color.textTertiary.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.accentPrimary)
                            .frame(width: 14, height: 14)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.accentPrimary.opacity(0.2) : Color.darkCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? Color.accentPrimary.opacity(0.5) : Color.textTertiary.opacity(0.3), lineWidth: 1.5)
                    )
                    .shadow(color: isSelected ? Color.accentPrimary.opacity(0.2) : .clear, radius: 8, y: 4)
            )
        }
    }
}

