package com.fitnesstracker.data.database.entities

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.UUID

@Entity(tableName = "exercises")
data class ExerciseEntity(
    @PrimaryKey
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val exerciseDescription: String = "",
    val instructions: String = "",
    val muscleGroupsRaw: String, // JSON array of muscle group strings
    val isFavorite: Boolean = false,
    val placeholderImageURL: String? = null,
    val placeholderVideoURL: String? = null,
    val createdDate: Long = System.currentTimeMillis(),
    val isCustom: Boolean = false
)

