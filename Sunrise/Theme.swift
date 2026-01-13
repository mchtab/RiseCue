import SwiftUI

// MARK: - Dawn Typography System
// A calm, meditative type system using New York (serif) for display
// and SF Pro Rounded for UI elements. Lighter weights feel gentler for waking.

struct DawnTypography {
    // MARK: - Display Fonts (New York Serif - for poetic, warm headlines)

    /// Large hero text - "Wake with the sun" - 28pt light serif
    static let displayLarge = Font.system(size: 28, weight: .light, design: .serif)

    /// Medium display - section headers - 22pt light serif
    static let displayMedium = Font.system(size: 22, weight: .light, design: .serif)

    /// Small display - card titles - 18pt regular serif
    static let displaySmall = Font.system(size: 18, weight: .regular, design: .serif)

    // MARK: - Time Display (SF Rounded - ethereal, easy to read when groggy)

    /// Primary time - the big clock numbers - 48pt ultralight
    static let timePrimary = Font.system(size: 48, weight: .ultraLight, design: .rounded)

    /// Secondary time - smaller time displays - 36pt thin
    static let timeSecondary = Font.system(size: 36, weight: .thin, design: .rounded)

    // MARK: - UI Text (SF Rounded - soft and friendly)

    /// Title - screen titles, navigation - 24pt semibold
    static let title = Font.system(size: 24, weight: .semibold, design: .rounded)

    /// Headline - card headlines, important labels - 17pt semibold
    static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)

    /// Body - main readable text - 16pt regular
    static let body = Font.system(size: 16, weight: .regular, design: .rounded)

    /// Subheadline - secondary information - 15pt medium
    static let subheadline = Font.system(size: 15, weight: .medium, design: .rounded)

    /// Caption - timestamps, metadata - 13pt medium
    static let caption = Font.system(size: 13, weight: .medium, design: .rounded)

    /// Small caption - very small labels - 11pt semibold with tracking
    static let captionSmall = Font.system(size: 11, weight: .semibold, design: .rounded)

    // MARK: - Button Text

    /// Primary button text - 17pt semibold
    static let buttonPrimary = Font.system(size: 17, weight: .semibold, design: .rounded)

    /// Secondary button text - 15pt medium
    static let buttonSecondary = Font.system(size: 15, weight: .medium, design: .rounded)
}

// MARK: - Text Style Modifiers (Adaptive to Time Phase)

extension View {
    /// Apply dawn display large style (serif, light, warm) - adapts to time
    func dawnDisplayLarge() -> some View {
        self.font(DawnTypography.displayLarge)
            .foregroundColor(.adaptiveText)
    }

    /// Apply dawn display medium style - adapts to time
    func dawnDisplayMedium() -> some View {
        self.font(DawnTypography.displayMedium)
            .foregroundColor(.adaptiveText)
    }

    /// Apply dawn time style (large, ethereal numbers) - adapts to time
    func dawnTimeDisplay() -> some View {
        self.font(DawnTypography.timePrimary)
            .foregroundColor(.adaptiveText)
    }

    /// Apply dawn label style (uppercase, tracked) - adapts to time
    func dawnLabel() -> some View {
        self.font(DawnTypography.captionSmall)
            .tracking(1.5)
            .foregroundColor(.adaptiveTextSecondary)
    }

    /// Apply dawn caption style - adapts to time
    func dawnCaption() -> some View {
        self.font(DawnTypography.caption)
            .foregroundColor(.adaptiveTextSecondary)
    }

    /// Apply dawn body style - adapts to time
    func dawnBody() -> some View {
        self.font(DawnTypography.body)
            .foregroundColor(.adaptiveText.opacity(0.85))
    }

    /// Apply dawn headline style - adapts to time
    func dawnHeadline() -> some View {
        self.font(DawnTypography.headline)
            .foregroundColor(.adaptiveText)
    }
}

// MARK: - Dawn Theme Colors
extension Color {
    // Primary dawn gradient colors
    static let dawnPeach = Color(red: 0.98, green: 0.87, blue: 0.82)
    static let dawnRose = Color(red: 0.95, green: 0.78, blue: 0.74)
    static let dawnLavender = Color(red: 0.88, green: 0.85, blue: 0.95)
    static let dawnPeriwinkle = Color(red: 0.78, green: 0.80, blue: 0.94)
    static let dawnSky = Color(red: 0.85, green: 0.90, blue: 0.98)

    // Night sky colors
    static let nightDeep = Color(red: 0.08, green: 0.09, blue: 0.18)
    static let nightIndigo = Color(red: 0.12, green: 0.14, blue: 0.28)
    static let nightPurple = Color(red: 0.18, green: 0.16, blue: 0.32)
    static let starWhite = Color(red: 0.95, green: 0.95, blue: 1.0)
    static let moonGlow = Color(red: 0.90, green: 0.92, blue: 0.98)

    // Dusk colors
    static let duskOrange = Color(red: 0.95, green: 0.55, blue: 0.35)
    static let duskPink = Color(red: 0.85, green: 0.45, blue: 0.55)
    static let duskPurple = Color(red: 0.45, green: 0.35, blue: 0.55)

    // Accent colors
    static let sunGold = Color(red: 0.96, green: 0.76, blue: 0.48)
    static let warmCoral = Color(red: 0.92, green: 0.60, blue: 0.55)
    static let softSage = Color(red: 0.68, green: 0.75, blue: 0.66)
    static let mistBlue = Color(red: 0.65, green: 0.72, blue: 0.82)

    // Neutrals
    static let dawnCream = Color(red: 0.99, green: 0.97, blue: 0.95)
    static let warmWhite = Color(red: 1.0, green: 0.99, blue: 0.98)
    static let softCharcoal = Color(red: 0.25, green: 0.24, blue: 0.28)
    static let mutedGray = Color(red: 0.55, green: 0.53, blue: 0.56)

    // Card backgrounds
    static let cardBackground = Color.white.opacity(0.65)
    static let cardBackgroundSolid = Color(red: 0.99, green: 0.98, blue: 0.97)

    // Night-adjusted card backgrounds
    static let cardBackgroundNight = Color.white.opacity(0.12)

    // MARK: - Adaptive Colors (change based on time of day)

    /// Primary text color - adapts from charcoal (day) to soft white (night)
    static var adaptiveText: Color {
        switch TimePhase.current() {
        case .night:
            return Color(red: 0.92, green: 0.91, blue: 0.95) // Soft moonlit white
        case .dusk:
            return Color(red: 0.95, green: 0.93, blue: 0.91) // Warm cream
        case .dawn:
            return softCharcoal
        case .day:
            return softCharcoal
        }
    }

    /// Secondary/muted text color - adapts for readability
    static var adaptiveTextSecondary: Color {
        switch TimePhase.current() {
        case .night:
            return Color(red: 0.70, green: 0.72, blue: 0.80) // Pale lavender-gray
        case .dusk:
            return Color(red: 0.85, green: 0.80, blue: 0.78) // Dusty rose
        case .dawn:
            return mutedGray
        case .day:
            return mutedGray
        }
    }

    /// Accent color - warm coral adapts to softer tones at night
    static var adaptiveAccent: Color {
        switch TimePhase.current() {
        case .night:
            return Color(red: 0.75, green: 0.65, blue: 0.85) // Soft violet
        case .dusk:
            return Color(red: 0.95, green: 0.65, blue: 0.55) // Warm sunset coral
        case .dawn:
            return warmCoral
        case .day:
            return warmCoral
        }
    }

    /// Card/surface background - adapts from white to translucent dark
    static var adaptiveCardBackground: Color {
        switch TimePhase.current() {
        case .night:
            return Color.white.opacity(0.08)
        case .dusk:
            return Color.white.opacity(0.25)
        case .dawn:
            return cardBackground
        case .day:
            return cardBackground
        }
    }

    /// Card border/stroke color for definition
    static var adaptiveCardBorder: Color {
        switch TimePhase.current() {
        case .night:
            return Color.white.opacity(0.12)
        case .dusk:
            return Color.white.opacity(0.2)
        case .dawn:
            return Color.clear
        case .day:
            return Color.clear
        }
    }

    /// Shadow color - darker shadows by day, subtle glows at night
    static var adaptiveShadow: Color {
        switch TimePhase.current() {
        case .night:
            return Color.black.opacity(0.3)
        case .dusk:
            return Color.black.opacity(0.15)
        case .dawn:
            return Color.black.opacity(0.06)
        case .day:
            return Color.black.opacity(0.06)
        }
    }

    /// Icon tint that works across all phases
    static var adaptiveIconTint: Color {
        switch TimePhase.current() {
        case .night:
            return Color(red: 0.80, green: 0.75, blue: 0.90) // Soft lavender
        case .dusk:
            return Color(red: 0.95, green: 0.70, blue: 0.60) // Warm peach
        case .dawn:
            return warmCoral
        case .day:
            return warmCoral
        }
    }
}

// MARK: - Dawn Gradients
struct DawnGradients {
    static let skyGradient = LinearGradient(
        colors: [
            Color.dawnPeriwinkle.opacity(0.6),
            Color.dawnLavender.opacity(0.5),
            Color.dawnPeach.opacity(0.7),
            Color.dawnRose.opacity(0.5)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let sunriseGradient = LinearGradient(
        colors: [
            Color.sunGold.opacity(0.8),
            Color.dawnRose.opacity(0.6),
            Color.dawnPeach.opacity(0.4)
        ],
        startPoint: .bottom,
        endPoint: .top
    )

    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.8),
            Color.dawnCream.opacity(0.6)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let buttonGradient = LinearGradient(
        colors: [
            Color.warmCoral.opacity(0.9),
            Color.sunGold.opacity(0.8)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let cancelButtonGradient = LinearGradient(
        colors: [
            Color.mistBlue.opacity(0.7),
            Color.softSage.opacity(0.6)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Time of Day Phase
enum TimePhase {
    case night      // 9 PM - 5 AM
    case dawn       // 5 AM - 8 AM
    case day        // 8 AM - 6 PM
    case dusk       // 6 PM - 9 PM

    static func current() -> TimePhase {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<8: return .dawn
        case 8..<18: return .day
        case 18..<21: return .dusk
        default: return .night
        }
    }

    var isNighttime: Bool {
        self == .night || self == .dusk
    }
}

// MARK: - Celestial Background (Day/Night Cycle)
struct DawnSkyBackground: View {
    @State private var animateGradient = false
    @State private var breatheScale: CGFloat = 1.0
    @State private var starTwinkle: [Bool] = Array(repeating: false, count: 50)
    @State private var moonGlow = false

    private let timePhase = TimePhase.current()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Sky gradient based on time
                skyGradient

                // Stars (only at night/dusk)
                if timePhase == .night || timePhase == .dusk {
                    StarsView(twinkle: $starTwinkle, geometry: geometry, phase: timePhase)
                }

                // Moon (only at night)
                if timePhase == .night {
                    MoonView(glowing: $moonGlow, geometry: geometry)
                }

                // Sun glow at horizon (dawn/day/dusk)
                if timePhase != .night {
                    sunGlowView
                }

                // Subtle texture overlay
                Rectangle()
                    .fill(.ultraThinMaterial.opacity(timePhase == .night ? 0.05 : 0.1))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all, edges: .all)
        .onAppear {
            startAnimations()
        }
    }

    // MARK: - Sky Gradient
    @ViewBuilder
    private var skyGradient: some View {
        switch timePhase {
        case .night:
            LinearGradient(
                colors: [
                    Color.nightDeep,
                    Color.nightIndigo,
                    Color.nightPurple.opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

        case .dawn:
            LinearGradient(
                colors: [
                    Color.dawnPeriwinkle.opacity(animateGradient ? 0.5 : 0.6),
                    Color.dawnLavender.opacity(animateGradient ? 0.6 : 0.5),
                    Color.dawnPeach.opacity(animateGradient ? 0.6 : 0.7),
                    Color.dawnRose.opacity(animateGradient ? 0.6 : 0.5),
                    Color.sunGold.opacity(animateGradient ? 0.3 : 0.2)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

        case .day:
            LinearGradient(
                colors: [
                    Color.dawnSky.opacity(animateGradient ? 0.7 : 0.8),
                    Color.dawnPeriwinkle.opacity(animateGradient ? 0.4 : 0.5),
                    Color.dawnPeach.opacity(animateGradient ? 0.3 : 0.4),
                    Color.sunGold.opacity(0.2)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

        case .dusk:
            LinearGradient(
                colors: [
                    Color.nightPurple.opacity(animateGradient ? 0.6 : 0.7),
                    Color.duskPurple.opacity(animateGradient ? 0.5 : 0.6),
                    Color.duskPink.opacity(animateGradient ? 0.5 : 0.6),
                    Color.duskOrange.opacity(animateGradient ? 0.6 : 0.7)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    // MARK: - Sun Glow
    private var sunGlowView: some View {
        RadialGradient(
            colors: [
                glowColor.opacity(animateGradient ? 0.4 : 0.3),
                glowSecondaryColor.opacity(0.2),
                Color.clear
            ],
            center: .bottom,
            startRadius: 0,
            endRadius: 400
        )
        .scaleEffect(breatheScale)
    }

    private var glowColor: Color {
        switch timePhase {
        case .dawn: return .sunGold
        case .day: return .sunGold.opacity(0.6)
        case .dusk: return .duskOrange
        case .night: return .clear
        }
    }

    private var glowSecondaryColor: Color {
        switch timePhase {
        case .dawn: return .dawnRose
        case .day: return .dawnPeach
        case .dusk: return .duskPink
        case .night: return .clear
        }
    }

    // MARK: - Animations
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
            animateGradient = true
        }
        withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
            breatheScale = 1.15
        }

        // Twinkle stars randomly
        if timePhase == .night || timePhase == .dusk {
            for i in 0..<starTwinkle.count {
                let delay = Double.random(in: 0...3)
                let duration = Double.random(in: 1.5...3.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                        starTwinkle[i] = true
                    }
                }
            }
        }

        // Moon glow
        if timePhase == .night {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                moonGlow = true
            }
        }
    }
}

// MARK: - Stars View
struct StarsView: View {
    @Binding var twinkle: [Bool]
    let geometry: GeometryProxy
    let phase: TimePhase

    // Pre-generate star positions
    private let starPositions: [(x: CGFloat, y: CGFloat, size: CGFloat)] = {
        var positions: [(CGFloat, CGFloat, CGFloat)] = []
        for _ in 0..<50 {
            positions.append((
                CGFloat.random(in: 0...1),
                CGFloat.random(in: 0...0.7), // Keep stars in upper 70% of screen
                CGFloat.random(in: 1...3)
            ))
        }
        return positions
    }()

    var body: some View {
        ZStack {
            ForEach(0..<starPositions.count, id: \.self) { i in
                Circle()
                    .fill(Color.starWhite)
                    .frame(width: starPositions[i].size, height: starPositions[i].size)
                    .opacity(twinkle.indices.contains(i) && twinkle[i] ? 0.9 : 0.3)
                    .blur(radius: starPositions[i].size > 2 ? 0.5 : 0)
                    .position(
                        x: starPositions[i].x * geometry.size.width,
                        y: starPositions[i].y * geometry.size.height
                    )
            }
        }
        .opacity(phase == .dusk ? 0.5 : 1.0)
    }
}

// MARK: - Moon View
struct MoonView: View {
    @Binding var glowing: Bool
    let geometry: GeometryProxy

    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.moonGlow.opacity(glowing ? 0.3 : 0.2),
                            Color.moonGlow.opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)

            // Moon body
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.moonGlow,
                            Color.moonGlow.opacity(0.9),
                            Color(red: 0.82, green: 0.84, blue: 0.90)
                        ],
                        center: UnitPoint(x: 0.35, y: 0.35),
                        startRadius: 0,
                        endRadius: 30
                    )
                )
                .frame(width: 50, height: 50)
                .shadow(color: Color.moonGlow.opacity(0.5), radius: 20, x: 0, y: 0)

            // Crescent shadow (makes it look like a crescent moon)
            Circle()
                .fill(Color.nightIndigo.opacity(0.85))
                .frame(width: 45, height: 45)
                .offset(x: 12, y: -5)
                .blur(radius: 2)
        }
        .position(
            x: geometry.size.width * 0.8,
            y: geometry.size.height * 0.15
        )
    }
}

// MARK: - Breathing Sun Circle
struct BreathingSun: View {
    let size: CGFloat
    @State private var breatheScale: CGFloat = 0.95
    @State private var glowOpacity: Double = 0.3
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // Outer glow rings
            ForEach(0..<3) { i in
                Circle()
                    .stroke(
                        Color.sunGold.opacity(0.15 - Double(i) * 0.04),
                        lineWidth: 1
                    )
                    .frame(width: size + CGFloat(i * 30), height: size + CGFloat(i * 30))
                    .scaleEffect(breatheScale)
            }

            // Soft glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.sunGold.opacity(glowOpacity),
                            Color.dawnRose.opacity(glowOpacity * 0.5),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size
                    )
                )
                .frame(width: size * 2.5, height: size * 2.5)
                .scaleEffect(breatheScale)

            // Main sun circle
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.warmWhite,
                            Color.sunGold.opacity(0.9),
                            Color.warmCoral.opacity(0.7)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: Color.sunGold.opacity(0.5), radius: 30, x: 0, y: 0)
                .scaleEffect(breatheScale)

            // Inner highlight
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.8),
                            Color.clear
                        ],
                        center: UnitPoint(x: 0.35, y: 0.35),
                        startRadius: 0,
                        endRadius: size / 3
                    )
                )
                .frame(width: size * 0.7, height: size * 0.7)
                .offset(x: -size * 0.1, y: -size * 0.1)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                breatheScale = 1.05
                glowOpacity = 0.5
            }
        }
    }
}

// MARK: - Calm Card Style (Adaptive)
struct CalmCardModifier: ViewModifier {
    var isElevated: Bool = false
    private let timePhase = TimePhase.current()

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.adaptiveCardBackground)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .opacity(timePhase == .night ? 0.5 : 1.0)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.adaptiveCardBorder, lineWidth: timePhase == .night ? 1 : 0)
                    )
                    .shadow(color: Color.adaptiveShadow, radius: isElevated ? 20 : 10, x: 0, y: isElevated ? 10 : 4)
            )
    }
}

extension View {
    func calmCard(elevated: Bool = false) -> some View {
        modifier(CalmCardModifier(isElevated: elevated))
    }
}

// MARK: - Soft Button Style (Adaptive)
struct SoftButtonStyle: ButtonStyle {
    var isPrimary: Bool = true
    private let timePhase = TimePhase.current()

    func makeBody(configuration: Configuration) -> some View {
        let isNightMode = timePhase == .night || timePhase == .dusk

        configuration.label
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundColor(isPrimary ? .white : Color.adaptiveText)
            .padding(.horizontal, 32)
            .padding(.vertical, 18)
            .background(
                Capsule()
                    .fill(isPrimary ? AnyShapeStyle(adaptiveButtonGradient) : AnyShapeStyle(Color.adaptiveCardBackground))
                    .shadow(color: isPrimary ? Color.adaptiveAccent.opacity(0.3) : Color.adaptiveShadow, radius: configuration.isPressed ? 5 : 15, x: 0, y: configuration.isPressed ? 2 : 8)
            )
            .overlay(
                Capsule()
                    .stroke(isPrimary ? Color.clear : (isNightMode ? Color.white.opacity(0.15) : Color.dawnRose.opacity(0.3)), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }

    private var adaptiveButtonGradient: LinearGradient {
        switch timePhase {
        case .night:
            return LinearGradient(
                colors: [
                    Color(red: 0.55, green: 0.45, blue: 0.75),
                    Color(red: 0.45, green: 0.40, blue: 0.65)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .dusk:
            return LinearGradient(
                colors: [
                    Color(red: 0.90, green: 0.50, blue: 0.45),
                    Color(red: 0.85, green: 0.55, blue: 0.50)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        default:
            return DawnGradients.buttonGradient
        }
    }
}

// MARK: - Calm Icon Button (Adaptive)
struct CalmIconButton: View {
    let icon: String
    let action: () -> Void
    private let timePhase = TimePhase.current()

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.adaptiveText.opacity(0.8))
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(Color.adaptiveCardBackground)
                        .overlay(
                            Circle()
                                .stroke(Color.adaptiveCardBorder, lineWidth: timePhase == .night ? 1 : 0)
                        )
                        .shadow(color: Color.adaptiveShadow, radius: 8, x: 0, y: 4)
                )
        }
    }
}

// MARK: - Horizon Line Decoration
struct HorizonLine: View {
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.sunGold.opacity(0.4),
                        Color.dawnRose.opacity(0.3),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 2)
            .blur(radius: 1)
    }
}

// MARK: - Adaptive Layout Helper
struct AdaptiveStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    let spacing: CGFloat
    let content: () -> Content

    init(spacing: CGFloat = 20, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        if sizeClass == .regular {
            HStack(spacing: spacing, content: content)
        } else {
            VStack(spacing: spacing, content: content)
        }
    }
}

// MARK: - Time Display Component (Adaptive)
struct TimeDisplay: View {
    let time: Date
    let label: String
    let icon: String

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: time)
    }

    var body: some View {
        VStack(spacing: 12) {
            // Label with icon
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.adaptiveAccent)
                Text(label.uppercased())
                    .dawnLabel()
            }

            // Large time display - ethereal, light weight
            Text(timeString)
                .dawnTimeDisplay()
                .lineSpacing(4)

            // Date subtitle
            Text(dateString)
                .dawnCaption()
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 36)
        .calmCard(elevated: true)
    }
}
