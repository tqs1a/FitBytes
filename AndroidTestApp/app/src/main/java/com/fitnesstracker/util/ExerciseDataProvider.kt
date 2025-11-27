package com.fitnesstracker.util

import com.fitnesstracker.data.database.entities.ExerciseEntity
import com.fitnesstracker.data.model.MuscleGroup
import com.google.gson.Gson

object ExerciseDataProvider {
    fun getSeedExercises(): List<ExerciseEntity> {
        return listOf(
            // Chest
            ExerciseEntity(
                name = "Bench Press",
                exerciseDescription = "Classic chest exercise",
                instructions = "Lie on bench, lower bar to chest, press up",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CHEST.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Push-ups",
                exerciseDescription = "Bodyweight chest exercise",
                instructions = "Lower body to ground, push back up",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CHEST.rawValue, MuscleGroup.ARMS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Dumbbell Flyes",
                exerciseDescription = "Isolation chest exercise",
                instructions = "Lie on bench, lower dumbbells in arc motion",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CHEST.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Incline Bench Press",
                exerciseDescription = "Upper chest focus",
                instructions = "Press on inclined bench",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CHEST.rawValue, MuscleGroup.SHOULDERS.rawValue)),
                isCustom = false
            ),
            // Back
            ExerciseEntity(
                name = "Deadlift",
                exerciseDescription = "Full body compound movement",
                instructions = "Lift bar from ground to standing position",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.BACK.rawValue, MuscleGroup.LEGS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Pull-ups",
                exerciseDescription = "Upper body strength builder",
                instructions = "Hang from bar, pull body up",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.BACK.rawValue, MuscleGroup.ARMS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Bent Over Row",
                exerciseDescription = "Back width builder",
                instructions = "Bend over, row bar to lower chest",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.BACK.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Lat Pulldown",
                exerciseDescription = "Lat development",
                instructions = "Pull bar down to upper chest",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.BACK.rawValue)),
                isCustom = false
            ),
            // Legs
            ExerciseEntity(
                name = "Squat",
                exerciseDescription = "King of leg exercises",
                instructions = "Lower body by bending knees, stand back up",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.LEGS.rawValue, MuscleGroup.CORE.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Lunges",
                exerciseDescription = "Unilateral leg exercise",
                instructions = "Step forward, lower back knee, push back",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.LEGS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Leg Press",
                exerciseDescription = "Machine leg exercise",
                instructions = "Press weight with legs",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.LEGS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Romanian Deadlift",
                exerciseDescription = "Hamstring focus",
                instructions = "Hinge at hips, lower bar, return",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.LEGS.rawValue, MuscleGroup.BACK.rawValue)),
                isCustom = false
            ),
            // Shoulders
            ExerciseEntity(
                name = "Overhead Press",
                exerciseDescription = "Shoulder strength builder",
                instructions = "Press bar overhead from shoulders",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.SHOULDERS.rawValue, MuscleGroup.ARMS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Lateral Raise",
                exerciseDescription = "Shoulder width",
                instructions = "Raise weights to sides",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.SHOULDERS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Face Pulls",
                exerciseDescription = "Rear delt focus",
                instructions = "Pull cable to face level",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.SHOULDERS.rawValue, MuscleGroup.BACK.rawValue)),
                isCustom = false
            ),
            // Arms
            ExerciseEntity(
                name = "Barbell Curl",
                exerciseDescription = "Bicep builder",
                instructions = "Curl bar to shoulders",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.ARMS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Tricep Dips",
                exerciseDescription = "Tricep strength",
                instructions = "Lower body on parallel bars, push up",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.ARMS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Hammer Curls",
                exerciseDescription = "Brachialis focus",
                instructions = "Curl with neutral grip",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.ARMS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Tricep Pushdown",
                exerciseDescription = "Tricep isolation",
                instructions = "Push cable down with arms",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.ARMS.rawValue)),
                isCustom = false
            ),
            // Core
            ExerciseEntity(
                name = "Plank",
                exerciseDescription = "Core stability",
                instructions = "Hold body in straight line",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CORE.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Russian Twists",
                exerciseDescription = "Rotational core strength",
                instructions = "Sit, rotate torso side to side",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CORE.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Hanging Leg Raises",
                exerciseDescription = "Advanced core exercise",
                instructions = "Hang from bar, raise legs",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CORE.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Cable Crunches",
                exerciseDescription = "Weighted core exercise",
                instructions = "Curl down against cable resistance",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CORE.rawValue)),
                isCustom = false
            ),
            // Cardio
            ExerciseEntity(
                name = "Running",
                exerciseDescription = "Cardiovascular exercise",
                instructions = "Run at steady pace",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CARDIO.rawValue, MuscleGroup.LEGS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Cycling",
                exerciseDescription = "Low impact cardio",
                instructions = "Pedal at consistent pace",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CARDIO.rawValue, MuscleGroup.LEGS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Jump Rope",
                exerciseDescription = "High intensity cardio",
                instructions = "Jump over rope repeatedly",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CARDIO.rawValue, MuscleGroup.LEGS.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Burpees",
                exerciseDescription = "Full body cardio",
                instructions = "Squat, jump back, push-up, jump up",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.CARDIO.rawValue, MuscleGroup.FULL_BODY.rawValue)),
                isCustom = false
            ),
            // Full Body
            ExerciseEntity(
                name = "Clean and Press",
                exerciseDescription = "Olympic movement",
                instructions = "Lift bar to shoulders, press overhead",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.FULL_BODY.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Kettlebell Swings",
                exerciseDescription = "Hip drive exercise",
                instructions = "Swing kettlebell from hips to overhead",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.FULL_BODY.rawValue, MuscleGroup.CARDIO.rawValue)),
                isCustom = false
            ),
            ExerciseEntity(
                name = "Turkish Get-Up",
                exerciseDescription = "Complex movement pattern",
                instructions = "Move from lying to standing with weight",
                muscleGroupsRaw = Gson().toJson(listOf(MuscleGroup.FULL_BODY.rawValue)),
                isCustom = false
            )
        )
    }
}

