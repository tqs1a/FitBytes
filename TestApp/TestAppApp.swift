//
//  TestAppApp.swift
//  TestApp
//
//  Created by Leon  on 09.10.25.
//

import SwiftUI
import SwiftData

@main
struct TestAppApp: App {
    // Initialize shared managers
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var statsPreferences = HomeStatsPreferences.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            WorkoutProgram.self,
            Exercise.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Seed exercises on first launch
            let context = container.mainContext
            ExerciseDataProvider.seedExercises(context: context)
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localizationManager)
                .environmentObject(statsPreferences)
        }
        .modelContainer(sharedModelContainer)
    }
}
