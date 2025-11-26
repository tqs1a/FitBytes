//
//  WorkoutDetailView.swift
//  TestApp
//
//  Dedicated workout screen with Apple Fitness+ inspired design
//

import SwiftUI

// Workout type model
struct WorkoutType: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let description: String
    
    static let allWorkouts: [WorkoutType] = [
        WorkoutType(name: LocalizedKey.running.localized(), icon: "figure.run", color: .green, description: "Outdoor or treadmill"),
        WorkoutType(name: LocalizedKey.cycling.localized(), icon: "bicycle", color: .orange, description: "Road or stationary"),
        WorkoutType(name: LocalizedKey.strength.localized(), icon: "dumbbell", color: .red, description: "Build muscle"),
        WorkoutType(name: LocalizedKey.yoga.localized(), icon: "figure.yoga", color: .purple, description: "Mind & body"),
        WorkoutType(name: LocalizedKey.swimming.localized(), icon: "figure.pool.swim", color: .cyan, description: "Pool or open water"),
        WorkoutType(name: "HIIT", icon: "bolt.heart", color: .pink, description: "High intensity")
    ]
}

// Recent workout model
struct RecentWorkout: Identifiable {
    let id = UUID()
    let type: String
    let duration: String
    let calories: String
    let date: String
    let icon: String
    let color: Color
}

struct WorkoutDetailView: View {
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var selectedWorkout: WorkoutType?
    @State private var showingWorkoutSession = false
    
    // Sample recent workouts
    let recentWorkouts = [
        RecentWorkout(type: "Running", duration: "30 min", calories: "340 kcal", date: "Yesterday", icon: "figure.run", color: .green),
        RecentWorkout(type: "Strength Training", duration: "45 min", calories: "280 kcal", date: "2 days ago", icon: "dumbbell", color: .red),
        RecentWorkout(type: "Yoga", duration: "60 min", calories: "180 kcal", date: "3 days ago", icon: "figure.yoga", color: .purple)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header Section
                VStack(alignment: .leading, spacing: 16) {
                    Text(LocalizedKey.workoutStart.localized())
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(LocalizedKey.readyForWorkout.localized())
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                // Workout Types Section
                VStack(alignment: .leading, spacing: 20) {
                    Text(LocalizedKey.workoutTypes.localized())
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(WorkoutType.allWorkouts) { workout in
                            WorkoutTypeCard(workout: workout) {
                                selectedWorkout = workout
                                showingWorkoutSession = true
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Recent Workouts Section
                if !recentWorkouts.isEmpty {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(LocalizedKey.recentWorkouts.localized())
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ForEach(recentWorkouts) { workout in
                                RecentWorkoutCard(workout: workout)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.amoledBlack)
        .navigationTitle(LocalizedKey.workout.localized())
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showingWorkoutSession) {
            if let workout = selectedWorkout {
                WorkoutSessionView(workout: workout)
            }
        }
    }
}

// Workout Type Card Component
struct WorkoutTypeCard: View {
    let workout: WorkoutType
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: 16) {
                // Icon with gradient background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [workout.color.opacity(0.3), workout.color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: workout.icon)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(workout.color)
                }
                
                VStack(spacing: 6) {
                    Text(workout.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(workout.description)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
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
                            .stroke(workout.color.opacity(0.2), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

// Recent Workout Card Component
struct RecentWorkoutCard: View {
    let workout: RecentWorkout
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: workout.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(workout.color)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [workout.color.opacity(0.2), workout.color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            
            // Workout Info
            VStack(alignment: .leading, spacing: 6) {
                Text(workout.type)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    Label(workout.duration, systemImage: "clock")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.4))
                    
                    Label(workout.calories, systemImage: "flame")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            // Date
            VStack(alignment: .trailing, spacing: 4) {
                Text(workout.date)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
            }
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
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
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

// Workout Session View (modal)
struct WorkoutSessionView: View {
    @Environment(\.dismiss) private var dismiss
    let workout: WorkoutType
    @State private var isWorkoutActive = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.amoledBlack.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Workout Icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [workout.color.opacity(0.3), workout.color.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: workout.icon)
                            .font(.system(size: 50, weight: .medium))
                            .foregroundColor(workout.color)
                    }
                    
                    // Workout Name
                    Text(workout.name)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    // Timer Display
                    Text(timeString(from: elapsedTime))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Start/Pause Button
                    Button(action: {
                        isWorkoutActive.toggle()
                        if isWorkoutActive {
                            startTimer()
                        } else {
                            stopTimer()
                        }
                    }) {
                        Text(isWorkoutActive ? "Pause" : LocalizedKey.workoutStart.localized())
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [workout.color, workout.color.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .shadow(color: workout.color.opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(workout.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedKey.done.localized()) {
                        stopTimer()
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

#Preview {
    NavigationView {
        WorkoutDetailView()
    }
}

