import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var locationStore: LocationStore
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @State private var appearAnimation = false
    private let timePhase = TimePhase.current()

    var body: some View {
        let isTablet = horizontalSizeClass == .regular

        NavigationView {
            ZStack {
                // Background - adaptive to time
                adaptiveBackground
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Header illustration
                        settingsHeader
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : -20)

                        // Settings cards
                        VStack(spacing: 20) {
                            alarmTimingCard
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)

                            aboutCard
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 30)
                        }
                        .frame(maxWidth: isTablet ? 500 : .infinity)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.adaptiveText)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Text("Done")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.adaptiveAccent)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) {
                appearAnimation = true
            }
        }
    }

    // MARK: - Adaptive Background
    @ViewBuilder
    private var adaptiveBackground: some View {
        switch timePhase {
        case .night:
            LinearGradient(
                colors: [Color.nightDeep, Color.nightIndigo, Color.nightPurple.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .dusk:
            LinearGradient(
                colors: [Color.nightPurple.opacity(0.6), Color.duskPurple, Color.duskPink.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
        default:
            Color.dawnCream
        }
    }

    // MARK: - Settings Header (Adaptive)
    private var settingsHeader: some View {
        let isNightMode = timePhase == .night || timePhase == .dusk

        return VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                (isNightMode ? Color.moonGlow : Color.sunGold).opacity(0.3),
                                (isNightMode ? Color.nightPurple : Color.dawnPeach).opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)

                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 36, weight: .light))
                    .foregroundColor(.adaptiveAccent)
            }

            Text("Customize your wake")
                .dawnDisplayMedium()
        }
        .padding(.top, 20)
    }

    // MARK: - Alarm Timing Card (Adaptive)
    private var alarmTimingCard: some View {
        let isNightMode = timePhase == .night || timePhase == .dusk

        return VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill((isNightMode ? Color.moonGlow : Color.sunGold).opacity(0.2))
                        .frame(width: 40, height: 40)

                    Image(systemName: "clock")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isNightMode ? .moonGlow : .sunGold)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Alarm Timing")
                        .dawnHeadline()

                    Text("When should we wake you?")
                        .dawnCaption()
                }

                Spacer()
            }

            // Custom segmented picker
            HStack(spacing: 0) {
                ForEach(AlarmTiming.allCases, id: \.self) { timing in
                    timingOption(timing)
                }
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isNightMode ? Color.white.opacity(0.1) : Color.dawnPeach.opacity(0.3))
            )

            // Description
            HStack(spacing: 10) {
                Image(systemName: locationStore.alarmTiming == .before ? "sunrise" : "sun.max")
                    .font(.system(size: 16))
                    .foregroundColor(.adaptiveAccent)
                    .frame(width: 24)

                Text(locationStore.alarmTiming == .before ?
                     "Your alarm will ring 10 minutes before sunrise, giving you time to prepare for the day ahead." :
                     "Your alarm will ring 10 minutes after sunrise, letting you wake naturally with the light.")
                    .dawnBody()
                    .lineSpacing(5)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isNightMode ? Color.white.opacity(0.08) : Color.dawnLavender.opacity(0.2))
            )
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.adaptiveCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.adaptiveCardBorder, lineWidth: isNightMode ? 1 : 0)
                )
                .shadow(color: Color.adaptiveShadow, radius: 20, x: 0, y: 8)
        )
    }

    private func timingOption(_ timing: AlarmTiming) -> some View {
        let isSelected = locationStore.alarmTiming == timing
        let isNightMode = timePhase == .night || timePhase == .dusk

        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                locationStore.updateAlarmTiming(timing)
            }
        }) {
            VStack(spacing: 6) {
                Image(systemName: timing == .before ? "sunrise" : "sun.max")
                    .font(.system(size: 18, weight: .medium))

                Text(timing == .before ? "Before" : "After")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
            }
            .foregroundColor(isSelected ? .white : Color.adaptiveText.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color.adaptiveAccent : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - About Card (Adaptive)
    private var aboutCard: some View {
        let isNightMode = timePhase == .night || timePhase == .dusk

        // Adaptive nature color
        let natureColor = isNightMode ?
            Color(red: 0.55, green: 0.70, blue: 0.65) : // Muted teal for night
            Color.softSage

        return VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(natureColor.opacity(0.2))
                        .frame(width: 40, height: 40)

                    Image(systemName: "leaf")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(natureColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("About Sunrise")
                        .dawnHeadline()

                    Text("Wake naturally, live fully")
                        .dawnCaption()
                }

                Spacer()
            }

            Text("Sunrise helps you align your sleep cycle with natural light patterns. Waking with the sun has been shown to improve mood, energy levels, and overall well-being.")
                .dawnBody()
                .lineSpacing(6)

            HStack(spacing: 8) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.adaptiveAccent.opacity(0.6))

                Text("Version 1.0")
                    .font(DawnTypography.captionSmall)
                    .foregroundColor(.adaptiveTextSecondary)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.adaptiveCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.adaptiveCardBorder, lineWidth: isNightMode ? 1 : 0)
                )
                .shadow(color: Color.adaptiveShadow, radius: 20, x: 0, y: 8)
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(LocationStore())
    }
}
