package com.fitnesstracker.data.repository

import com.fitnesstracker.data.database.dao.WorkoutProgramDao
import com.fitnesstracker.data.database.entities.WorkoutProgramEntity
import kotlinx.coroutines.flow.Flow

class WorkoutProgramRepository(private val workoutProgramDao: WorkoutProgramDao) {
    fun getAllPrograms(): Flow<List<WorkoutProgramEntity>> = workoutProgramDao.getAllPrograms()
    
    suspend fun getProgramById(id: String): WorkoutProgramEntity? = workoutProgramDao.getProgramById(id)
    
    suspend fun insertProgram(program: WorkoutProgramEntity) = workoutProgramDao.insertProgram(program)
    
    suspend fun updateProgram(program: WorkoutProgramEntity) = workoutProgramDao.updateProgram(program)
    
    suspend fun deleteProgram(program: WorkoutProgramEntity) = workoutProgramDao.deleteProgram(program)
    
    suspend fun incrementCompletionCount(id: String, timestamp: Long) = 
        workoutProgramDao.incrementCompletionCount(id, timestamp)
}

