//
//  ExerciseLibraryView.swift
//  TestApp
//
//  Exercise library with filtering, search, and favorites
//

import SwiftUI
import SwiftData

struct ExerciseLibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Exercise.name) private var allExercises: [Exercise]
    @ObservedObject private var localization = LocalizationManager.shared
    
    @State private var searchText = ""
    @State private var selectedMuscleGroup: MuscleGroup? = nil
    @State private var selectedExercise: Exercise? = nil
    @State private var showingExerciseDetail = false
    
    // Filtered exercises based on search and muscle group
    var filteredExercises: [Exercise] {
        var exercises = allExercises
        
        // Filter by muscle group
        if let muscleGroup = selectedMuscleGroup {
            exercises = exercises.filter { exercise in
                exercise.muscleGroups.contains(muscleGroup)
            }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            exercises = exercises.filter { exercise in
                exercise.localizedName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Sort: favorites first, then alphabetically
        return exercises.sorted { lhs, rhs in
            if lhs.isFavorite != rhs.isFavorite {
                return lhs.isFavorite
            }
            return lhs.localizedName < rhs.localizedName
        }
    }
    
    var favoriteExercises: [Exercise] {
        allExercises.filter { $0.isFavorite }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                        
                        TextField(LocalizedKey.searchExercises.localized(), text: $searchText)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.white)
                            .accentColor(.navyAccent)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.15), .white.opacity(0.08)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Muscle Group Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // All filter
                        MuscleGroupFilterChip(
                            muscleGroup: nil,
                            isSelected: selectedMuscleGroup == nil,
                            displayName: LocalizedKey.muscleAll.localized(),
                            icon: "square.grid.2x2",
                            color: .navyAccent
                        ) {
                            selectedMuscleGroup = nil
                        }
                        
                        // Individual muscle groups
                        ForEach(MuscleGroup.allCases) { muscleGroup in
                            MuscleGroupFilterChip(
                                muscleGroup: muscleGroup,
                                isSelected: selectedMuscleGroup == muscleGroup,
                                displayName: muscleGroup.displayName,
                                icon: muscleGroup.icon,
                                color: muscleGroup.color
                            ) {
                                selectedMuscleGroup = muscleGroup
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
                
                // Exercise List - This ScrollView needs to expand to fill remaining space
                ScrollView {
                    LazyVStack(spacing: 12) {
                        // Show favorites section if there are any
                        if !favoriteExercises.isEmpty && searchText.isEmpty && selectedMuscleGroup == nil {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(LocalizedKey.favorites.localized())
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                
                                ForEach(favoriteExercises) { exercise in
                                    ExerciseCard(exercise: exercise) {
                                        selectedExercise = exercise
                                        showingExerciseDetail = true
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        
                        // All exercises or filtered
                        if filteredExercises.isEmpty {
                            EmptyExerciseSearchView()
                                .padding(.top, 40)
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                if !favoriteExercises.isEmpty && searchText.isEmpty && selectedMuscleGroup == nil {
                                    Text(LocalizedKey.allExercises.localized())
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                }
                                
                                ForEach(filteredExercises) { exercise in
                                    ExerciseCard(exercise: exercise) {
                                        selectedExercise = exercise
                                        showingExerciseDetail = true
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
                .scrollDismissesKeyboard(.interactively)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.amoledBlack)
            .navigationTitle(LocalizedKey.exerciseLibrary.localized())
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedKey.done.localized()) {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
            }
            .sheet(isPresented: $showingExerciseDetail) {
                if let exercise = selectedExercise {
                    ExerciseDetailView(exercise: exercise)
                }
            }
        }
        .id(localization.selectedLanguage) // Force refresh when language changes
    }
}

// Muscle Group Filter Chip
struct MuscleGroupFilterChip: View {
    let muscleGroup: MuscleGroup?
    let isSelected: Bool
    let displayName: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                
                Text(displayName)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isSelected ?
                        LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [.white.opacity(0.15), .white.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? color.opacity(0.5) : .white.opacity(0.1), lineWidth: 1)
                    )
            )
            .shadow(color: isSelected ? color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
    }
}

// Exercise Card Component
struct ExerciseCard: View {
    @Environment(\.modelContext) private var modelContext
    let exercise: Exercise
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Exercise Icon/Placeholder
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: exercise.muscleGroups.first.map { [$0.color.opacity(0.3), $0.color.opacity(0.15)] } ?? [.navyAccent.opacity(0.3), .navyAccent.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Image(systemName: exercise.muscleGroups.first?.icon ?? "figure.strengthtraining.traditional")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(exercise.muscleGroups.first?.color ?? Color.navyAccent)
                }
                .frame(width: 56, height: 56)
                
                // Exercise Info
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(exercise.localizedName)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if exercise.isFavorite {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    // Muscle groups tags
                    HStack(spacing: 6) {
                        ForEach(exercise.muscleGroups.prefix(3), id: \.rawValue) { muscleGroup in
                            Text(muscleGroup.displayName)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(muscleGroup.color)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(muscleGroup.color.opacity(0.2))
                                )
                        }
                        
                        if exercise.muscleGroups.count > 3 {
                            Text("+\(exercise.muscleGroups.count - 3)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                
                Spacer()
                
                // Favorite Button
                Button(action: {
                    toggleFavorite()
                }) {
                    Image(systemName: exercise.isFavorite ? "star.fill" : "star")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(exercise.isFavorite ? .yellow : .white.opacity(0.4))
                }
                .buttonStyle(PlainButtonStyle())
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
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
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
        .scaleEffect(isPressed ? 0.98 : 1.0)
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
    }
    
    private func toggleFavorite() {
        exercise.isFavorite.toggle()
        try? modelContext.save()
    }
}

// Empty Exercise Search View (when no exercises match search/filter)
struct EmptyExerciseSearchView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(.white.opacity(0.3))
            
            Text("No exercises found")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
            
            Text("Try adjusting your filters")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    ExerciseLibraryView()
        .modelContainer(for: [Exercise.self])
}

