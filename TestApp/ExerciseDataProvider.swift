//
//  ExerciseDataProvider.swift
//  TestApp
//
//  Provides pre-populated exercise data for initial app setup
//

import Foundation
import SwiftData

class ExerciseDataProvider {
    // Static function to seed common exercises on first launch
    static func seedExercises(context: ModelContext) {
        // Check if exercises already exist to avoid duplicates
        let descriptor = FetchDescriptor<Exercise>()
        let existingExercises = try? context.fetch(descriptor)
        
        if let exercises = existingExercises, !exercises.isEmpty {
            // Exercises already seeded
            return
        }
        
        // Pre-populated exercises grouped by muscle group
        let exercises: [Exercise] = [
            // Chest exercises
            Exercise(
                name: "Bench Press",
                description: "Classic chest building compound exercise",
                instructions: "Lie on bench, lower bar to chest, press up explosively. Keep shoulder blades retracted.",
                muscleGroups: [.chest, .arms],
                placeholderImageURL: "exercisedb://bench-press",
                isCustom: false
            ),
            Exercise(
                name: "Push-ups",
                description: "Bodyweight chest and triceps exercise",
                instructions: "Keep body straight, lower chest to ground, push back up. Engage core throughout.",
                muscleGroups: [.chest, .arms, .core],
                placeholderImageURL: "exercisedb://push-ups",
                isCustom: false
            ),
            Exercise(
                name: "Dumbbell Flyes",
                description: "Isolation exercise for chest development",
                instructions: "Lie on bench, arms slightly bent, lower dumbbells in arc motion, squeeze chest at top.",
                muscleGroups: [.chest],
                placeholderImageURL: "exercisedb://dumbbell-flyes",
                isCustom: false
            ),
            Exercise(
                name: "Incline Bench Press",
                description: "Targets upper chest muscles",
                instructions: "Set bench to 30-45 degrees, press bar or dumbbells upward focusing on upper chest.",
                muscleGroups: [.chest, .shoulders],
                placeholderImageURL: "exercisedb://incline-bench",
                isCustom: false
            ),
            
            // Back exercises
            Exercise(
                name: "Deadlift",
                description: "King of all exercises, full posterior chain",
                instructions: "Hip hinge, grip bar, keep back neutral, drive through heels to stand. Control descent.",
                muscleGroups: [.back, .legs, .core],
                placeholderImageURL: "exercisedb://deadlift",
                isCustom: false
            ),
            Exercise(
                name: "Pull-ups",
                description: "Bodyweight back and biceps builder",
                instructions: "Hang from bar, pull chin over bar, control descent. Engage lats throughout movement.",
                muscleGroups: [.back, .arms],
                placeholderImageURL: "exercisedb://pull-ups",
                isCustom: false
            ),
            Exercise(
                name: "Bent Over Row",
                description: "Compound back thickness exercise",
                instructions: "Hip hinge, pull bar/dumbbells to lower chest, squeeze shoulder blades. Keep back neutral.",
                muscleGroups: [.back, .arms],
                placeholderImageURL: "exercisedb://bent-over-row",
                isCustom: false
            ),
            Exercise(
                name: "Lat Pulldown",
                description: "Cable exercise for lat development",
                instructions: "Pull bar to upper chest, focus on pulling with elbows. Control the return.",
                muscleGroups: [.back, .arms],
                placeholderImageURL: "exercisedb://lat-pulldown",
                isCustom: false
            ),
            
            // Leg exercises
            Exercise(
                name: "Squat",
                description: "Fundamental leg strength builder",
                instructions: "Bar on upper back, descend with knees tracking over toes, drive through heels to stand.",
                muscleGroups: [.legs, .core],
                placeholderImageURL: "exercisedb://squat",
                isCustom: false
            ),
            Exercise(
                name: "Lunges",
                description: "Unilateral leg exercise for balance and strength",
                instructions: "Step forward, lower back knee toward ground, drive through front heel to return.",
                muscleGroups: [.legs, .core],
                placeholderImageURL: "exercisedb://lunges",
                isCustom: false
            ),
            Exercise(
                name: "Leg Press",
                description: "Machine-based quad and glute developer",
                instructions: "Feet shoulder-width on platform, lower with control, press through full foot.",
                muscleGroups: [.legs],
                placeholderImageURL: "exercisedb://leg-press",
                isCustom: false
            ),
            Exercise(
                name: "Romanian Deadlift",
                description: "Hamstring and glute focused hinge movement",
                instructions: "Slight knee bend, push hips back, lower bar along legs. Feel hamstring stretch.",
                muscleGroups: [.legs, .back],
                placeholderImageURL: "exercisedb://romanian-deadlift",
                isCustom: false
            ),
            
            // Shoulder exercises
            Exercise(
                name: "Overhead Press",
                description: "Primary shoulder mass builder",
                instructions: "Press bar or dumbbells overhead, lock out at top. Keep core braced.",
                muscleGroups: [.shoulders, .arms],
                placeholderImageURL: "exercisedb://overhead-press",
                isCustom: false
            ),
            Exercise(
                name: "Lateral Raise",
                description: "Isolation for side delts",
                instructions: "Raise dumbbells to sides until parallel with ground. Control the descent.",
                muscleGroups: [.shoulders],
                placeholderImageURL: "exercisedb://lateral-raise",
                isCustom: false
            ),
            Exercise(
                name: "Face Pulls",
                description: "Rear delt and upper back exercise",
                instructions: "Pull rope to face, rotate hands apart at end. Squeeze shoulder blades.",
                muscleGroups: [.shoulders, .back],
                placeholderImageURL: "exercisedb://face-pulls",
                isCustom: false
            ),
            
            // Arm exercises
            Exercise(
                name: "Barbell Curl",
                description: "Classic bicep mass builder",
                instructions: "Curl bar with supinated grip, keep elbows stable. Control the eccentric.",
                muscleGroups: [.arms],
                placeholderImageURL: "exercisedb://barbell-curl",
                isCustom: false
            ),
            Exercise(
                name: "Tricep Dips",
                description: "Compound tricep exercise",
                instructions: "Lower body by bending elbows, press back up. Keep torso upright.",
                muscleGroups: [.arms, .chest],
                placeholderImageURL: "exercisedb://tricep-dips",
                isCustom: false
            ),
            Exercise(
                name: "Hammer Curls",
                description: "Bicep and forearm developer",
                instructions: "Curl dumbbells with neutral grip. Keep elbows at sides throughout.",
                muscleGroups: [.arms],
                placeholderImageURL: "exercisedb://hammer-curls",
                isCustom: false
            ),
            Exercise(
                name: "Tricep Pushdown",
                description: "Cable isolation for triceps",
                instructions: "Push cable attachment down, fully extend arms. Keep elbows stable.",
                muscleGroups: [.arms],
                placeholderImageURL: "exercisedb://tricep-pushdown",
                isCustom: false
            ),
            
            // Core exercises
            Exercise(
                name: "Plank",
                description: "Isometric core strength exercise",
                instructions: "Hold straight body position on forearms. Engage entire core, don't sag hips.",
                muscleGroups: [.core],
                placeholderImageURL: "exercisedb://plank",
                isCustom: false
            ),
            Exercise(
                name: "Russian Twists",
                description: "Oblique and core rotational exercise",
                instructions: "Seated position, rotate torso side to side. Can hold weight for added resistance.",
                muscleGroups: [.core],
                placeholderImageURL: "exercisedb://russian-twists",
                isCustom: false
            ),
            Exercise(
                name: "Hanging Leg Raises",
                description: "Advanced lower abs exercise",
                instructions: "Hang from bar, raise legs to parallel or higher. Control the descent.",
                muscleGroups: [.core, .arms],
                placeholderImageURL: "exercisedb://hanging-leg-raises",
                isCustom: false
            ),
            Exercise(
                name: "Cable Crunches",
                description: "Weighted ab exercise",
                instructions: "Kneel below cable, crunch down by flexing abs. Keep hips stationary.",
                muscleGroups: [.core],
                placeholderImageURL: "exercisedb://cable-crunches",
                isCustom: false
            ),
            
            // Cardio exercises
            Exercise(
                name: "Running",
                description: "Classic cardiovascular exercise",
                instructions: "Maintain steady pace, focus on breathing rhythm. Land midfoot with each stride.",
                muscleGroups: [.cardio, .legs],
                placeholderImageURL: "exercisedb://running",
                isCustom: false
            ),
            Exercise(
                name: "Cycling",
                description: "Low-impact cardio option",
                instructions: "Maintain consistent cadence, adjust resistance as needed. Keep core engaged.",
                muscleGroups: [.cardio, .legs],
                placeholderImageURL: "exercisedb://cycling",
                isCustom: false
            ),
            Exercise(
                name: "Jump Rope",
                description: "High-intensity cardio and coordination",
                instructions: "Jump with light feet, rotate rope with wrists. Maintain rhythm.",
                muscleGroups: [.cardio, .legs],
                placeholderImageURL: "exercisedb://jump-rope",
                isCustom: false
            ),
            Exercise(
                name: "Burpees",
                description: "Full body cardio and strength",
                instructions: "Drop to plank, push-up, jump feet to hands, explosive jump. Repeat.",
                muscleGroups: [.cardio, .fullBody],
                placeholderImageURL: "exercisedb://burpees",
                isCustom: false
            ),
            
            // Full Body exercises
            Exercise(
                name: "Clean and Press",
                description: "Olympic lift variation for full body power",
                instructions: "Clean bar to shoulders, press overhead. Explosive hip extension on clean.",
                muscleGroups: [.fullBody, .shoulders],
                placeholderImageURL: "exercisedb://clean-press",
                isCustom: false
            ),
            Exercise(
                name: "Kettlebell Swings",
                description: "Dynamic hip hinge movement",
                instructions: "Hip hinge, swing kettlebell between legs, thrust hips to swing to shoulder height.",
                muscleGroups: [.fullBody, .cardio],
                placeholderImageURL: "exercisedb://kettlebell-swings",
                isCustom: false
            ),
            Exercise(
                name: "Turkish Get-Up",
                description: "Complex full body stability exercise",
                instructions: "From lying to standing while holding weight overhead. Reverse to return.",
                muscleGroups: [.fullBody, .core],
                placeholderImageURL: "exercisedb://turkish-getup",
                isCustom: false
            ),
        ]
        
        // Insert all exercises into the context
        for exercise in exercises {
            context.insert(exercise)
        }
        
        // Save the context
        try? context.save()
    }
}



