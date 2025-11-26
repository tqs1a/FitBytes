//
//  ContentView.swift
//  TestApp
//
//  Created by Leon  on 09.10.25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var selectedTab = 0
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
                    .transition(.opacity)
            } else {
                TabView(selection: $selectedTab) {
                    MainDashboardView()
                        .tabItem {
                            Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            Text(LocalizedKey.tabHome.localized())
                        }
                        .tag(0)
                    
                    ActivityFeedView()
                        .tabItem {
                            Image(systemName: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                            Text(LocalizedKey.tabActivity.localized())
                        }
                        .tag(1)
                    
                    CustomProgressView()
                        .tabItem {
                            Image(systemName: selectedTab == 2 ? "chart.line.uptrend.xyaxis.circle.fill" : "chart.line.uptrend.xyaxis")
                            Text(LocalizedKey.tabProgress.localized())
                        }
                        .tag(2)
                    
                    EnhancedProfileView()
                        .tabItem {
                            Image(systemName: selectedTab == 3 ? "person.circle.fill" : "person.circle")
                            Text(LocalizedKey.tabProfile.localized())
                        }
                        .tag(3)
                }
                .accentColor(.navyAccent)
                .background(Color.amoledBlack)
                .preferredColorScheme(.dark)
                .transition(.opacity)
                .id(localization.selectedLanguage) // Force view refresh on language change
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Custom Colors
extension Color {
    static let midnightNavy = Color(red: 0.05, green: 0.1, blue: 0.2)
    static let navyAccent = Color(red: 0.1, green: 0.3, blue: 0.6)
    static let amoledBlack = Color(red: 0.0, green: 0.0, blue: 0.0)
    static let darkGrayCustom = Color(red: 0.33, green: 0.33, blue: 0.33)
}

// MARK: - Loading View
struct LoadingView: View {
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.amoledBlack
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.navyAccent.opacity(0.3), .midnightNavy.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [.navyAccent, .midnightNavy],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: rotationAngle)
                    
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundColor(.navyAccent)
                        .scaleEffect(scale)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: scale)
                }
                
                VStack(spacing: 12) {
                    Text("Fitness Tracker")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(LocalizedKey.readyForWorkout.localized())
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .onAppear {
            rotationAngle = 360
            scale = 1.2
        }
    }
}

// MARK: - Main Dashboard View
struct MainDashboardView: View {
    @ObservedObject private var localization = LocalizationManager.shared
    @ObservedObject private var statsPrefs = HomeStatsPreferences.shared
    @State private var showingEditStats = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Welcome Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(LocalizedKey.welcomeBack.localized())
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text(LocalizedKey.readyForWorkout.localized())
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Button(action: { showingSettings = true }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundColor(.navyAccent)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [.white.opacity(0.15), .white.opacity(0.08)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Quick Actions Card
                    VStack(spacing: 20) {
                        Text(LocalizedKey.quickActions.localized())
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 16) {
                            NavigationLink {
                                ProgramListView()
                            } label: {
                                QuickActionCard(
                                    title: LocalizedKey.workoutStart.localized(),
                                    subtitle: LocalizedKey.quickTraining.localized(),
                                    icon: "figure.strengthtraining.traditional",
                                    color: .navyAccent
                                )
                            }
                            
                            NavigationLink {
                                NutritionDetailView()
                            } label: {
                                QuickActionCard(
                                    title: LocalizedKey.nutritionTrack.localized(),
                                    subtitle: LocalizedKey.trackCalories.localized(),
                                    icon: "fork.knife",
                                    color: .green
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Today's Overview with Edit Button
                    TodayOverviewCard(onEditStats: {
                        showingEditStats = true
                    })
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.amoledBlack)
            .navigationTitle(LocalizedKey.tabHome.localized())
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showingEditStats) {
                EditHomeStatsView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

// Quick Action Card Component
struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 36, weight: .medium))
                .foregroundColor(color)
                .frame(width: 64, height: 64)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.25), color.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.3), lineWidth: 2)
                        )
                )
            
            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.15), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
    }
}

// Today's Overview Card - Redesigned with Apple HIG
struct TodayOverviewCard: View {
    @ObservedObject private var statsPrefs = HomeStatsPreferences.shared
    @ObservedObject private var localization = LocalizationManager.shared
    let onEditStats: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text(LocalizedKey.today.localized())
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Text(DateFormatter.dayFormatter.string(from: Date()))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.1))
                        )
                    
                    Button(action: onEditStats) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.navyAccent)
                    }
                }
            }
            
            // Dynamic Stats Grid
            if statsPrefs.enabledStats.isEmpty {
                EmptyStatsView(onEdit: onEditStats)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(statsPrefs.getEnabledStatsData()) { statData in
                        DynamicStatCard(statData: statData)
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.15), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 8)
    }
}

// Empty Stats View
struct EmptyStatsView: View {
    let onEdit: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(.white.opacity(0.3))
            
            Text("No stats selected")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
            
            Button(action: onEdit) {
                Text("Customize Stats")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.navyAccent)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.navyAccent.opacity(0.2))
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// Dynamic Stat Card
struct DynamicStatCard: View {
    let statData: StatData
    
    var body: some View {
        VStack(spacing: 12) {
            // Circular Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 6)
                    .frame(width: 64, height: 64)
                
                Circle()
                    .trim(from: 0, to: statData.progress)
                    .stroke(
                        LinearGradient(
                            colors: [.navyAccent, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 64, height: 64)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8), value: statData.progress)
                
                Image(systemName: statData.type.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.navyAccent)
            }
            
            VStack(spacing: 4) {
                Text(statData.currentValue)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(statData.type.displayName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
                
                if !statData.type.unit.isEmpty {
                    Text("\(LocalizedKey.of.localized()) \(statData.goalValue) \(statData.type.unit)")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.midnightNavy.opacity(0.4), .midnightNavy.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.navyAccent.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Activity Feed View
struct ActivityFeedView: View {
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var selectedPeriod: TimePeriod = .today
    
    enum TimePeriod: String, CaseIterable {
        case today
        case week
        
        func localizedName() -> String {
            switch self {
            case .today: return LocalizedKey.todayPeriod.localized()
            case .week: return LocalizedKey.weekPeriod.localized()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Period Selector
                    HStack(spacing: 12) {
                        ForEach(TimePeriod.allCases, id: \.self) { period in
                            PeriodButton(
                                period: period,
                                selectedPeriod: selectedPeriod
                            ) {
                                selectedPeriod = period
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // AI Overview Card
                    AIOverviewCard(period: selectedPeriod)
                        .padding(.horizontal, 20)
                    
                    // Activity Feed
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedKey.activities.localized())
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(ActivityFeedItem.sampleData(for: selectedPeriod), id: \.id) { item in
                                ActivityFeedItemCard(item: item)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.amoledBlack)
            .navigationTitle(LocalizedKey.tabActivity.localized())
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct PeriodButton: View {
    let period: ActivityFeedView.TimePeriod
    let selectedPeriod: ActivityFeedView.TimePeriod
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(period.localizedName())
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(selectedPeriod == period ? .white : .white.opacity(0.6))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedPeriod == period ? 
                              LinearGradient(colors: [.navyAccent, .navyAccent.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                              LinearGradient(colors: [.white.opacity(0.1), .white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                )
                .shadow(color: selectedPeriod == period ? .navyAccent.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
    }
}

struct AIOverviewCard: View {
    let period: ActivityFeedView.TimePeriod
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.navyAccent)
                
                Text(LocalizedKey.aiOverview.localized())
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(period.localizedName())
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.1))
                    )
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(period == .today ?
                     "Today you've already taken 8,420 steps and burned 1,850 calories. You're on track to reach your daily goal!" :
                     "This week was very active! You averaged 9,200 steps per day and completed 5 workouts. Your progress is impressive!")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(nil)
                
                if period == .week {
                    HStack(spacing: 16) {
                        StatPill(title: "5", subtitle: LocalizedKey.workouts.localized())
                        StatPill(title: "64,400", subtitle: LocalizedKey.steps.localized())
                        StatPill(title: "12,950", subtitle: LocalizedKey.calories.localized())
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.15), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
    }
}

struct StatPill: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.navyAccent)
            
            Text(subtitle)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.navyAccent.opacity(0.15))
        )
    }
}

struct ActivityFeedItem {
    let id = UUID()
    let title: String
    let description: String
    let time: String
    let icon: String
    let color: Color
    
    static func sampleData(for period: ActivityFeedView.TimePeriod) -> [ActivityFeedItem] {
        if period == .today {
            return [
                ActivityFeedItem(title: "Running", description: "30 minutes in the park", time: "14:30", icon: "figure.run", color: .navyAccent),
                ActivityFeedItem(title: "Lunch", description: "Healthy bowl with 650 kcal", time: "12:45", icon: "fork.knife", color: .green),
                ActivityFeedItem(title: "Water", description: "2 glasses drank", time: "11:20", icon: "drop", color: .cyan),
                ActivityFeedItem(title: "Breakfast", description: "Oatmeal with berries", time: "08:15", icon: "sun.max", color: .orange)
            ]
        } else {
            return [
                ActivityFeedItem(title: "Strength Training", description: "45 minutes at the gym", time: "Yesterday", icon: "dumbbell", color: .navyAccent),
                ActivityFeedItem(title: "Yoga", description: "60 minutes of relaxation", time: "Monday", icon: "figure.yoga", color: .purple),
                ActivityFeedItem(title: "Swimming", description: "40 minutes laps", time: "Sunday", icon: "figure.pool.swim", color: .cyan),
                ActivityFeedItem(title: "Cycling", description: "25 minutes city ride", time: "Saturday", icon: "bicycle", color: .green)
            ]
        }
    }
}

struct ActivityFeedItemCard: View {
    let item: ActivityFeedItem
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(item.color)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [item.color.opacity(0.25), item.color.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Circle()
                                .stroke(item.color.opacity(0.3), lineWidth: 1)
                        )
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(item.description)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text(item.time)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.12), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Progress View (renamed to avoid conflict)
struct CustomProgressView: View {
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var progress: Double = 0.0
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Progress Ring
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.15), lineWidth: 18)
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                LinearGradient(
                                    colors: [.navyAccent, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 18, lineCap: .round)
                            )
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(-90))
                            .animation(.spring(response: 1.5, dampingFraction: 0.7), value: progress)
                        
                        VStack(spacing: 8) {
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(LocalizedKey.dailyGoal.localized())
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(40)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.15), .white.opacity(0.08)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                    .scaleEffect(isAnimating ? 1.02 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    // Stats Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ProgressStatCard(title: LocalizedKey.calories.localized(), value: "1,850", subtitle: "\(LocalizedKey.of.localized()) 2,500", icon: "flame")
                        ProgressStatCard(title: LocalizedKey.steps.localized(), value: "8,420", subtitle: "\(LocalizedKey.of.localized()) 10,000", icon: "figure.walk")
                        ProgressStatCard(title: LocalizedKey.activity.localized(), value: "45", subtitle: LocalizedKey.minutes.localized(), icon: "timer")
                        ProgressStatCard(title: "Stand", value: "12", subtitle: "Hours", icon: "figure.stand")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.amoledBlack)
            .navigationTitle(LocalizedKey.tabProgress.localized())
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear {
                withAnimation(.spring(response: 1.5, dampingFraction: 0.7).delay(0.3)) {
                    progress = 0.75
                }
                isAnimating = true
            }
        }
    }
}

struct ProgressStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.navyAccent)
                    .frame(width: 28, height: 28)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.12), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Enhanced Profile View
struct EnhancedProfileView: View {
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var showingSettings = false
    @State private var showingStatistics = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Profile Header
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.navyAccent.opacity(0.3), .navyAccent.opacity(0.15)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Circle()
                                        .stroke(Color.navyAccent.opacity(0.3), lineWidth: 3)
                                )
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80, weight: .medium))
                                .foregroundColor(.navyAccent)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Max Mustermann")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("max.mustermann@example.com")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.top, 20)
                    
                    // Quick Stats
                    QuickStatsSection()
                        .padding(.horizontal, 20)
                    
                    // Profile Actions
                    VStack(spacing: 12) {
                        ProfileActionCard(
                            title: LocalizedKey.settings.localized(),
                            icon: "gearshape.fill",
                            color: .gray,
                            action: { showingSettings = true }
                        )
                        
                        ProfileActionCard(
                            title: LocalizedKey.statistics.localized(),
                            icon: "chart.bar.fill",
                            color: .navyAccent,
                            action: { showingStatistics = true }
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.amoledBlack)
            .navigationTitle(LocalizedKey.tabProfile.localized())
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingStatistics) {
                StatisticsSheet()
            }
        }
    }
}

struct QuickStatsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedKey.quickOverview.localized())
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickStatCard(title: LocalizedKey.weight.localized(), value: "75 kg", icon: "scalemass")
                QuickStatCard(title: LocalizedKey.bmi.localized(), value: "22.1", icon: "figure.stand")
                QuickStatCard(title: LocalizedKey.goal.localized(), value: "72 kg", icon: "target")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.12), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.navyAccent)
            
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.08))
        )
    }
}

struct ProfileActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [color.opacity(0.2), color.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.12), .white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                }
        )
    }
}

// Statistics Sheet Placeholder
struct StatisticsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.amoledBlack.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundColor(.navyAccent)
                    
                    Text(LocalizedKey.statistics.localized())
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Your detailed statistics will appear here")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle(LocalizedKey.statistics.localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedKey.done.localized()) {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
            }
        }
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter
    }()
}

#Preview {
    ContentView()
}
