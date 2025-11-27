package com.fitnesstracker.data.model

enum class StatType(val rawValue: String) {
    STEPS("steps"),
    CALORIES_BURNED("caloriesBurned"),
    ACTIVITY_TIME("activityTime"),
    WATER("water"),
    CALORIES_EATEN("caloriesEaten"),
    DISTANCE("distance"),
    HEART_RATE("heartRate"),
    SLEEP("sleep");
    
    companion object {
        fun fromRawValue(value: String): StatType? {
            return values().find { it.rawValue == value }
        }
    }
}

data class StatData(
    val type: StatType,
    val currentValue: String,
    val goalValue: String,
    val progress: Double
)

