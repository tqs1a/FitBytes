//
//  WorkoutProgram.swift
//  TestApp
//
//  SwiftData model for workout programs with custom images
//

import Foundation
import SwiftData
import UIKit

@Model
final class WorkoutProgram {
    var id: UUID
    var name: String
    var programDescription: String
    var imageData: Data? // Store UIImage as Data
    var usePresetIcon: Bool // True if using preset icon instead of custom image
    var presetIconName: String? // SF Symbol or asset name
    var createdDate: Date
    var lastModifiedDate: Date
    var exerciseIDs: [UUID] // Store exercise IDs for relationship
    var exerciseSettingsData: Data? // Store ProgramExerciseSettings as JSON Data
    var durationMinutes: Int? // Optional workout duration
    var completionCount: Int // Number of times completed
    var lastCompletedDate: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        imageData: Data? = nil,
        usePresetIcon: Bool = true,
        presetIconName: String? = "figure.strengthtraining.traditional",
        exerciseIDs: [UUID] = [],
        exerciseSettingsData: Data? = nil,
        durationMinutes: Int? = nil,
        createdDate: Date = Date(),
        lastModifiedDate: Date = Date(),
        completionCount: Int = 0,
        lastCompletedDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.programDescription = description
        self.imageData = imageData
        self.usePresetIcon = usePresetIcon
        self.presetIconName = presetIconName
        self.exerciseIDs = exerciseIDs
        self.exerciseSettingsData = exerciseSettingsData
        self.durationMinutes = durationMinutes
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate
        self.completionCount = completionCount
        self.lastCompletedDate = lastCompletedDate
    }
}

