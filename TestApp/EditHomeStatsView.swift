//
//  EditHomeStatsView.swift
//  TestApp
//
//  Home screen stats customization interface
//

import SwiftUI

struct EditHomeStatsView: View {
    @StateObject private var statsPrefs = HomeStatsPreferences.shared
    @ObservedObject private var localization = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var tempEnabledStats: [StatType] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.amoledBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Info Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Customize your home screen stats")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text("Select which stats you want to see on your home screen. You can reorder them by dragging.")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Currently Enabled Stats (Reorderable)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Enabled Stats")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            if tempEnabledStats.isEmpty {
                                Text("No stats selected. Choose from below.")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(tempEnabledStats) { stat in
                                        StatToggleCard(
                                            stat: stat,
                                            isEnabled: true,
                                            onToggle: {
                                                withAnimation(.spring(response: 0.3)) {
                                                    tempEnabledStats.removeAll { $0 == stat }
                                                }
                                            }
                                        )
                                    }
                                    .onMove { source, destination in
                                        tempEnabledStats.move(fromOffsets: source, toOffset: destination)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.horizontal, 20)
                        
                        // Available Stats
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Available Stats")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(StatType.allCases.filter { !tempEnabledStats.contains($0) }) { stat in
                                    StatToggleCard(
                                        stat: stat,
                                        isEnabled: false,
                                        onToggle: {
                                            withAnimation(.spring(response: 0.3)) {
                                                tempEnabledStats.append(stat)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle(LocalizedKey.customizeHomeStats.localized())
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
                        saveChanges()
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                tempEnabledStats = statsPrefs.enabledStats
            }
        }
    }
    
    private func saveChanges() {
        statsPrefs.enabledStats = tempEnabledStats
        statsPrefs.saveEnabledStats()
    }
}

// Stat Toggle Card Component
struct StatToggleCard: View {
    let stat: StatType
    let isEnabled: Bool
    let onToggle: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            onToggle()
        }) {
            HStack(spacing: 16) {
                // Drag handle (only for enabled stats)
                if isEnabled {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                        .frame(width: 24)
                }
                
                // Icon
                Image(systemName: stat.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.navyAccent)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.navyAccent.opacity(0.2), .navyAccent.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                
                // Stat Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(stat.displayName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("\(stat.sampleValue) \(stat.unit)")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Toggle Indicator
                Image(systemName: isEnabled ? "checkmark.circle.fill" : "plus.circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isEnabled ? .green : .navyAccent)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: isEnabled ? 
                                [.navyAccent.opacity(0.2), .navyAccent.opacity(0.1)] :
                                [.white.opacity(0.12), .white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isEnabled ? Color.navyAccent.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

#Preview {
    EditHomeStatsView()
}

