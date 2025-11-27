package com.fitnesstracker.data.database.entities

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "items")
data class ItemEntity(
    @PrimaryKey
    val timestamp: Long = System.currentTimeMillis()
)

