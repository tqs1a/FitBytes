//
//  NutritionDetailView.swift
//  TestApp
//
//  Dedicated nutrition tracking screen with Apple Health inspired design
//

import SwiftUI

// Meal model
struct MealEntry: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let time: String
    var imageName: String? = nil
}

// Meal section model
struct MealSection: Identifiable {
    let id = UUID()
    let type: MealType
    var entries: [MealEntry]
    var totalCalories: Int {
        entries.reduce(0) { $0 + $1.calories }
    }
}

enum MealType: String, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snacks
    
    var displayName: String {
        switch self {
        case .breakfast: return LocalizedKey.breakfast.localized()
        case .lunch: return LocalizedKey.lunch.localized()
        case .dinner: return LocalizedKey.dinner.localized()
        case .snacks: return LocalizedKey.snacks.localized()
        }
    }
    
    var icon: String {
        switch self {
        case .breakfast: return "sun.max"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.stars"
        case .snacks: return "takeoutbag.and.cup.and.straw"
        }
    }
    
    var color: Color {
        switch self {
        case .breakfast: return .orange
        case .lunch: return .green
        case .dinner: return .purple
        case .snacks: return .pink
        }
    }
}

struct NutritionDetailView: View {
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var showingAddMeal = false
    @State private var selectedMealType: MealType = .breakfast
    
    // Sample data
    @State private var dailyCalorieGoal = 2000
    @State private var consumedCalories = 1650
    @State private var waterGlasses = 6
    @State private var waterGoal = 8
    
    @State private var meals: [MealSection] = [
        MealSection(type: .breakfast, entries: [
            MealEntry(name: "Oatmeal with berries", calories: 320, time: "8:15 AM")
        ]),
        MealSection(type: .lunch, entries: [
            MealEntry(name: "Grilled chicken salad", calories: 450, time: "12:30 PM"),
            MealEntry(name: "Apple", calories: 95, time: "1:00 PM")
        ]),
        MealSection(type: .dinner, entries: []),
        MealSection(type: .snacks, entries: [
            MealEntry(name: "Protein bar", calories: 200, time: "3:45 PM"),
            MealEntry(name: "Greek yogurt", calories: 120, time: "4:30 PM")
        ])
    ]
    
    var calorieProgress: Double {
        Double(consumedCalories) / Double(dailyCalorieGoal)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Calorie Progress Ring
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 20)
                            .frame(width: 180, height: 180)
                        
                        Circle()
                            .trim(from: 0, to: min(calorieProgress, 1.0))
                            .stroke(
                                LinearGradient(
                                    colors: [.green, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .frame(width: 180, height: 180)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1.0), value: calorieProgress)
                        
                        VStack(spacing: 8) {
                            Text("\(consumedCalories)")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("\(LocalizedKey.of.localized()) \(dailyCalorieGoal) kcal")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    Text(LocalizedKey.dailyGoal.localized())
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                // Water Intake Section
                WaterIntakeSection(current: $waterGlasses, goal: waterGoal)
                    .padding(.horizontal, 20)
                
                // Macros Preview (Placeholder)
                MacrosPreviewCard()
                    .padding(.horizontal, 20)
                
                // Meals Sections
                VStack(spacing: 20) {
                    ForEach(meals.indices, id: \.self) { index in
                        MealSectionCard(
                            section: $meals[index],
                            onAddMeal: {
                                selectedMealType = meals[index].type
                                showingAddMeal = true
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.amoledBlack)
        .navigationTitle(LocalizedKey.nutrition.localized())
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showingAddMeal) {
            AddMealSheet(mealType: selectedMealType)
        }
    }
}

// Water Intake Section Component
struct WaterIntakeSection: View {
    @Binding var current: Int
    let goal: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(LocalizedKey.waterIntake.localized())
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(current) / \(goal) \(LocalizedKey.glasses.localized())")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Water glasses visualization
            HStack(spacing: 12) {
                ForEach(0..<goal, id: \.self) { index in
                    Button(action: {
                        if index < current {
                            current = index
                        } else {
                            current = index + 1
                        }
                    }) {
                        Image(systemName: index < current ? "drop.fill" : "drop")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(index < current ? .cyan : .white.opacity(0.3))
                            .frame(width: 36, height: 36)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.12), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

// Macros Preview Card Component
struct MacrosPreviewCard: View {
    // Sample macro data
    let carbs = 45
    let protein = 30
    let fats = 25
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedKey.macros.localized())
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                MacroBar(name: "Carbs", percentage: carbs, color: .blue)
                MacroBar(name: "Protein", percentage: protein, color: .red)
                MacroBar(name: "Fats", percentage: fats, color: .orange)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.12), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

// Macro Bar Component
struct MacroBar: View {
    let name: String
    let percentage: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(percentage)%")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: geometry.size.height * CGFloat(percentage) / 100)
                }
            }
            .frame(height: 80)
            
            Text(name)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}

// Meal Section Card Component
struct MealSectionCard: View {
    @Binding var section: MealSection
    let onAddMeal: () -> Void
    @State private var isExpanded = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: section.type.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(section.type.color)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [section.type.color.opacity(0.2), section.type.color.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(section.type.displayName)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if section.totalCalories > 0 {
                            Text("\(section.totalCalories) kcal")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        } else {
                            Text("No entries yet")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Meal Entries
            if isExpanded {
                VStack(spacing: 12) {
                    ForEach(section.entries) { entry in
                        MealEntryRow(entry: entry)
                    }
                    
                    // Add Meal Button
                    Button(action: onAddMeal) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(section.type.color)
                            
                            Text(LocalizedKey.addMeal.localized())
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(section.type.color)
                            
                            Spacer()
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(section.type.color.opacity(0.15))
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.12), .white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

// Meal Entry Row Component
struct MealEntryRow: View {
    let entry: MealEntry
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                
                Text(entry.time)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            Text("\(entry.calories)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white) +
            Text(" kcal")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.08))
        )
    }
}

// Add Meal Sheet
struct AddMealSheet: View {
    @Environment(\.dismiss) private var dismiss
    let mealType: MealType
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.amoledBlack.ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    // Meal Type Icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [mealType.color.opacity(0.3), mealType.color.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: mealType.icon)
                            .font(.system(size: 44, weight: .medium))
                            .foregroundColor(mealType.color)
                    }
                    
                    VStack(spacing: 12) {
                        Text(LocalizedKey.addMeal.localized())
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(mealType.displayName)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(mealType.color)
                        
                        Text("Track your meal and log the calories consumed")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle(LocalizedKey.addMeal.localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedKey.cancel.localized()) {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedKey.save.localized()) {
                        dismiss()
                    }
                    .foregroundColor(mealType.color)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        NutritionDetailView()
    }
}

