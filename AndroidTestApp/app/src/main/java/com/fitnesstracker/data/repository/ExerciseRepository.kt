package com.fitnesstracker.data.repository

import com.fitnesstracker.data.database.dao.ExerciseDao
import com.fitnesstracker.data.database.entities.ExerciseEntity
import kotlinx.coroutines.flow.Flow

class ExerciseRepository(private val exerciseDao: ExerciseDao) {
    fun getAllExercises(): Flow<List<ExerciseEntity>> = exerciseDao.getAllExercises()
    
    suspend fun getExerciseById(id: String): ExerciseEntity? = exerciseDao.getExerciseById(id)
    
    fun getFavoriteExercises(): Flow<List<ExerciseEntity>> = exerciseDao.getFavoriteExercises()
    
    fun searchExercises(query: String): Flow<List<ExerciseEntity>> = exerciseDao.searchExercises(query)
    
    suspend fun insertExercise(exercise: ExerciseEntity) = exerciseDao.insertExercise(exercise)
    
    suspend fun insertExercises(exercises: List<ExerciseEntity>) = exerciseDao.insertExercises(exercises)
    
    suspend fun updateExercise(exercise: ExerciseEntity) = exerciseDao.updateExercise(exercise)
    
    suspend fun deleteExercise(exercise: ExerciseEntity) = exerciseDao.deleteExercise(exercise)
    
    suspend fun toggleFavorite(id: String, isFavorite: Boolean) = 
        exerciseDao.updateFavoriteStatus(id, isFavorite)
    
    suspend fun getExerciseCount(): Int = exerciseDao.getExerciseCount()
}

