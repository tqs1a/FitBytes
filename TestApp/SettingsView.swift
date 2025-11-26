//
//  SettingsView.swift
//  TestApp
//
//  Enhanced settings screen with language selection and home stats customization
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localization = LocalizationManager.shared
    @ObservedObject private var statsPrefs = HomeStatsPreferences.shared
    @ObservedObject private var unitPrefs = WeightUnitPreferences.shared
    @State private var showingEditStats = false
    @State private var selectedLanguage: AppLanguage
    
    init() {
        _selectedLanguage = State(initialValue: LocalizationManager.shared.currentLanguage)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.amoledBlack.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Language Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: LocalizedKey.language.localized())
                            
                            VStack(spacing: 12) {
                                ForEach(AppLanguage.allCases, id: \.self) { language in
                                    LanguageOptionCard(
                                        language: language,
                                        isSelected: selectedLanguage == language,
                                        onSelect: {
                                            selectedLanguage = language
                                            localization.setLanguage(language)
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Weight Unit Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: LocalizedKey.weightUnit.localized())
                            
                            VStack(spacing: 12) {
                                ForEach(WeightUnit.allCases, id: \.self) { unit in
                                    WeightUnitOptionCard(
                                        unit: unit,
                                        isSelected: unitPrefs.selectedUnit == unit,
                                        onSelect: {
                                            unitPrefs.setUnit(unit)
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Home Stats Customization
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: LocalizedKey.customizeHomeStats.localized())
                            
                            Button(action: {
                                showingEditStats = true
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: "square.grid.2x2")
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
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(LocalizedKey.editHomeStats.localized())
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundColor(.white)
                                        
                                        Text("\(statsPrefs.enabledStats.count) \(LocalizedKey.statsEnabled.localized())")
                                            .font(.system(size: 13, weight: .regular))
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                .padding(16)
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
                            .buttonStyle(PlainButtonStyle())
                            
                            // Preview of enabled stats
                            StatsPreviewSection(enabledStats: statsPrefs.enabledStats)
                        }
                        .padding(.horizontal, 20)
                        
                        // Other Settings
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: LocalizedKey.otherSettings.localized())
                            
                            VStack(spacing: 12) {
                                SettingsOptionCard(
                                    icon: "bell.fill",
                                    title: LocalizedKey.notifications.localized(),
                                    subtitle: LocalizedKey.notificationsSubtitle.localized(),
                                    color: .orange
                                )
                                
                                SettingsOptionCard(
                                    icon: "lock.fill",
                                    title: LocalizedKey.privacy.localized(),
                                    subtitle: LocalizedKey.privacySubtitle.localized(),
                                    color: .blue
                                )
                                
                                SettingsOptionCard(
                                    icon: "shield.fill",
                                    title: LocalizedKey.security.localized(),
                                    subtitle: LocalizedKey.securitySubtitle.localized(),
                                    color: .green
                                )
                                
                                SettingsOptionCard(
                                    icon: "questionmark.circle.fill",
                                    title: LocalizedKey.helpSupport.localized(),
                                    subtitle: LocalizedKey.helpSupportSubtitle.localized(),
                                    color: .purple
                                )
                                
                                SettingsOptionCard(
                                    icon: "info.circle.fill",
                                    title: LocalizedKey.about.localized(),
                                    subtitle: LocalizedKey.aboutVersion.localized(),
                                    color: .gray
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle(LocalizedKey.settings.localized())
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedKey.done.localized()) {
                        dismiss()
                    }
                    .foregroundColor(.navyAccent)
                    .font(.system(size: 17, weight: .semibold))
                }
            }
            .sheet(isPresented: $showingEditStats) {
                EditHomeStatsView()
            }
        }
    }
}

// Section Header Component
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(.white)
    }
}

// Language Option Card Component
struct LanguageOptionCard: View {
    let language: AppLanguage
    let isSelected: Bool
    let onSelect: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                Image(systemName: "globe")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .navyAccent : .white.opacity(0.6))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: isSelected ?
                                        [.navyAccent.opacity(0.2), .navyAccent.opacity(0.1)] :
                                        [.white.opacity(0.1), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                
                Text(language.displayName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.navyAccent)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: isSelected ?
                                [.navyAccent.opacity(0.2), .navyAccent.opacity(0.1)] :
                                [.white.opacity(0.12), .white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.navyAccent.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
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

// Stats Preview Section Component
struct StatsPreviewSection: View {
    let enabledStats: [StatType]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedKey.preview.localized())
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(enabledStats.prefix(4)) { stat in
                    MiniStatCard(stat: stat)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

// Mini Stat Card for Preview
struct MiniStatCard: View {
    let stat: StatType
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: stat.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.navyAccent)
            
            Text(stat.displayName)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.08))
        )
    }
}

// Settings Option Card Component
struct SettingsOptionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Handle action
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [color.opacity(0.2), color.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(16)
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

// Weight Unit Option Card Component
struct WeightUnitOptionCard: View {
    let unit: WeightUnit
    let isSelected: Bool
    let onSelect: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                Image(systemName: "scalemass")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .navyAccent : .white.opacity(0.6))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: isSelected ?
                                        [.navyAccent.opacity(0.2), .navyAccent.opacity(0.1)] :
                                        [.white.opacity(0.1), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                
                Text(unit.displayName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.navyAccent)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: isSelected ?
                                [.navyAccent.opacity(0.2), .navyAccent.opacity(0.1)] :
                                [.white.opacity(0.12), .white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.navyAccent.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
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
    SettingsView()
}

