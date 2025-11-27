package com.fitnesstracker.data.database

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.fitnesstracker.data.database.dao.ExerciseDao
import com.fitnesstracker.data.database.dao.WorkoutProgramDao
import com.fitnesstracker.data.database.entities.ExerciseEntity
import com.fitnesstracker.data.database.entities.ItemEntity
import com.fitnesstracker.data.database.entities.WorkoutProgramEntity

@Database(
    entities = [
        ExerciseEntity::class,
        WorkoutProgramEntity::class,
        ItemEntity::class
    ],
    version = 1,
    exportSchema = false
)
abstract class AppDatabase : RoomDatabase() {
    abstract fun exerciseDao(): ExerciseDao
    abstract fun workoutProgramDao(): WorkoutProgramDao
    
    companion object {
        @Volatile
        private var INSTANCE: AppDatabase? = null
        
        fun getDatabase(context: Context): AppDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java,
                    "fitness_tracker_database"
                )
                    .fallbackToDestructiveMigration()
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}

