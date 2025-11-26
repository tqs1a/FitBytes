//
//  CreateProgramView.swift
//  TestApp
//
//  View for creating new workout programs with custom images
//

import SwiftUI
import SwiftData

struct CreateProgramView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localization = LocalizationManager.shared
    
    @State private var programName: String = ""
    @State private var selectedImage: UIImage?
    @State private var usePresetIcon: Bool = true
    @State private var selectedPresetIcon: String = "figure.strengthtraining.traditional"
    @State private var showingImagePicker = false
    @State private var showingPresetIconPicker = false
    
    // Preset icon options
    let presetIcons = [
        "figure.strengthtraining.traditional",
        "figure.run",
        "bicycle",
        "figure.yoga",
        "figure.core.training",
        "dumbbell",
        "heart.fill",
        "bolt.heart",
        "figure.mixed.cardio",
        "figure.cooldown",
        "figure.walk",
        "figure.pool.swim"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Image/Icon Selection Section
                    VStack(spacing: 20) {
                        Text(LocalizedKey.selectImage.localized())
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Image Preview
                        ZStack {
                            if usePresetIcon {
                                // Preset icon preview
                                LinearGradient(
                                    colors: [.navyAccent.opacity(0.4), .navyAccent.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                
                                Image(systemName: selectedPresetIcon)
                                    .font(.system(size: 64, weight: .medium))
                                    .foregroundColor(.navyAccent)
                            } else if let image = selectedImage {
                                // Custom image preview
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                // Placeholder
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 48, weight: .medium))
                                        .foregroundColor(.white.opacity(0.5))
                                    
                                    Text("No image selected")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        // Image Source Selection Buttons
                        HStack(spacing: 12) {
                            // Preset Icons Button
                            Button(action: {
                                usePresetIcon = true
                                showingPresetIconPicker = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "square.grid.3x3.fill")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text(LocalizedKey.presetIcons.localized())
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            usePresetIcon ?
                                            LinearGradient(colors: [.navyAccent, .navyAccent.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                            LinearGradient(colors: [.white.opacity(0.15), .white.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                )
                            }
                            
                            // Photo Library Button
                            Button(action: {
                                usePresetIcon = false
                                showingImagePicker = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "photo.fill")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text(LocalizedKey.photoLibrary.localized())
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            !usePresetIcon ?
                                            LinearGradient(colors: [.navyAccent, .navyAccent.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                            LinearGradient(colors: [.white.opacity(0.15), .white.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Program Name Section
                    VStack(spacing: 16) {
                        Text(LocalizedKey.programName.localized())
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField(LocalizedKey.enterName.localized(), text: $programName)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.white)
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
                            .accentColor(.navyAccent)
                    }
                    .padding(.horizontal, 20)
                    
                    // Create Button
                    Button(action: createProgram) {
                        Text(LocalizedKey.createProgram.localized())
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
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.amoledBlack)
            .navigationTitle(LocalizedKey.createNewProgram.localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedKey.cancel.localized()) {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showingPresetIconPicker) {
                PresetIconPickerView(selectedIcon: $selectedPresetIcon)
            }
        }
    }
    
    private func createProgram() {
        let newProgram = WorkoutProgram(
            name: programName,
            imageData: selectedImage?.jpegData(compressionQuality: 0.8),
            usePresetIcon: usePresetIcon,
            presetIconName: usePresetIcon ? selectedPresetIcon : nil
        )
        
        modelContext.insert(newProgram)
        try? modelContext.save()
        
        dismiss()
    }
}

// Preset Icon Picker Sheet
struct PresetIconPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedIcon: String
    @ObservedObject private var localization = LocalizationManager.shared
    
    let presetIcons = [
        "figure.strengthtraining.traditional",
        "figure.run",
        "bicycle",
        "figure.yoga",
        "figure.core.training",
        "dumbbell",
        "heart.fill",
        "bolt.heart",
        "figure.mixed.cardio",
        "figure.cooldown",
        "figure.walk",
        "figure.pool.swim",
        "figure.arms.open",
        "figure.climbing",
        "figure.flexibility",
        "figure.highintensity.intervaltraining"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(presetIcons, id: \.self) { icon in
                        Button(action: {
                            selectedIcon = icon
                            dismiss()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        selectedIcon == icon ?
                                        LinearGradient(colors: [.navyAccent.opacity(0.4), .navyAccent.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                        LinearGradient(colors: [.white.opacity(0.15), .white.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(selectedIcon == icon ? Color.navyAccent : .white.opacity(0.1), lineWidth: selectedIcon == icon ? 2 : 1)
                                    )
                                
                                Image(systemName: icon)
                                    .font(.system(size: 36, weight: .medium))
                                    .foregroundColor(selectedIcon == icon ? .navyAccent : .white)
                            }
                            .frame(height: 80)
                        }
                    }
                }
                .padding(20)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.amoledBlack)
            .navigationTitle(LocalizedKey.presetIcons.localized())
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
}

#Preview {
    CreateProgramView()
        .modelContainer(for: [WorkoutProgram.self])
}

