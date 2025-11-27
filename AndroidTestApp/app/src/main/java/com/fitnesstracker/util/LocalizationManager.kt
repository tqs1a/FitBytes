package com.fitnesstracker.util

import android.content.Context
import android.content.res.Configuration
import android.content.res.Resources
import java.util.Locale

object LocalizationManager {
    private var currentLanguage: String = "de" // Default to German
    
    fun setLanguage(context: Context, languageCode: String) {
        currentLanguage = languageCode
        updateLocale(context, languageCode)
    }
    
    fun getCurrentLanguage(): String = currentLanguage
    
    private fun updateLocale(context: Context, languageCode: String) {
        val locale = Locale(languageCode)
        Locale.setDefault(locale)
        val config = Configuration(context.resources.configuration)
        config.setLocale(locale)
        context.resources.updateConfiguration(config, context.resources.displayMetrics)
    }
    
    fun getLocalizedString(context: Context, key: String): String {
        val resourceId = context.resources.getIdentifier(key, "string", context.packageName)
        return if (resourceId != 0) {
            context.getString(resourceId)
        } else {
            key // Fallback to key if not found
        }
    }
    
    fun getExerciseLocalizationKey(exerciseName: String): String? {
        val mapping = mapOf(
            "Bench Press" to "exercise.name.bench_press",
            "Push-ups" to "exercise.name.push_ups",
            "Dumbbell Flyes" to "exercise.name.dumbbell_flyes",
            "Incline Bench Press" to "exercise.name.incline_bench_press",
            "Deadlift" to "exercise.name.deadlift",
            "Pull-ups" to "exercise.name.pull_ups",
            "Bent Over Row" to "exercise.name.bent_over_row",
            "Lat Pulldown" to "exercise.name.lat_pulldown",
            "Squat" to "exercise.name.squat",
            "Lunges" to "exercise.name.lunges",
            "Leg Press" to "exercise.name.leg_press",
            "Romanian Deadlift" to "exercise.name.romanian_deadlift",
            "Overhead Press" to "exercise.name.overhead_press",
            "Lateral Raise" to "exercise.name.lateral_raise",
            "Face Pulls" to "exercise.name.face_pulls",
            "Barbell Curl" to "exercise.name.barbell_curl",
            "Tricep Dips" to "exercise.name.tricep_dips",
            "Hammer Curls" to "exercise.name.hammer_curls",
            "Tricep Pushdown" to "exercise.name.tricep_pushdown",
            "Plank" to "exercise.name.plank",
            "Russian Twists" to "exercise.name.russian_twists",
            "Hanging Leg Raises" to "exercise.name.hanging_leg_raises",
            "Cable Crunches" to "exercise.name.cable_crunches",
            "Running" to "exercise.name.running",
            "Cycling" to "exercise.name.cycling",
            "Jump Rope" to "exercise.name.jump_rope",
            "Burpees" to "exercise.name.burpees",
            "Clean and Press" to "exercise.name.clean_and_press",
            "Kettlebell Swings" to "exercise.name.kettlebell_swings",
            "Turkish Get-Up" to "exercise.name.turkish_get_up"
        )
        return mapping[exerciseName]
    }
}

