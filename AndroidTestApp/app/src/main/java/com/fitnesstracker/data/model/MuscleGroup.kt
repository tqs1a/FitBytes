package com.fitnesstracker.data.model

import androidx.compose.ui.graphics.Color

enum class MuscleGroup(val rawValue: String) {
    CHEST("chest"),
    BACK("back"),
    LEGS("legs"),
    SHOULDERS("shoulders"),
    ARMS("arms"),
    CORE("core"),
    CARDIO("cardio"),
    FULL_BODY("full_body");
    
    companion object {
        fun fromRawValue(value: String): MuscleGroup? {
            return values().find { it.rawValue == value }
        }
    }
}

