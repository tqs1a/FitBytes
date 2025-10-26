//
//  ContentView.swift
//  TestApp
//
//  Created by Leon  on 09.10.25.
//

import SwiftUI

struct ContentView: View {
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
                            Text("Home")
                        }
                        .tag(0)
                    
                    ActivityFeedView()
                        .tabItem {
                            Image(systemName: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                            Text("Aktivität")
                        }
                        .tag(1)
                    
                    ProgressView()
                        .tabItem {
                            Image(systemName: selectedTab == 2 ? "chart.line.uptrend.xyaxis.circle.fill" : "chart.line.uptrend.xyaxis")
                            Text("Fortschritt")
                        }
                        .tag(2)
                    
                    EnhancedProfileView()
                        .tabItem {
                            Image(systemName: selectedTab == 3 ? "person.circle.fill" : "person.circle")
                            Text("Profil")
                        }
                        .tag(3)
                }
                .accentColor(.navyAccent)
                .background(Color.amoledBlack)
                .preferredColorScheme(.dark)
                .transition(.opacity)
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

// 👇 ADD YOUR CUSTOM COLORS HERE — outside the struct!

extension Color {
    static let midnightNavy = Color(red: 0.05, green: 0.1, blue: 0.2)
    static let navyAccent = Color(red: 0.1, green: 0.3, blue: 0.6)
    static let amoledBlack = Color(red: 0.0, green: 0.0, blue: 0.0)
    static let darkGrayCustom = Color(red: 0.33, green: 0.33, blue: 0.33)
}


// MARK: - Loading View
struct LoadingView: View {
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
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Bereit für dein Training")
                        .font(.headline)
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
    @State private var showingQuickWorkout = false
    @State private var showingNutritionTracking = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Welcome Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Willkommen zurück!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Bereit für dein Training?")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "bell.fill")
                                    .font(.title2)
                                    .foregroundColor(.navyAccent)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.1), .white.opacity(0.05)],
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
                        Text("Schnellaktionen")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 16) {
                            QuickActionButton(
                                title: "Workout starten",
                                subtitle: "Schnelles Training",
                                icon: "figure.strengthtraining.traditional",
                                color: .navyAccent,
                                action: { showingQuickWorkout = true }
                            )
                            
                            QuickActionButton(
                                title: "Ernährung tracken",
                                subtitle: "Kalorien erfassen",
                                icon: "fork.knife",
                                color: .green,
                                action: { showingNutritionTracking = true }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Today's Overview
                    TodayOverviewCard()
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
            }
            .background(Color.amoledBlack)
            .navigationTitle("Home")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
        }
        .sheet(isPresented: $showingQuickWorkout) {
            QuickWorkoutSheet()
        }
        .sheet(isPresented: $showingNutritionTracking) {
            NutritionTrackingSheet()
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.1), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                Circle()
                                    .stroke(color.opacity(0.3), lineWidth: 2)
                            )
                    )
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.15), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.1), lineWidth: 0.5)
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            action()
        }
    }
}

struct TodayOverviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Heute")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(DateFormatter.dayFormatter.string(from: Date()))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color(.darkGray))
                    )
            }
            
            // Progress Rings Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                CircularProgressCard(title: "Schritte", value: "8,420", subtitle: "von 10,000", icon: "figure.walk", progress: 0.84)
                CircularProgressCard(title: "Kalorien", value: "1,850", subtitle: "von 2,500", icon: "flame", progress: 0.74)
                CircularProgressCard(title: "Aktivität", value: "45", subtitle: "Minuten", icon: "timer", progress: 0.9)
                CircularProgressCard(title: "Wasser", value: "6", subtitle: "Gläser", icon: "drop", progress: 0.75)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.darkGray))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.midnightNavy, lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct CircularProgressCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let progress: Double
    
    var body: some View {
        VStack(spacing: 12) {
            // Circular Progress Ring
            ZStack {
                Circle()
                    .stroke(Color
                        .darkGrayCustom,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [.navyAccent, .midnightNavy],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: progress)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.navyAccent)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(Color.midnightNavy.opacity(0.3)))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.midnightNavy.opacity(0.5), lineWidth: 0.5)
                )
        )
    }
}

struct OverviewStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.navyAccent)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.navyAccent)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            ProgressView()
                .progressViewStyle(LinearProgressViewStyle(tint: .navyAccent))
                .scaleEffect(y: 0.5)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Activity Feed View
struct ActivityFeedView: View {
    @State private var selectedPeriod: TimePeriod = .today
    
    enum TimePeriod: String, CaseIterable {
        case today = "Heute"
        case week = "Woche"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Period Selector
                    HStack(spacing: 12) {
                        ForEach(TimePeriod.allCases, id: \.self) { period in
                            PeriodButton(period: period, selectedPeriod: selectedPeriod) {
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
                        Text("Aktivitäten")
                            .font(.headline)
                            .fontWeight(.semibold)
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
            }
            .background(Color.amoledBlack)
            .navigationTitle("Aktivität")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
        }
    }
}

struct PeriodButton: View {
    let period: ActivityFeedView.TimePeriod
    let selectedPeriod: ActivityFeedView.TimePeriod
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(period.rawValue)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(selectedPeriod == period ? .white : .white.opacity(0.7))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(selectedPeriod == period ? Color.navyAccent : .white.opacity(0.1))
                )
        }
    }
}

struct AIOverviewCard: View {
    let period: ActivityFeedView.TimePeriod
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(.navyAccent)
                
                Text("KI-Übersicht")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(period.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.1), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(period == .today ? 
                     "Heute hast du bereits 8,420 Schritte zurückgelegt und 1,850 Kalorien verbrannt. Du bist auf dem besten Weg, dein Tagesziel zu erreichen!" :
                     "Diese Woche war sehr aktiv! Du hast durchschnittlich 9,200 Schritte pro Tag gemacht und 5 Workouts absolviert. Dein Fortschritt ist beeindruckend!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(nil)
                
                if period == .week {
                    HStack(spacing: 16) {
                        StatPill(title: "5", subtitle: "Workouts")
                        StatPill(title: "64,400", subtitle: "Schritte")
                        StatPill(title: "12,950", subtitle: "Kalorien")
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct StatPill: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.navyAccent)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.white.opacity(0.1))
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
                ActivityFeedItem(title: "Laufen", description: "30 Minuten im Park", time: "14:30", icon: "figure.run", color: .navyAccent),
                ActivityFeedItem(title: "Mittagessen", description: "Gesunde Bowl mit 650 kcal", time: "12:45", icon: "fork.knife", color: .green),
                ActivityFeedItem(title: "Wasser", description: "2 Gläser getrunken", time: "11:20", icon: "drop", color: .cyan),
                ActivityFeedItem(title: "Frühstück", description: "Haferflocken mit Beeren", time: "08:15", icon: "sun.max", color: .orange)
            ]
        } else {
            return [
                ActivityFeedItem(title: "Krafttraining", description: "45 Minuten im Gym", time: "Gestern", icon: "dumbbell", color: .navyAccent),
                ActivityFeedItem(title: "Yoga", description: "60 Minuten Entspannung", time: "Montag", icon: "figure.yoga", color: .purple),
                ActivityFeedItem(title: "Schwimmen", description: "40 Minuten Bahnen", time: "Sonntag", icon: "figure.pool.swim", color: .cyan),
                ActivityFeedItem(title: "Radfahren", description: "25 Minuten Stadtrundfahrt", time: "Samstag", icon: "bicycle", color: .green)
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
                .font(.title3)
                .foregroundColor(item.color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(.white.opacity(0.1))
                        .overlay(
                            Circle()
                                .stroke(item.color.opacity(0.3), lineWidth: 1)
                        )
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text(item.time)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Enhanced Profile View
struct EnhancedProfileView: View {
    @State private var showingShareSheet = false
    @State private var showingPreferences = false
    @State private var showingStatistics = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    // Profile Header with Share Button
                    VStack(spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Max Mustermann")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("max.mustermann@example.com")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Button(action: { showingShareSheet = true }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                                    .foregroundColor(.navyAccent)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.1), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                                    )
                            }
                        }
                        
                        // Large Profile Picture
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.white.opacity(0.2), .white.opacity(0.15)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Circle()
                                        .stroke(.white.opacity(0.2), lineWidth: 2)
                                )
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.navyAccent)
                        }
                        .onTapGesture {
                            showingEditProfile = true
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Quick Stats
                    QuickStatsSection()
                        .padding(.horizontal, 20)
                    
                    // Preferences and Statistics
                    VStack(spacing: 16) {
                        ProfileSectionCard(
                            title: "Einstellungen",
                            icon: "gearshape.fill",
                            color: .gray,
                            action: { showingPreferences = true }
                        )
                        
                        ProfileSectionCard(
                            title: "Statistiken",
                            icon: "chart.bar.fill",
                            color: .navyAccent,
                            action: { showingStatistics = true }
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
            }
            .background(Color.amoledBlack)
            .navigationTitle("Profil")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet()
        }
        .sheet(isPresented: $showingPreferences) {
            PreferencesSheet()
        }
        .sheet(isPresented: $showingStatistics) {
            StatisticsSheet()
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileSheet()
        }
    }
}

struct QuickStatsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Schnellübersicht")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickStatCard(title: "Gewicht", value: "75 kg", icon: "scalemass")
                QuickStatCard(title: "BMI", value: "22.1", icon: "figure.stand")
                QuickStatCard(title: "Ziel", value: "72 kg", icon: "target")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.navyAccent)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.1))
        )
    }
}

struct ProfileSectionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.1), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.6))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.15), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.1), lineWidth: 0.5)
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            action()
        }
    }
}

// MARK: - Sheet Views
struct QuickWorkoutSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 60))
                    .foregroundColor(.navyAccent)
                
                Text("Schnelles Workout")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Wähle dein Training und starte direkt durch!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(20)
            .background(Color.amoledBlack)
            .navigationTitle("Workout")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#else
                ToolbarItem(placement: .whiteAction) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#endif
            }
        }
    }
}

struct NutritionTrackingSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Ernährung tracken")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Erfasse deine Mahlzeiten und behalte deine Kalorien im Blick!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(20)
            .background(Color.amoledBlack)
            .navigationTitle("Ernährung")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#else
                ToolbarItem(placement: .whiteAction) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#endif
            }
        }
    }
}

struct ShareSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.navyAccent)
                
                Text("Profil teilen")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Teile dein Fitness-Profil mit Freunden und Familie!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(20)
            .background(Color.amoledBlack)
            .navigationTitle("Teilen")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#else
                ToolbarItem(placement: .whiteAction) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#endif
            }
        }
    }
}

struct PreferencesSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Einstellungen")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Kalorienziel: 2,500 kcal/Tag\nMakronährstoffe: 50% Kohlenhydrate, 25% Protein, 25% Fett\nZielgewicht: 72 kg")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(20)
            .background(Color.amoledBlack)
            .navigationTitle("Einstellungen")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#else
                ToolbarItem(placement: .whiteAction) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#endif
            }
        }
    }
}

struct StatisticsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.navyAccent)
                
                Text("Statistiken")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Aktuelles Gewicht: 75 kg\nBMI: 22.1\nKörperfettanteil: 15%\nMuskelmasse: 65 kg")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(20)
            .background(Color.amoledBlack)
            .navigationTitle("Statistiken")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#else
                ToolbarItem(placement: .whiteAction) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#endif
            }
        }
    }
}

struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.navyAccent)
                
                Text("Profil bearbeiten")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Ändere deinen Namen, Profilbild und andere persönliche Informationen.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(20)
            .background(Color.amoledBlack)
            .navigationTitle("Profil bearbeiten")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Speichern") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                    .fontWeight(.semibold)
                }
#else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                    .fontWeight(.semibold)
                }
#endif
            }
        }
    }
}

// MARK: - Workout View
struct WorkoutView: View {
    let workouts = [
        Workout(name: "Laufen", duration: "30 Min", icon: "figure.run"),
        Workout(name: "Krafttraining", duration: "45 Min", icon: "dumbbell"),
        Workout(name: "Yoga", duration: "60 Min", icon: "figure.yoga"),
        Workout(name: "Radfahren", duration: "25 Min", icon: "bicycle"),
        Workout(name: "Schwimmen", duration: "40 Min", icon: "figure.pool.swim")
    ]
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(workouts, id: \.name) { workout in
                        WorkoutCard(workout: workout)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(Color.amoledBlack)
            .navigationTitle("Workout")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddWorkout = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.navyAccent)
                    }
                }
#else
                ToolbarItem(placement: .whiteAction) {
                    Button(action: { showingAddWorkout = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.navyAccent)
                    }
                }
#endif
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutSheet()
            }
        }
    }
}

struct Workout {
    let name: String
    let duration: String
    let icon: String
}

struct WorkoutCard: View {
    let workout: Workout
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: workout.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(.white.opacity(0.1))
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.2), lineWidth: 0.5)
                        )
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(workout.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(workout.duration)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Nutrition View
struct NutritionView: View {
    let meals = [
        Meal(name: "Frühstück", calories: "450 kcal", icon: "sun.max"),
        Meal(name: "Mittagessen", calories: "650 kcal", icon: "sun.max.fill"),
        Meal(name: "Snack", calories: "200 kcal", icon: "circle.fill"),
        Meal(name: "Abendessen", calories: "550 kcal", icon: "moon"),
        Meal(name: "Späte Mahlzeit", calories: "300 kcal", icon: "moon.fill")
    ]
    @State private var showingAddMeal = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(meals, id: \.name) { meal in
                        MealCard(meal: meal)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(Color.amoledBlack)
            .navigationTitle("Ernährung")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddMeal = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.navyAccent)
                    }
                }
#else
                ToolbarItem(placement: .whiteAction) {
                    Button(action: { showingAddMeal = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.navyAccent)
                    }
                }
#endif
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealSheet()
            }
        }
    }
}

struct Meal {
    let name: String
    let calories: String
    let icon: String
}

struct MealCard: View {
    let meal: Meal
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: meal.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(.white.opacity(0.1))
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.2), lineWidth: 0.5)
                        )
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(meal.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(meal.calories)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Progress View
struct ProgressView: View {
    @State private var progress: Double = 0.0
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Progress Ring with Liquid Glass Effect
                    ZStack {
                        Circle()
                            .stroke(
                                .gray.opacity(0.3),
                                style: StrokeStyle(lineWidth: 16, lineCap: .round)
                            )
                            .frame(width: 220, height: 220)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                LinearGradient(
                                    colors: [.navyAccent, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 16, lineCap: .round)
                            )
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 2.0).delay(0.5), value: progress)
                        
                        VStack(spacing: 12) {
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Tagesziel")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(48)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(.white.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(.white.opacity(0.1), lineWidth: 0.5)
                            )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                    .scaleEffect(isAnimating ? 1.02 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    // Stats Cards with Enhanced Design
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(title: "Kalorien", value: "1,850", subtitle: "von 2,500", icon: "flame")
                        StatCard(title: "Schritte", value: "8,420", subtitle: "von 10,000", icon: "figure.walk")
                        StatCard(title: "Aktivität", value: "45", subtitle: "Minuten", icon: "timer")
                        StatCard(title: "Stand", value: "12", subtitle: "Stunden", icon: "figure.stand")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(Color.amoledBlack)
            .navigationTitle("Fortschritt")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8)) {
                    progress = 0.75
                }
                isAnimating = true
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.navyAccent)
                    .frame(width: 24, height: 24)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    // Profile Header with Enhanced Design
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.white.opacity(0.2), .white.opacity(0.15)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.navyAccent)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Max Mustermann")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("max.mustermann@example.com")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(40)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.15), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white.opacity(0.1), lineWidth: 0.5)
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Schnellaktionen")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            QuickActionCard(title: "Einstellungen", icon: "gearshape.fill", color: .gray)
                            QuickActionCard(title: "Exportieren", icon: "square.and.arrow.up.fill", color: .green)
                            QuickActionCard(title: "Sicherung", icon: "icloud.fill", color: .navyAccent)
                            QuickActionCard(title: "Teilen", icon: "person.2.fill", color: .orange)
                        }
                    }
                    
                    // Settings Cards
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Einstellungen")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 8) {
                            SettingsCard(title: "Benachrichtigungen", icon: "bell.fill", subtitle: "Push-Benachrichtigungen verwalten")
                            SettingsCard(title: "Datenschutz", icon: "lock.fill", subtitle: "Daten und Privatsphäre")
                            SettingsCard(title: "Sicherheit", icon: "shield.fill", subtitle: "Sicherheitseinstellungen")
                            SettingsCard(title: "Hilfe & Support", icon: "questionmark.circle.fill", subtitle: "Hilfe und Feedback")
                            SettingsCard(title: "Über die App", icon: "info.circle.fill", subtitle: "Version 1.0.0")
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(Color.amoledBlack)
            .navigationTitle("Profil")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                    }
                }
#else
                ToolbarItem(placement: .whiteAction) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                    }
                }
#endif
            }
            .sheet(isPresented: $showingSettings) {
                SettingsSheet()
            }
        }
    }
}

struct SettingsCard: View {
    let title: String
    let icon: String
    let subtitle: String
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.navyAccent)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(.white.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(.white.opacity(0.1))
                )
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

struct SettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Erweiterte Einstellungen")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Hier können Sie erweiterte Einstellungen vornehmen.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(20)
            .background(Color.amoledBlack)
            .navigationTitle("Einstellungen")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#else
                ToolbarItem(placement: .whiteAction) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
#endif
            }
        }
    }
}

struct AddWorkoutSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 60))
                    .foregroundColor(.navyAccent)
                
                Text("Neues Workout hinzufügen")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Hier können Sie ein neues Workout zu Ihrer Sammlung hinzufügen.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(20)
            .background(Color.amoledBlack)
            .navigationTitle("Workout hinzufügen")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Hinzufügen") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                    .fontWeight(.semibold)
                }
#else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Hinzufügen") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                    .fontWeight(.semibold)
                }
#endif
            }
        }
    }
}

struct AddMealSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.navyAccent)
                
                Text("Neue Mahlzeit hinzufügen")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Hier können Sie eine neue Mahlzeit zu Ihrem Ernährungstagebuch hinzufügen.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(20)
            .background(Color.amoledBlack)
            .navigationTitle("Mahlzeit hinzufügen")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Hinzufügen") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                    .fontWeight(.semibold)
                }
#else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Hinzufügen") {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                    .fontWeight(.semibold)
                }
#endif
            }
        }
    }
}

// MARK: - Custom Colors


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
