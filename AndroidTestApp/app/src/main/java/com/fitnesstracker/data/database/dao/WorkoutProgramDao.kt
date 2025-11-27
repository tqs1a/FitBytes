package com.fitnesstracker.data.database.dao

import androidx.room.*
import com.fitnesstracker.data.database.entities.WorkoutProgramEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface WorkoutProgramDao {
    @Query("SELECT * FROM workout_programs ORDER BY lastModifiedDate DESC")
    fun getAllPrograms(): Flow<List<WorkoutProgramEntity>>
    
    @Query("SELECT * FROM workout_programs WHERE id = :id")
    suspend fun getProgramById(id: String): WorkoutProgramEntity?
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertProgram(program: WorkoutProgramEntity)
    
    @Update
    suspend fun updateProgram(program: WorkoutProgramEntity)
    
    @Delete
    suspend fun deleteProgram(program: WorkoutProgramEntity)
    
    @Query("UPDATE workout_programs SET completionCount = completionCount + 1, lastCompletedDate = :timestamp WHERE id = :id")
    suspend fun incrementCompletionCount(id: String, timestamp: Long)
}

