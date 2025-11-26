//
//  ExerciseDetailView.swift
//  TestApp
//
//  Detailed view for individual exercises with demonstration placeholder
//

import SwiftUI
import SwiftData

struct ExerciseDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localization = LocalizationManager.shared
    
    @Bindable var exercise: Exercise
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Demonstration Video/Image Placeholder
                    VStack(spacing: 16) {
                        ZStack {
                            // Placeholder background
                            LinearGradient(
                                colors: exercise.muscleGroups.first.map { [$0.color.opacity(0.3), $0.color.opacity(0.1)] } ?? [.navyAccent.opacity(0.3), .navyAccent.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            
                            VStack(spacing: 16) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 64, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(LocalizedKey.demonstration.localized())
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("Video placeholder")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        // API Recommendation Note
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.navyAccent)
                                
                                Text("Integration Recommendation")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            Text("For exercise demonstrations, consider integrating ExerciseDB API (exercisedb.p.rapidapi.com) which provides GIF demonstrations and detailed exercise data.")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(nil)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.navyAccent.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.navyAccent.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Exercise Name and Favorite
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(exercise.localizedName)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            if !exercise.exerciseDescription.isEmpty {
                                Text(exercise.exerciseDescription)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            // Custom/Preset badge
                            HStack(spacing: 6) {
                                Image(systemName: exercise.isCustom ? "person.fill" : "star.fill")
                                    .font(.system(size: 11, weight: .medium))
                                
                                Text(exercise.isCustom ? LocalizedKey.custom.localized() : LocalizedKey.preset.localized())
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(.white.opacity(0.1))
                            )
                        }
                        
                        Spacer()
                        
                        // Favorite Button
                        Button(action: {
                            exercise.isFavorite.toggle()
                            try? modelContext.save()
                        }) {
                            Image(systemName: exercise.isFavorite ? "star.fill" : "star")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(exercise.isFavorite ? .yellow : .white.opacity(0.4))
                                .frame(width: 44, height: 44)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Muscle Groups Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedKey.muscleGroups.localized())
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                        
                        FlowLayout(spacing: 12) {
                            ForEach(exercise.muscleGroups, id: \.rawValue) { muscleGroup in
                                MuscleGroupTag(muscleGroup: muscleGroup)
                            }
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
                    .padding(.horizontal, 20)
                    
                    // Instructions Section
                    if !exercise.instructions.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(LocalizedKey.instructions.localized())
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(exercise.instructions)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(6)
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
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.amoledBlack)
            .navigationTitle(LocalizedKey.exerciseDetails.localized())
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

// Muscle Group Tag Component
struct MuscleGroupTag: View {
    let muscleGroup: MuscleGroup
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: muscleGroup.icon)
                .font(.system(size: 14, weight: .medium))
            
            Text(muscleGroup.displayName)
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(muscleGroup.color)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(muscleGroup.color.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(muscleGroup.color.opacity(0.4), lineWidth: 1)
                )
        )
    }
}

// Flow Layout for tags (wrapping layout)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview {
    @Previewable @State var exercise = Exercise(
        name: "Bench Press",
        description: "Classic chest building exercise",
        instructions: "Lie on bench, lower bar to chest, press up explosively.",
        muscleGroups: [.chest, .arms]
    )
    
    ExerciseDetailView(exercise: exercise)
        .modelContainer(for: [Exercise.self])
}

