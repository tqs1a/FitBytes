package com.fitnesstracker.data.database.entities

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.UUID

@Entity(tableName = "workout_programs")
data class WorkoutProgramEntity(
    @PrimaryKey
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val programDescription: String = "",
    val imageData: ByteArray? = null, // Store image as ByteArray
    val usePresetIcon: Boolean = true,
    val presetIconName: String? = "figure.strengthtraining.traditional",
    val exerciseIDs: String, // JSON array of exercise IDs
    val exerciseSettingsData: String? = null, // JSON string
    val durationMinutes: Int? = null,
    val createdDate: Long = System.currentTimeMillis(),
    val lastModifiedDate: Long = System.currentTimeMillis(),
    val completionCount: Int = 0,
    val lastCompletedDate: Long? = null
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as WorkoutProgramEntity

        if (id != other.id) return false
        if (name != other.name) return false
        if (programDescription != other.programDescription) return false
        if (imageData != null) {
            if (other.imageData == null) return false
            if (!imageData.contentEquals(other.imageData)) return false
        } else if (other.imageData != null) return false
        if (usePresetIcon != other.usePresetIcon) return false
        if (presetIconName != other.presetIconName) return false
        if (exerciseIDs != other.exerciseIDs) return false
        if (exerciseSettingsData != other.exerciseSettingsData) return false
        if (durationMinutes != other.durationMinutes) return false
        if (createdDate != other.createdDate) return false
        if (lastModifiedDate != other.lastModifiedDate) return false
        if (completionCount != other.completionCount) return false
        if (lastCompletedDate != other.lastCompletedDate) return false

        return true
    }

    override fun hashCode(): Int {
        var result = id.hashCode()
        result = 31 * result + name.hashCode()
        result = 31 * result + programDescription.hashCode()
        result = 31 * result + (imageData?.contentHashCode() ?: 0)
        result = 31 * result + usePresetIcon.hashCode()
        result = 31 * result + (presetIconName?.hashCode() ?: 0)
        result = 31 * result + exerciseIDs.hashCode()
        result = 31 * result + (exerciseSettingsData?.hashCode() ?: 0)
        result = 31 * result + (durationMinutes ?: 0)
        result = 31 * result + createdDate.hashCode()
        result = 31 * result + lastModifiedDate.hashCode()
        result = 31 * result + completionCount
        result = 31 * result + (lastCompletedDate?.hashCode() ?: 0)
        return result
    }
}

