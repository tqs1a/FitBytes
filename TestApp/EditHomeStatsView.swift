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
                                    ForEach(Array(tempEnabledStats.enumerated()), id: \.element.id) { index, stat in
                                        StatToggleCard(
                                            stat: stat,
                                            isEnabled: true,
                                            onToggle: {
                                                withAnimation(.spring(response: 0.3)) {
                                                    tempEnabledStats.removeAll { $0 == stat }
                                                }
                                            },
                                            onMove: { direction in
                                                let newIndex = direction == .up ? index - 1 : index + 1
                                                if newIndex >= 0 && newIndex < tempEnabledStats.count {
                                                    // Swap items instantly (no animation) to prevent teleporting during drag
                                                    let item = tempEnabledStats.remove(at: index)
                                                    tempEnabledStats.insert(item, at: newIndex)
                                                }
                                            }
                                        )
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
    var onMove: ((MoveDirection) -> Void)? = nil
    @State private var isDragging = false
    @State private var lastMoveDirection: MoveDirection? = nil
    @State private var dragTranslation: CGFloat = 0
    @State private var baseOffset: CGFloat = 0
    @State private var cardHeight: CGFloat = 0
    
    enum MoveDirection {
        case up
        case down
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Drag handle (only for enabled stats)
            if isEnabled, let onMove = onMove {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isDragging ? .navyAccent : .white.opacity(0.5))
                    .frame(width: 24)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // Capture height if not set
                                if !isDragging {
                                    isDragging = true
                                    lastMoveDirection = nil
                                }
                                
                                dragTranslation = value.translation.height
                                
                                // Visual offset = dragTranslation + baseOffset
                                let effectiveOffset = dragTranslation + baseOffset
                                let threshold = cardHeight * 0.6 // Trigger when overlapping > 60%
                                
                                if abs(effectiveOffset) > threshold {
                                    let direction: MoveDirection = effectiveOffset < 0 ? .up : .down
                                    
                                    // Only move if we changed direction or haven't moved yet
                                    if lastMoveDirection != direction {
                                        onMove(direction)
                                        lastMoveDirection = direction
                                        
                                        // Compensate for the slot change
                                        if direction == .up {
                                            baseOffset += (cardHeight + 12) // Height + spacing
                                        } else {
                                            baseOffset -= (cardHeight + 12)
                                        }
                                    } else {
                                        // Allow subsequent moves in same direction if threshold exceeded again? 
                                        // For now, requiring direction change or reset prevents rapid firing
                                        lastMoveDirection = nil 
                                    }
                                }
                            }
                            .onEnded { _ in
                                lastMoveDirection = nil
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    isDragging = false
                                    dragTranslation = 0
                                    baseOffset = 0
                                }
                            }
                    )
            } else if isEnabled {
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
            
            // Toggle Indicator - Only this button is tappable
            Button(action: {
                onToggle()
            }) {
                Image(systemName: isEnabled ? "checkmark.circle.fill" : "plus.circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isEnabled ? .green : .navyAccent)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(
            GeometryReader { geometry in
                Color.clear.onAppear {
                    cardHeight = geometry.size.height
                }
                .onChange(of: geometry.size.height) { newHeight in
                    cardHeight = newHeight
                }
            }
        )
        .opacity(isDragging ? 0.8 : 1.0)
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
                        .stroke(isEnabled ? (isDragging ? Color.navyAccent : Color.navyAccent.opacity(0.3)) : Color.white.opacity(0.1), lineWidth: isDragging ? 2 : 1)
                )
        )
        .shadow(color: isDragging ? .navyAccent.opacity(0.3) : .black.opacity(0.15), radius: isDragging ? 12 : 6, x: 0, y: isDragging ? 8 : 3)
        .offset(y: dragTranslation + baseOffset)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragging)
    }
}

#Preview {
    EditHomeStatsView()
}

