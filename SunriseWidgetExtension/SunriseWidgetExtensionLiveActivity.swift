//
//  SunriseWidgetExtensionLiveActivity.swift
//  SunriseWidgetExtension
//
//  Created by Michael Chen on 1/13/26.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AlarmKit

/// Live Activity widget for sunrise alarm display on Lock Screen and Dynamic Island
struct SunriseWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributes<SunriseAlarmData>.self) { context in
            // Lock Screen / StandBy presentation
            LockScreenView(state: context.state, metadata: context.attributes.metadata ?? SunriseAlarmData())
                .activityBackgroundTint(.black.opacity(0.7))
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded region
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "sunrise.fill")
                        .foregroundStyle(.orange)
                        .font(.title2)
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 2) {
                        Text("Sunrise Alarm")
                            .font(.headline)
                            .foregroundStyle(.white)
                        if let metadata = context.attributes.metadata, !metadata.locationName.isEmpty {
                            Text(metadata.locationName)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: "bell.fill")
                        .foregroundStyle(.orange)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    CountdownView(state: context.state)
                }
            } compactLeading: {
                Image(systemName: "sunrise.fill")
                    .foregroundStyle(.orange)
            } compactTrailing: {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.orange)
            } minimal: {
                Image(systemName: "sunrise.fill")
                    .foregroundStyle(.orange)
            }
        }
    }
}

// MARK: - Lock Screen View

struct LockScreenView: View {
    let state: AlarmPresentationState
    let metadata: SunriseAlarmData

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "sunrise.fill")
                .font(.system(size: 40))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .yellow],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("Sunrise Alarm")
                    .font(.headline)
                    .foregroundStyle(.white)

                if !metadata.locationName.isEmpty {
                    Text(metadata.locationName)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }

                CountdownView(state: state)
            }

            Spacer()

            Image(systemName: "bell.fill")
                .font(.title2)
                .foregroundStyle(.orange)
        }
        .padding()
    }
}

// MARK: - Countdown View

struct CountdownView: View {
    let state: AlarmPresentationState

    var body: some View {
        // Handle countdown mode if present
        if case let .countdown(countdown) = state.mode {
            Text(timerInterval: Date.now...countdown.fireDate)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .monospacedDigit()
        } else {
            Text("Alarm Set")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
    }
}
