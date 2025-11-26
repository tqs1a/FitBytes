import Foundation
import HealthKit
import SwiftUI
import Combine

@MainActor
final class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()

    @Published var todaySteps: Int = 0
    @Published var todayActiveEnergy: Double = 0
    @Published var todayExerciseMinutes: Double = 0

    private init() {}

    // MARK: - Request Permissions
    func requestAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }

        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount),
              let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let exerciseTimeType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime),
              let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            return false
        }

        let readTypes: Set<HKObjectType> = [
            stepCountType,
            activeEnergyType,
            exerciseTimeType,
            bodyMassType
        ]

        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
                if let error = error {
                    print("HealthKit authorization error: \(error.localizedDescription)")
                }
                continuation.resume(returning: success)
            }
        }
    }

    // MARK: - Fetch Today's Data
    func fetchTodayData() {
        fetchTodaySteps()
        fetchTodayActiveEnergy()
        fetchTodayExerciseMinutes()
    }

    private func fetchTodaySteps() {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }

        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, stats, error in
            if let error = error {
                print("Error fetching steps: \(error.localizedDescription)")
                return
            }

            let value = stats?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            
            // Update on main thread since HealthKitManager is marked with @MainActor
            Task { @MainActor in
                self.todaySteps = Int(value)
            }
        }

        healthStore.execute(query)
    }

    private func fetchTodayActiveEnergy() {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }

        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: energyType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, stats, error in
            if let error = error {
                print("Error fetching active energy: \(error.localizedDescription)")
                return
            }

            let value = stats?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            
            // Update on main thread since HealthKitManager is marked with @MainActor
            Task { @MainActor in
                self.todayActiveEnergy = value
            }
        }

        healthStore.execute(query)
    }

    private func fetchTodayExerciseMinutes() {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return }

        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: exerciseType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, stats, error in
            if let error = error {
                print("Error fetching exercise time: \(error.localizedDescription)")
                return
            }

            let value = stats?.sumQuantity()?.doubleValue(for: HKUnit.minute()) ?? 0
            
            // Update on main thread since HealthKitManager is marked with @MainActor
            Task { @MainActor in
                self.todayExerciseMinutes = value
            }
        }

        healthStore.execute(query)
    }

    // MARK: - Live Updates
    func enableLiveUpdates() {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
              let energyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let exerciseType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else { return }

        // Steps Observer
        let stepObserver = HKObserverQuery(sampleType: stepType,
                                           predicate: nil) { query, completionHandler, error in
            if let error = error {
                print("Step observer error: \(error.localizedDescription)")
                completionHandler()
                return
            }
            
            // Call fetchTodayData on main thread since HealthKitManager is marked with @MainActor
            Task { @MainActor in
                self.fetchTodayData()
            }
            completionHandler()
        }

        // Active Energy Observer
        let energyObserver = HKObserverQuery(sampleType: energyType,
                                             predicate: nil) { query, completionHandler, error in
            if let error = error {
                print("Energy observer error: \(error.localizedDescription)")
                completionHandler()
                return
            }
            
            // Call fetchTodayData on main thread since HealthKitManager is marked with @MainActor
            Task { @MainActor in
                self.fetchTodayData()
            }
            completionHandler()
        }

        // Exercise Time Observer
        let exerciseObserver = HKObserverQuery(sampleType: exerciseType,
                                               predicate: nil) { query, completionHandler, error in
            if let error = error {
                print("Exercise observer error: \(error.localizedDescription)")
                completionHandler()
                return
            }
            
            // Call fetchTodayData on main thread since HealthKitManager is marked with @MainActor
            Task { @MainActor in
                self.fetchTodayData()
            }
            completionHandler()
        }

        healthStore.execute(stepObserver)
        healthStore.execute(energyObserver)
        healthStore.execute(exerciseObserver)

        healthStore.enableBackgroundDelivery(for: stepType, frequency: .immediate) { success, error in
            if let error = error {
                print("Failed to enable background delivery for steps: \(error.localizedDescription)")
            }
        }
        healthStore.enableBackgroundDelivery(for: energyType, frequency: .immediate) { success, error in
            if let error = error {
                print("Failed to enable background delivery for energy: \(error.localizedDescription)")
            }
        }
        healthStore.enableBackgroundDelivery(for: exerciseType, frequency: .immediate) { success, error in
            if let error = error {
                print("Failed to enable background delivery for exercise: \(error.localizedDescription)")
            }
        }
    }
}

