//
//  HomeStatsPreferences.swift
//  TestApp
//
//  Manages customizable home screen statistics preferences
//

import SwiftUI
import Combine

// Available stat types that can be displayed on home screen
enum StatType: String, CaseIterable, Codable, Identifiable {
    case steps
    case caloriesBurned
    case activityTime
    case water
    case caloriesEaten
    case distance
    case heartRate
    case sleep
    
    var id: String { rawValue }
    
    // Localized display name
    var displayName: String {
        switch self {
        case .steps: return LocalizedKey.steps.localized()
        case .caloriesBurned: return LocalizedKey.calories.localized()
        case .activityTime: return LocalizedKey.activity.localized()
        case .water: return LocalizedKey.water.localized()
        case .caloriesEaten: return LocalizedKey.caloriesEaten.localized()
        case .distance: return LocalizedKey.distance.localized()
        case .heartRate: return LocalizedKey.heartRate.localized()
        case .sleep: return LocalizedKey.sleep.localized()
        }
    }
    
    // Icon for the stat
    var icon: String {
        switch self {
        case .steps: return "figure.walk"
        case .caloriesBurned: return "flame"
        case .activityTime: return "timer"
        case .water: return "drop"
        case .caloriesEaten: return "fork.knife"
        case .distance: return "location"
        case .heartRate: return "heart"
        case .sleep: return "bed.double"
        }
    }
    
    // Unit text
    var unit: String {
        switch self {
        case .steps: return ""
        case .caloriesBurned: return "kcal"
        case .activityTime: return LocalizedKey.minutes.localized()
        case .water: return LocalizedKey.glasses.localized()
        case .caloriesEaten: return "kcal"
        case .distance: return "km"
        case .heartRate: return "bpm"
        case .sleep: return "h"
        }
    }
    
    // Default goal values
    var defaultGoal: String {
        switch self {
        case .steps: return "10,000"
        case .caloriesBurned: return "2,500"
        case .activityTime: return "60"
        case .water: return "8"
        case .caloriesEaten: return "2,000"
        case .distance: return "5.0"
        case .heartRate: return "70"
        case .sleep: return "8"
        }
    }
    
    // Sample current values (will be replaced with real data)
    var sampleValue: String {
        switch self {
        case .steps: return "8,420"
        case .caloriesBurned: return "1,850"
        case .activityTime: return "45"
        case .water: return "6"
        case .caloriesEaten: return "1,650"
        case .distance: return "3.8"
        case .heartRate: return "68"
        case .sleep: return "7.5"
        }
    }
    
    // Sample progress (0.0 to 1.0)
    var sampleProgress: Double {
        switch self {
        case .steps: return 0.84
        case .caloriesBurned: return 0.74
        case .activityTime: return 0.75
        case .water: return 0.75
        case .caloriesEaten: return 0.83
        case .distance: return 0.76
        case .heartRate: return 0.97
        case .sleep: return 0.94
        }
    }
}

// Stats data model for real-time values
struct StatData: Identifiable {
    let id = UUID()
    let type: StatType
    var currentValue: String
    var goalValue: String
    var progress: Double
    
    init(type: StatType, currentValue: String? = nil, goalValue: String? = nil, progress: Double? = nil) {
        self.type = type
        self.currentValue = currentValue ?? type.sampleValue
        self.goalValue = goalValue ?? type.defaultGoal
        self.progress = progress ?? type.sampleProgress
    }
}

// Home stats preferences manager
class HomeStatsPreferences: ObservableObject {
    static let shared = HomeStatsPreferences()
    
    // Default stats to show on home screen
    private let defaultStats: [StatType] = [.steps, .caloriesBurned, .activityTime, .water]
    
    @AppStorage("home_stats_enabled") private var enabledStatsData: Data = Data()
    
    // Currently enabled stats (in order)
    @Published var enabledStats: [StatType] = []
    
    private init() {
        loadEnabledStats()
    }
    
    // Load enabled stats from UserDefaults
    private func loadEnabledStats() {
        if let decoded = try? JSONDecoder().decode([StatType].self, from: enabledStatsData) {
            enabledStats = decoded.isEmpty ? defaultStats : decoded
        } else {
            enabledStats = defaultStats
        }
    }
    
    // Save enabled stats to UserDefaults
    func saveEnabledStats() {
        if let encoded = try? JSONEncoder().encode(enabledStats) {
            enabledStatsData = encoded
        }
    }
    
    // Toggle a stat on/off
    func toggleStat(_ stat: StatType) {
        if enabledStats.contains(stat) {
            enabledStats.removeAll { $0 == stat }
        } else {
            enabledStats.append(stat)
        }
        saveEnabledStats()
    }
    
    // Check if a stat is enabled
    func isEnabled(_ stat: StatType) -> Bool {
        return enabledStats.contains(stat)
    }
    
    // Reorder stats
    func moveStats(from source: IndexSet, to destination: Int) {
        enabledStats.move(fromOffsets: source, toOffset: destination)
        saveEnabledStats()
    }
    
    // Get stat data for a type
    func getStatData(for type: StatType) -> StatData {
        // TODO: Replace with real data from HealthKitManager
        return StatData(type: type)
    }
    
    // Get all enabled stat data
    func getEnabledStatsData() -> [StatData] {
        return enabledStats.map { getStatData(for: $0) }
    }
    
    // Reset to default stats
    func resetToDefaults() {
        enabledStats = defaultStats
        saveEnabledStats()
    }
}

