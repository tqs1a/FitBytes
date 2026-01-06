//
//  WeightUnitPreferences.swift
//  TestApp
//
//  Manages weight unit preferences (kg/lbs)
//

import SwiftUI
import Combine

// Weight unit options
enum WeightUnit: String, CaseIterable, Codable {
    case kilograms = "kg"
    case pounds = "lbs"
    
    var displayName: String {
        switch self {
        case .kilograms: return LocalizedKey.weightUnitKilograms.localized()
        case .pounds: return LocalizedKey.weightUnitPounds.localized()
        }
    }
    
    var abbreviation: String {
        return rawValue
    }
}

// Weight unit preferences manager
class WeightUnitPreferences: ObservableObject {
    static let shared = WeightUnitPreferences()
    
    @AppStorage("weight_unit") private var unitRawValue: String = WeightUnit.kilograms.rawValue {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var selectedUnit: WeightUnit = .kilograms
    
    private init() {
        loadUnit()
    }
    
    // Load unit from UserDefaults
    private func loadUnit() {
        if let unit = WeightUnit(rawValue: unitRawValue) {
            selectedUnit = unit
        } else {
            selectedUnit = .kilograms
        }
    }
    
    // Set weight unit
    func setUnit(_ unit: WeightUnit) {
        selectedUnit = unit
        unitRawValue = unit.rawValue
    }
    
    // Convert kg to lbs
    static func kgToLbs(_ kg: Double) -> Double {
        return kg * 2.20462
    }
    
    // Convert lbs to kg
    static func lbsToKg(_ lbs: Double) -> Double {
        return lbs / 2.20462
    }
    
    // Convert value based on current unit preference
    func convertToDisplayValue(_ kgValue: Double) -> Double {
        switch selectedUnit {
        case .kilograms:
            return kgValue
        case .pounds:
            return WeightUnitPreferences.kgToLbs(kgValue)
        }
    }
    
    // Convert display value back to kg (for storage)
    func convertToStorageValue(_ displayValue: Double) -> Double {
        switch selectedUnit {
        case .kilograms:
            return displayValue
        case .pounds:
            return WeightUnitPreferences.lbsToKg(displayValue)
        }
    }
}







