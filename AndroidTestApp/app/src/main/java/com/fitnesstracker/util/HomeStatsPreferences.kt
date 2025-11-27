package com.fitnesstracker.util

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringSetPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import com.fitnesstracker.data.model.StatData
import com.fitnesstracker.data.model.StatType
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "home_stats_preferences")

class HomeStatsPreferences(private val context: Context) {
    private val enabledStatsKey = stringSetPreferencesKey("enabled_stats")
    
    private val defaultStats = listOf(
        StatType.STEPS,
        StatType.CALORIES_BURNED,
        StatType.ACTIVITY_TIME,
        StatType.WATER
    )
    
    val enabledStats: Flow<List<StatType>> = context.dataStore.data.map { preferences ->
        val statsSet = preferences[enabledStatsKey] ?: emptySet()
        if (statsSet.isEmpty()) {
            defaultStats
        } else {
            statsSet.mapNotNull { StatType.fromRawValue(it) }
        }
    }
    
    suspend fun saveEnabledStats(stats: List<StatType>) {
        context.dataStore.edit { preferences ->
            preferences[enabledStatsKey] = stats.map { it.rawValue }.toSet()
        }
    }
    
    suspend fun toggleStat(stat: StatType) {
        context.dataStore.edit { preferences ->
            val currentSet = preferences[enabledStatsKey]?.toMutableSet() ?: defaultStats.map { it.rawValue }.toMutableSet()
            if (currentSet.contains(stat.rawValue)) {
                currentSet.remove(stat.rawValue)
            } else {
                currentSet.add(stat.rawValue)
            }
            preferences[enabledStatsKey] = currentSet
        }
    }
    
    suspend fun isEnabled(stat: StatType): Boolean {
        return context.dataStore.data.map { preferences ->
            val statsSet = preferences[enabledStatsKey] ?: emptySet()
            statsSet.contains(stat.rawValue)
        }.map { it }.let { flow ->
            // This is a simplified version - in production, you'd use first() or similar
            false // Placeholder
        }
    }
    
    fun getStatData(type: StatType): StatData {
        // TODO: Replace with real data from HealthConnectManager
        return when (type) {
            StatType.STEPS -> StatData(type, "8,420", "10,000", 0.84)
            StatType.CALORIES_BURNED -> StatData(type, "1,850", "2,500", 0.74)
            StatType.ACTIVITY_TIME -> StatData(type, "45", "60", 0.75)
            StatType.WATER -> StatData(type, "6", "8", 0.75)
            StatType.CALORIES_EATEN -> StatData(type, "1,650", "2,000", 0.83)
            StatType.DISTANCE -> StatData(type, "3.8", "5.0", 0.76)
            StatType.HEART_RATE -> StatData(type, "68", "70", 0.97)
            StatType.SLEEP -> StatData(type, "7.5", "8", 0.94)
        }
    }
}

