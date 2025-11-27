//
//  ProgramListView.swift
//  TestApp
//
//  Main view for displaying and managing workout programs
//

import SwiftUI
import SwiftData

struct ProgramListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutProgram.lastModifiedDate, order: .reverse) private var programs: [WorkoutProgram]
    @Query private var exercises: [Exercise]
    @ObservedObject private var localization = LocalizationManager.shared
    
    @State private var showingCreateProgram = false
    @State private var showingExerciseLibrary = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header Section
                VStack(alignment: .leading, spacing: 16) {
                    Text(LocalizedKey.myPrograms.localized())
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(LocalizedKey.readyForWorkout.localized())
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                // Programs Grid or Empty State
                if programs.isEmpty {
                    EmptyProgramsView {
                        showingCreateProgram = true
                    }
                    .padding(.horizontal, 20)
                } else {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(programs) { program in
                            ProgramCard(program: program, exercises: exercises)
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
        .navigationTitle(LocalizedKey.myPrograms.localized())
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 12) {
                    // Exercise Library Button
                    Button(action: { showingExerciseLibrary = true }) {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.navyAccent)
                    }
                    
                    // Create Program Button
                    Button(action: { showingCreateProgram = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.navyAccent)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreateProgram) {
            CreateProgramView()
        }
        .sheet(isPresented: $showingExerciseLibrary) {
            ExerciseLibraryView()
        }
        .id(localization.selectedLanguage) // Force refresh when language changes
    }
}

// Empty Programs View
struct EmptyProgramsView: View {
    let onCreate: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.navyAccent.opacity(0.3), .navyAccent.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.navyAccent)
            }
            
            VStack(spacing: 12) {
                Text(LocalizedKey.emptyState.localized())
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(LocalizedKey.emptySubtitle.localized())
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            // Create Button
            Button(action: onCreate) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text(LocalizedKey.createNewProgram.localized())
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [.navyAccent, .navyAccent.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(color: .navyAccent.opacity(0.4), radius: 12, x: 0, y: 6)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 20)
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

// Program Card Component
struct ProgramCard: View {
    let program: WorkoutProgram
    let exercises: [Exercise]
    @State private var isPressed = false
    @State private var showingEditProgram = false
    
    // Get program exercises
    var programExercises: [Exercise] {
        exercises.filter { program.exerciseIDs.contains($0.id) }
    }
    
    var body: some View {
        Button(action: {
            showingEditProgram = true
        }) {
            VStack(spacing: 0) {
                // Image/Icon Section
                ZStack {
                    if program.usePresetIcon, let iconName = program.presetIconName {
                        // Preset icon display
                        LinearGradient(
                            colors: [.navyAccent.opacity(0.4), .navyAccent.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        Image(systemName: iconName)
                            .font(.system(size: 48, weight: .medium))
                            .foregroundColor(.navyAccent)
                    } else if let imageData = program.imageData,
                              let uiImage = UIImage(data: imageData) {
                        // Custom image display
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        // Fallback
                        LinearGradient(
                            colors: [.white.opacity(0.2), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 48, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .frame(height: 140)
                .frame(maxWidth: .infinity)
                .clipped()
                
                // Info Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(program.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "figure.run")
                            .font(.system(size: 11, weight: .medium))
                        
                        Text("\(programExercises.count) \(LocalizedKey.programExercises.localized())")
                            .font(.system(size: 13, weight: .regular))
                    }
                    .foregroundColor(.white.opacity(0.7))
                    
                    if program.completionCount > 0 {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.green)
                            
                            Text("\(program.completionCount) \(LocalizedKey.timesCompleted.localized())")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    LinearGradient(
                        colors: [.white.opacity(0.12), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .sheet(isPresented: $showingEditProgram) {
            EditProgramView(program: program)
        }
    }
}

#Preview {
    NavigationView {
        ProgramListView()
            .modelContainer(for: [WorkoutProgram.self, Exercise.self])
    }
}

