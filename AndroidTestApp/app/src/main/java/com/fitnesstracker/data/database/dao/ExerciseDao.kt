package com.fitnesstracker.data.database.dao

import androidx.room.*
import com.fitnesstracker.data.database.entities.ExerciseEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface ExerciseDao {
    @Query("SELECT * FROM exercises ORDER BY name ASC")
    fun getAllExercises(): Flow<List<ExerciseEntity>>
    
    @Query("SELECT * FROM exercises WHERE id = :id")
    suspend fun getExerciseById(id: String): ExerciseEntity?
    
    @Query("SELECT * FROM exercises WHERE isFavorite = 1 ORDER BY name ASC")
    fun getFavoriteExercises(): Flow<List<ExerciseEntity>>
    
    @Query("SELECT * FROM exercises WHERE name LIKE '%' || :searchQuery || '%' ORDER BY name ASC")
    fun searchExercises(searchQuery: String): Flow<List<ExerciseEntity>>
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertExercise(exercise: ExerciseEntity)
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertExercises(exercises: List<ExerciseEntity>)
    
    @Update
    suspend fun updateExercise(exercise: ExerciseEntity)
    
    @Delete
    suspend fun deleteExercise(exercise: ExerciseEntity)
    
    @Query("UPDATE exercises SET isFavorite = :isFavorite WHERE id = :id")
    suspend fun updateFavoriteStatus(id: String, isFavorite: Boolean)
    
    @Query("SELECT COUNT(*) FROM exercises")
    suspend fun getExerciseCount(): Int
}

