//
//  Exercise.swift
//  TestApp
//
//  SwiftData model for exercises with muscle groups and favorites
//

import Foundation
import SwiftData

@Model
final class Exercise {
    var id: UUID
    var name: String
    var exerciseDescription: String
    var instructions: String
    var muscleGroupsRaw: [String] // Store raw strings for SwiftData compatibility
    var isFavorite: Bool
    var placeholderImageURL: String?
    var placeholderVideoURL: String?
    var createdDate: Date
    var isCustom: Bool // True if user-created, false if pre-populated
    
    // Computed property to work with MuscleGroup enum
    var muscleGroups: [MuscleGroup] {
        get {
            muscleGroupsRaw.compactMap { MuscleGroup(rawValue: $0) }
        }
        set {
            muscleGroupsRaw = newValue.map { $0.rawValue }
        }
    }
    
    // Localized name - returns localized version for preset exercises, original name for custom exercises
    var localizedName: String {
        // For custom exercises, return the name as-is
        if isCustom {
            return name
        }
        
        // For preset exercises, try to get localized name
        if let localizationKey = LocalizationManager.shared.localizationKeyForExercise(name: name) {
            let localized = localizationKey.localized()
            // If localization returns the key itself (not found), return original name
            if localized != localizationKey {
                return localized
            }
        }
        
        // Fallback to original name
        return name
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        instructions: String = "",
        muscleGroups: [MuscleGroup],
        isFavorite: Bool = false,
        placeholderImageURL: String? = nil,
        placeholderVideoURL: String? = nil,
        isCustom: Bool = false,
        createdDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.exerciseDescription = description
        self.instructions = instructions
        self.muscleGroupsRaw = muscleGroups.map { $0.rawValue }
        self.isFavorite = isFavorite
        self.placeholderImageURL = placeholderImageURL
        self.placeholderVideoURL = placeholderVideoURL
        self.isCustom = isCustom
        self.createdDate = createdDate
    }
}

