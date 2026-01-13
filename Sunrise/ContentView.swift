import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: SunriseViewModel
    @EnvironmentObject var locationStore: LocationStore
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @State private var showingLocationManagement = false
    @State private var showingSettings = false
    @State private var appearAnimation = false

    var body: some View {
        let isTablet = horizontalSizeClass == .regular
        let maxWidth: CGFloat = isTablet ? 600 : .infinity

        ZStack {
            // Animated dawn sky background - fills entire screen
            DawnSkyBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header with controls
                    headerSection
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : -20)
                        .padding(.top, 16)

                    Spacer()
                        .frame(height: isTablet ? 60 : 40)

                    // Main content area
                    VStack(spacing: isTablet ? 50 : 36) {
                        // Sun visualization
                        sunSection
                            .opacity(appearAnimation ? 1 : 0)
                            .scaleEffect(appearAnimation ? 1 : 0.8)

                        // Location indicator
                        if let locationName = viewModel.currentLocationName {
                            locationIndicator(name: locationName)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                        }

                        // Time cards
                        if viewModel.isLoading {
                            loadingSection
                        } else {
                            timeCardsSection(isTablet: isTablet)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 30)
                        }

                        // Error message if any
                        if let errorMessage = viewModel.errorMessage {
                            errorSection(message: errorMessage)
                        }
                    }
                    .frame(maxWidth: maxWidth)

                    Spacer()
                        .frame(height: isTablet ? 60 : 40)

                    // Action buttons
                    actionSection(isTablet: isTablet)
                        .frame(maxWidth: maxWidth)
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : 40)

                    Spacer()
                        .frame(height: 40)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, isTablet ? 40 : 24)
            }
            .safeAreaInset(edge: .top) { Color.clear.frame(height: 0) }
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 0) }
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $showingLocationManagement) {
            LocationManagementView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onAppear {
            viewModel.requestPermissions()
            if let selectedLocation = locationStore.selectedLocation {
                viewModel.updateSelectedLocation(selectedLocation)
            }

            withAnimation(.easeOut(duration: 1.2).delay(0.2)) {
                appearAnimation = true
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(greetingText)
                    .dawnCaption()
                Text("Sunrise")
                    .font(DawnTypography.title)
                    .foregroundColor(.adaptiveText)
            }

            Spacer()

            HStack(spacing: 12) {
                CalmIconButton(icon: "mappin.circle") {
                    showingLocationManagement = true
                }

                CalmIconButton(icon: "slider.horizontal.3") {
                    showingSettings = true
                }
            }
        }
        .padding(.top, 16)
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Good night"
        }
    }

    // MARK: - Sun Section (Adaptive)
    private var sunSection: some View {
        let timePhase = TimePhase.current()

        return VStack(spacing: 28) {
            // Show sun during day phases, subtle glow at night
            if timePhase == .night {
                // Night: Show a peaceful sleeping indicator
                nightCelestialView
            } else {
                BreathingSun(size: 100)
                    .frame(height: 180)
            }

            VStack(spacing: 10) {
                Text(timePhase == .night ? "Rest peacefully" : "Wake with the sun")
                    .dawnDisplayLarge()

                Text(timePhase == .night ? "Your sunrise alarm is set" : "Align your rhythm with nature")
                    .font(DawnTypography.subheadline)
                    .foregroundColor(.adaptiveTextSecondary)
            }
        }
    }

    private var nightCelestialView: some View {
        ZStack {
            // Soft glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.moonGlow.opacity(0.2),
                            Color.moonGlow.opacity(0.05),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)

            // Stars around
            ForEach(0..<8, id: \.self) { i in
                Circle()
                    .fill(Color.starWhite)
                    .frame(width: CGFloat.random(in: 2...4), height: CGFloat.random(in: 2...4))
                    .offset(
                        x: cos(Double(i) * .pi / 4) * 70,
                        y: sin(Double(i) * .pi / 4) * 70
                    )
                    .opacity(0.6)
            }

            // Small moon icon
            Image(systemName: "moon.fill")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(.moonGlow)
                .shadow(color: .moonGlow.opacity(0.5), radius: 20)
        }
        .frame(height: 180)
    }

    // MARK: - Location Indicator (Adaptive)
    private func locationIndicator(name: String) -> some View {
        let timePhase = TimePhase.current()

        return HStack(spacing: 8) {
            Image(systemName: "location.fill")
                .font(.system(size: 12))
                .foregroundColor(.adaptiveAccent)

            Text(name)
                .dawnCaption()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color.adaptiveCardBackground)
                .overlay(
                    Capsule()
                        .stroke(Color.adaptiveCardBorder, lineWidth: timePhase == .night ? 1 : 0)
                )
                .shadow(color: Color.adaptiveShadow, radius: 8, x: 0, y: 4)
        )
    }

    // MARK: - Loading Section (Adaptive)
    private var loadingSection: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.adaptiveAccent)

            Text("Finding your sunrise...")
                .font(DawnTypography.subheadline)
                .foregroundColor(.adaptiveTextSecondary)
        }
        .padding(.vertical, 40)
    }

    // MARK: - Time Cards Section
    private func timeCardsSection(isTablet: Bool) -> some View {
        Group {
            if isTablet {
                HStack(spacing: 20) {
                    timeCards
                }
            } else {
                VStack(spacing: 16) {
                    timeCards
                }
            }
        }
    }

    @ViewBuilder
    private var timeCards: some View {
        if let sunriseTime = viewModel.sunriseTime {
            TimeDisplay(
                time: sunriseTime,
                label: "Next Sunrise",
                icon: "sun.horizon.fill"
            )
            .transition(.asymmetric(
                insertion: .scale.combined(with: .opacity),
                removal: .opacity
            ))
        }

        if viewModel.alarmEnabled, let alarmTime = viewModel.alarmTime {
            TimeDisplay(
                time: alarmTime,
                label: "Alarm Set",
                icon: "bell.fill"
            )
            .transition(.asymmetric(
                insertion: .scale.combined(with: .opacity),
                removal: .opacity
            ))
        }
    }

    // MARK: - Error Section (Adaptive)
    private func errorSection(message: String) -> some View {
        let timePhase = TimePhase.current()
        let isNightMode = timePhase == .night || timePhase == .dusk

        return HStack(spacing: 12) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 18))
                .foregroundColor(.adaptiveAccent)

            Text(message)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.adaptiveText.opacity(0.8))
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(isNightMode ? Color.adaptiveAccent.opacity(0.15) : Color.dawnRose.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.adaptiveAccent.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Action Section
    private func actionSection(isTablet: Bool) -> some View {
        VStack(spacing: 16) {
            if locationStore.savedLocations.isEmpty {
                // No locations - show add location
                Button(action: { showingLocationManagement = true }) {
                    HStack(spacing: 10) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18))
                        Text("Add Your Location")
                    }
                }
                .buttonStyle(SoftButtonStyle(isPrimary: true))

                Button(action: { viewModel.requestPermissions() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "location.circle")
                            .font(.system(size: 16))
                        Text("Enable Permissions")
                    }
                }
                .buttonStyle(SoftButtonStyle(isPrimary: false))

            } else if !viewModel.alarmEnabled {
                // Has location, no alarm set
                Button(action: { viewModel.setupAlarm() }) {
                    HStack(spacing: 10) {
                        Image(systemName: "bell.badge")
                            .font(.system(size: 18))
                        Text("Set Sunrise Alarm")
                    }
                }
                .buttonStyle(SoftButtonStyle(isPrimary: true))

                // Test alarm button
                Button(action: { viewModel.scheduleTestAlarm(delaySeconds: 10) }) {
                    HStack(spacing: 8) {
                        Image(systemName: "bell.and.waves.left.and.right")
                            .font(.system(size: 16))
                        Text("Test Alarm (10s)")
                    }
                }
                .buttonStyle(SoftButtonStyle(isPrimary: false))

            } else {
                // Alarm is set - show status and cancel option
                alarmStatusBadge

                Button(action: { viewModel.cancelAlarm() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 16))
                        Text("Cancel Alarm")
                    }
                }
                .buttonStyle(SoftButtonStyle(isPrimary: false))
            }
        }
    }

    private var alarmStatusBadge: some View {
        let timePhase = TimePhase.current()
        let isNightMode = timePhase == .night || timePhase == .dusk

        // Adaptive success color
        let successColor = isNightMode ?
            Color(red: 0.55, green: 0.70, blue: 0.65) : // Muted teal for night
            Color.softSage

        return HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(successColor.opacity(0.3))
                    .frame(width: 36, height: 36)

                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(successColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Alarm Active")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.adaptiveText)

                Text("You'll wake with the sunrise")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.adaptiveTextSecondary)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(successColor.opacity(isNightMode ? 0.15 : 0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(successColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SunriseViewModel()
        let locationStore = LocationStore()
        viewModel.locationStore = locationStore

        return Group {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(locationStore)
                .previewDevice("iPhone 15 Pro")
                .previewDisplayName("iPhone")

            ContentView()
                .environmentObject(viewModel)
                .environmentObject(locationStore)
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
                .previewDisplayName("iPad")
        }
    }
}
