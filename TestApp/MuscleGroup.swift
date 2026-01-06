//
//  MuscleGroup.swift
//  TestApp
//
//  Defines muscle groups for exercise categorization
//

import Foundation
import SwiftUI

// Muscle group enum for categorizing exercises
enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    case chest = "chest"
    case back = "back"
    case legs = "legs"
    case shoulders = "shoulders"
    case arms = "arms"
    case core = "core"
    case cardio = "cardio"
    case fullBody = "full_body"
    
    var id: String { rawValue }
    
    // Localized display name
    var displayName: String {
        switch self {
        case .chest: return LocalizedKey.muscleChest.localized()
        case .back: return LocalizedKey.muscleBack.localized()
        case .legs: return LocalizedKey.muscleLegs.localized()
        case .shoulders: return LocalizedKey.muscleShoulders.localized()
        case .arms: return LocalizedKey.muscleArms.localized()
        case .core: return LocalizedKey.muscleCore.localized()
        case .cardio: return LocalizedKey.muscleCardio.localized()
        case .fullBody: return LocalizedKey.muscleFullBody.localized()
        }
    }
    
    // Icon for the muscle group
    var icon: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.cooldown"
        case .legs: return "figure.walk"
        case .shoulders: return "figure.arms.open"
        case .arms: return "dumbbell"
        case .core: return "figure.core.training"
        case .cardio: return "heart.fill"
        case .fullBody: return "figure.mixed.cardio"
        }
    }
    
    // Color for the muscle group
    var color: Color {
        switch self {
        case .chest: return .red
        case .back: return .green
        case .legs: return .blue
        case .shoulders: return .orange
        case .arms: return .purple
        case .core: return .yellow
        case .cardio: return .pink
        case .fullBody: return .cyan
        }
    }
}







