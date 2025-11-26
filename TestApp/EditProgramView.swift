//
//  EditProgramView.swift
//  TestApp
//
//  View for editing existing workout programs - add exercises, edit sets, reps, weight, and rest time
//

import SwiftUI
import SwiftData

// Model to store exercise-specific workout settings within a program
struct ProgramExerciseSettings: Codable, Identifiable {
    var id: UUID
    var exerciseID: UUID
    var sets: Int
    var reps: Int
    var weight: Double // in kg
    var restSeconds: Int
    var notes: String
    
    init(exerciseID: UUID, sets: Int = 3, reps: Int = 10, weight: Double = 0, restSeconds: Int = 60, notes: String = "") {
        self.id = UUID()
        self.exerciseID = exerciseID
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.restSeconds = restSeconds
        self.notes = notes
    }
}

struct EditProgramView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localization = LocalizationManager.shared
    
    let program: WorkoutProgram
    @Query private var allExercises: [Exercise]
    
    @State private var programName: String
    @State private var exerciseSettings: [ProgramExerciseSettings]
    @State private var showingExercisePicker = false
    @State private var showingDeleteAlert = false
    @State private var exerciseToDelete: ProgramExerciseSettings?
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case sets, reps, weight, rest, notes
    }
    
    init(program: WorkoutProgram) {
        self.program = program
        _programName = State(initialValue: program.name)
        
        // Load existing exercise settings or create defaults
        if let settingsData = program.exerciseSettingsData,
           let decoded = try? JSONDecoder().decode([ProgramExerciseSettings].self, from: settingsData) {
            _exerciseSettings = State(initialValue: decoded)
        } else {
            // Create default settings for existing exercises
            _exerciseSettings = State(initialValue: program.exerciseIDs.map { exerciseID in
                ProgramExerciseSettings(exerciseID: exerciseID)
            })
        }
    }
    
    // Get exercises that are in this program
    var programExercises: [Exercise] {
        allExercises.filter { exercise in
            exerciseSettings.contains(where: { $0.exerciseID == exercise.id })
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    programHeaderSection
                    
                    exercisesSection
                    
                    saveButtonSection
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.amoledBlack)
            .navigationTitle(LocalizedKey.editProgram.localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedKey.cancel.localized()) {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedKey.done.localized()) {
                        // Dismiss keyboard for all fields
                        focusedField = nil
                    }
                    .foregroundColor(.navyAccent)
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView(selectedExercises: $exerciseSettings, allExercises: allExercises)
            }
            .alert(LocalizedKey.removeExercise.localized(), isPresented: $showingDeleteAlert) {
                Button(LocalizedKey.cancel.localized(), role: .cancel) { }
                Button(LocalizedKey.remove.localized(), role: .destructive) {
                    if let exercise = exerciseToDelete {
                        removeExercise(exercise)
                    }
                }
            } message: {
                Text(LocalizedKey.removeExerciseConfirm.localized())
            }
        }
    }
    
    private var programHeaderSection: some View {
        VStack(spacing: 16) {
            // Program Image/Icon Display
            ZStack {
                if program.usePresetIcon, let iconName = program.presetIconName {
                    LinearGradient(
                        colors: [.navyAccent.opacity(0.4), .navyAccent.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    Image(systemName: iconName)
                        .font(.system(size: 64, weight: .medium))
                        .foregroundColor(.navyAccent)
                } else if let imageData = program.imageData,
                          let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    LinearGradient(
                        colors: [.white.opacity(0.2), .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 64, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
            
            // Program Name TextField
            TextField(LocalizedKey.programName.localized(), text: $programName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.15), .white.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .accentColor(.navyAccent)
        }
        .padding(.horizontal, 20)
    }
    
    private var exercisesSection: some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                Text(LocalizedKey.programExercises.localized())
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(exerciseSettings.count)")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.navyAccent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.navyAccent.opacity(0.2))
                    )
            }
            .padding(.horizontal, 20)
            
            // Exercise List
            if exerciseSettings.isEmpty {
                EmptyExercisesView {
                    showingExercisePicker = true
                }
                .padding(.horizontal, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(exerciseSettings.enumerated()), id: \.element.id) { index, setting in
                        if let exercise = programExercises.first(where: { $0.id == setting.exerciseID }) {
                            ExerciseSettingCard(
                                exercise: exercise,
                                settings: binding(for: setting),
                                onDelete: {
                                    exerciseToDelete = setting
                                    showingDeleteAlert = true
                                },
                                focusedField: $focusedField
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Add Exercise Button
            Button(action: { showingExercisePicker = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22, weight: .semibold))
                    
                    Text(LocalizedKey.addExercise.localized())
                    .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.navyAccent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.15), .white.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.navyAccent.opacity(0.3), lineWidth: 1.5)
                        )
                )
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var saveButtonSection: some View {
        Button(action: saveChanges) {
            Text(LocalizedKey.saveChanges.localized())
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            programName.isEmpty ?
                            LinearGradient(colors: [.gray.opacity(0.5), .gray.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                            LinearGradient(colors: [.navyAccent, .navyAccent.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                )
                .shadow(color: programName.isEmpty ? .clear : .navyAccent.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .disabled(programName.isEmpty)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // Helper to get binding for a specific exercise setting
    private func binding(for setting: ProgramExerciseSettings) -> Binding<ProgramExerciseSettings> {
        guard let index = exerciseSettings.firstIndex(where: { $0.id == setting.id }) else {
            fatalError("Exercise setting not found")
        }
        return $exerciseSettings[index]
    }
    
    private func removeExercise(_ setting: ProgramExerciseSettings) {
        exerciseSettings.removeAll(where: { $0.id == setting.id })
    }
    
    private func saveChanges() {
        // Update program name
        program.name = programName
        
        // Update exercise IDs
        program.exerciseIDs = exerciseSettings.map { $0.exerciseID }
        
        // Save exercise settings as JSON data
        if let encoded = try? JSONEncoder().encode(exerciseSettings) {
            program.exerciseSettingsData = encoded
        }
        
        // Update last modified date
        program.lastModifiedDate = Date()
        
        try? modelContext.save()
        dismiss()
    }
}

// Empty state for when no exercises are added
struct EmptyExercisesView: View {
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.navyAccent.opacity(0.3), .navyAccent.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "dumbbell")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.navyAccent)
            }
            
            VStack(spacing: 8) {
                Text(LocalizedKey.noExercisesYet.localized())
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text(LocalizedKey.addExercisesToStart.localized())
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onAdd) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(LocalizedKey.addExercise.localized())
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [.navyAccent, .navyAccent.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(color: .navyAccent.opacity(0.4), radius: 12, x: 0, y: 6)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.12), .white.opacity(0.06)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

// Card for displaying and editing exercise settings
struct ExerciseSettingCard: View {
    let exercise: Exercise
    @Binding var settings: ProgramExerciseSettings
    let onDelete: () -> Void
    @FocusState.Binding var focusedField: EditProgramView.Field?
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header - Always visible
            Button(action: { withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { isExpanded.toggle() } }) {
                HStack(spacing: 12) {
                    // Exercise icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.navyAccent.opacity(0.3), .navyAccent.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.navyAccent)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(exercise.localizedName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Text("\(settings.sets) sets × \(settings.reps) reps")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expanded Settings Section
            if isExpanded {
                VStack(spacing: 16) {
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    // Sets and Reps Row
                    HStack(spacing: 12) {
                        SettingInputField(
                            title: LocalizedKey.sets.localized(),
                            value: $settings.sets,
                            unit: "",
                            focusedField: $focusedField,
                            fieldType: .sets
                        )
                        
                        SettingInputField(
                            title: LocalizedKey.reps.localized(),
                            value: $settings.reps,
                            unit: "",
                            focusedField: $focusedField,
                            fieldType: .reps
                        )
                    }
                    
                    // Weight and Rest Row
                    HStack(spacing: 12) {
                        WeightInputField(
                            title: LocalizedKey.weight.localized(),
                            value: $settings.weight,
                            focusedField: $focusedField,
                            fieldType: .weight
                        )
                        
                        SettingInputField(
                            title: LocalizedKey.rest.localized(),
                            value: $settings.restSeconds,
                            unit: "sec",
                            focusedField: $focusedField,
                            fieldType: .rest
                        )
                    }
                    
                    // Notes Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedKey.notes.localized())
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        TextField(LocalizedKey.addNotes.localized(), text: $settings.notes, axis: .vertical)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white)
                            .lineLimit(3...10)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                            .accentColor(.navyAccent)
                            .focused($focusedField, equals: .notes)
                            .scrollContentBackground(.hidden)
                    }
                    
                    // Delete Button
                    Button(action: onDelete) {
                        HStack(spacing: 8) {
                            Image(systemName: "trash")
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text(LocalizedKey.removeExercise.localized())
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.red.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
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
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// Reusable input field for exercise settings with direct numeric input
struct SettingInputField: View {
    let title: String
    @Binding var value: Int
    let unit: String
    @FocusState.Binding var focusedField: EditProgramView.Field?
    let fieldType: EditProgramView.Field
    
    @State private var isEditing = false
    @State private var textValue: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            HStack(spacing: 8) {
                // Decrement Button
                Button(action: { if value > 0 { value -= 1 } }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(value > 0 ? .navyAccent : .white.opacity(0.3))
                }
                .disabled(value <= 0)
                
                // Value Display / Text Field
                HStack(spacing: 6) {
                    if isEditing {
                        TextField("", text: $textValue)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 50)
                            .focused($focusedField, equals: fieldType)
                            .onAppear {
                                textValue = "\(value)"
                                focusedField = fieldType
                            }
                            .onChange(of: textValue) { oldValue, newValue in
                                // Filter out non-numeric characters
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    textValue = filtered
                                }
                            }
                    } else {
                        Button(action: {
                            isEditing = true
                            textValue = "\(value)"
                        }) {
                            Text("\(value)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(minWidth: 30)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if !unit.isEmpty {
                        Text(unit)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .fixedSize()
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Increment Button
                Button(action: { value += 1 }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.navyAccent)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isEditing ? Color.navyAccent.opacity(0.5) : .white.opacity(0.1), lineWidth: isEditing ? 2 : 1)
                    )
            )
        }
        .frame(maxWidth: .infinity)
        .onChange(of: focusedField) { oldValue, newValue in
            if newValue != fieldType && isEditing {
                commitValue()
            }
        }
    }
    
    private func commitValue() {
        // Convert text to integer, ensuring it's valid
        if let newValue = Int(textValue), newValue >= 0 {
            value = newValue
        } else if textValue.isEmpty {
            // If empty, set to 0
            value = 0
        } else {
            // If invalid, reset to current value
            textValue = "\(value)"
        }
        isEditing = false
    }
}

// Specialized input field for weight (Double values)
struct WeightInputField: View {
    let title: String
    @Binding var value: Double // Always stored in kg
    @FocusState.Binding var focusedField: EditProgramView.Field?
    let fieldType: EditProgramView.Field
    
    @ObservedObject private var unitPrefs = WeightUnitPreferences.shared
    @State private var isEditing = false
    @State private var textValue: String = ""
    
    // Display value in selected unit
    private var displayValue: Double {
        unitPrefs.convertToDisplayValue(value)
    }
    
    // Unit abbreviation
    private var unit: String {
        unitPrefs.selectedUnit.abbreviation
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            HStack(spacing: 8) {
                // Decrement Button
                Button(action: {
                    let decrementAmount = unitPrefs.selectedUnit == .kilograms ? 0.5 : 1.0 // 0.5 kg or 1 lb
                    let newDisplayValue = max(0, displayValue - decrementAmount)
                    value = unitPrefs.convertToStorageValue(newDisplayValue)
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(displayValue > 0 ? .navyAccent : .white.opacity(0.3))
                }
                .disabled(displayValue <= 0)
                
                // Value Display / Text Field
                HStack(spacing: 6) {
                    if isEditing {
                        TextField("", text: $textValue)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 60)
                            .focused($focusedField, equals: fieldType)
                            .onAppear {
                                // Format weight: remove trailing zeros if whole number
                                let displayVal = displayValue
                                if displayVal.truncatingRemainder(dividingBy: 1) == 0 {
                                    textValue = String(format: "%.0f", displayVal)
                                } else {
                                    textValue = String(format: "%.1f", displayVal)
                                }
                                focusedField = fieldType
                            }
                            .onChange(of: textValue) { oldValue, newValue in
                                // Allow numbers, decimal point, and comma
                                let filtered = newValue.filter { $0.isNumber || $0 == "." || $0 == "," }
                                // Replace comma with period for internal processing
                                let normalized = filtered.replacingOccurrences(of: ",", with: ".")
                                // Ensure only one decimal separator
                                let components = normalized.split(separator: ".")
                                if components.count <= 2 {
                                    textValue = normalized
                                } else {
                                    // More than one decimal separator, keep only first
                                    let firstPart = String(components[0])
                                    let secondPart = components.count > 1 ? String(components[1]) : ""
                                    textValue = firstPart + (secondPart.isEmpty ? "" : "." + secondPart)
                                }
                            }
                    } else {
                        Button(action: {
                            isEditing = true
                            // Format weight for display
                            let displayVal = displayValue
                            if displayVal.truncatingRemainder(dividingBy: 1) == 0 {
                                textValue = String(format: "%.0f", displayVal)
                            } else {
                                textValue = String(format: "%.1f", displayVal)
                            }
                        }) {
                            let displayVal = displayValue
                            Text(displayVal.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", displayVal) : String(format: "%.1f", displayVal))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(minWidth: 40)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if !unit.isEmpty {
                        Text(unit)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .fixedSize()
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Increment Button
                Button(action: {
                    let incrementAmount = unitPrefs.selectedUnit == .kilograms ? 0.5 : 1.0 // 0.5 kg or 1 lb
                    let newDisplayValue = displayValue + incrementAmount
                    value = unitPrefs.convertToStorageValue(newDisplayValue)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.navyAccent)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isEditing ? Color.navyAccent.opacity(0.5) : .white.opacity(0.1), lineWidth: isEditing ? 2 : 1)
                    )
            )
        }
        .frame(maxWidth: .infinity)
        .onChange(of: focusedField) { oldValue, newValue in
            if newValue != fieldType && isEditing {
                commitValue()
            }
        }
        .onChange(of: unitPrefs.selectedUnit) { oldValue, newValue in
            // When unit changes, update display value if editing
            if isEditing {
                let currentDisplay = displayValue
                if currentDisplay.truncatingRemainder(dividingBy: 1) == 0 {
                    textValue = String(format: "%.0f", currentDisplay)
                } else {
                    textValue = String(format: "%.1f", currentDisplay)
                }
            }
        }
    }
    
    private func commitValue() {
        // Normalize comma to period for parsing
        let normalizedText = textValue.replacingOccurrences(of: ",", with: ".")
        
        // Convert text to double, ensuring it's valid
        if let displayValue = Double(normalizedText), displayValue >= 0 {
            // Convert display value to storage value (kg)
            value = unitPrefs.convertToStorageValue(displayValue)
        } else if textValue.isEmpty {
            // If empty, set to 0
            value = 0
        } else {
            // If invalid, reset to current display value
            let currentDisplay = displayValue
            if currentDisplay.truncatingRemainder(dividingBy: 1) == 0 {
                textValue = String(format: "%.0f", currentDisplay)
            } else {
                textValue = String(format: "%.1f", currentDisplay)
            }
        }
        isEditing = false
    }
}

// Exercise Picker Sheet
struct ExercisePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localization = LocalizationManager.shared
    
    @Binding var selectedExercises: [ProgramExerciseSettings]
    let allExercises: [Exercise]
    
    @State private var searchText = ""
    @State private var selectedMuscleGroup: MuscleGroup?
    
    // Filter exercises based on search and muscle group
    var filteredExercises: [Exercise] {
        var filtered = allExercises
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { exercise in
                exercise.localizedName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by muscle group
        if let muscleGroup = selectedMuscleGroup {
            filtered = filtered.filter { exercise in
                exercise.muscleGroups.contains(muscleGroup)
            }
        }
        
        // Remove already selected exercises
        let selectedIDs = selectedExercises.map { $0.exerciseID }
        filtered = filtered.filter { !selectedIDs.contains($0.id) }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    TextField(LocalizedKey.searchExercises.localized(), text: $searchText)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                        .accentColor(.navyAccent)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.15), .white.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Muscle Group Filter (Optional - can be added later)
                
                // Exercise List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredExercises) { exercise in
                            ExercisePickerRow(exercise: exercise) {
                                addExercise(exercise)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .background(Color.amoledBlack)
            .navigationTitle(LocalizedKey.addExercise.localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedKey.done.localized()) {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
            }
        }
    }
    
    private func addExercise(_ exercise: Exercise) {
        let newSetting = ProgramExerciseSettings(exerciseID: exercise.id)
        selectedExercises.append(newSetting)
    }
}

// Row for exercise picker
struct ExercisePickerRow: View {
    let exercise: Exercise
    let onAdd: () -> Void
    
    var body: some View {
        Button(action: onAdd) {
            HStack(spacing: 12) {
                // Exercise Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.navyAccent.opacity(0.3), .navyAccent.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.navyAccent)
                }
                
                // Exercise Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.localizedName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    if !exercise.muscleGroups.isEmpty {
                        Text(exercise.muscleGroups.map { $0.displayName }.joined(separator: ", "))
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Add Button
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.navyAccent)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.12), .white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WorkoutProgram.self, Exercise.self, configurations: config)
    
    let program = WorkoutProgram(name: "Push Day", description: "Upper body push exercises")
    container.mainContext.insert(program)
    
    return EditProgramView(program: program)
        .modelContainer(container)
}

