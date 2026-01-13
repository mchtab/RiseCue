import Foundation
import SwiftUI
import CoreLocation
import Combine
import AlarmKit

@MainActor
class SunriseViewModel: ObservableObject {
    @Published var sunriseTime: Date?
    @Published var sunsetTime: Date?
    @Published var alarmTime: Date?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var alarmEnabled = false
    @Published var currentLocationName: String?

    private let locationManager = LocationManager()
    private let sunriseService = SunriseService()
    private let alarmManager = AlarmKitManager()
    private var cancellables = Set<AnyCancellable>()

    var locationStore: LocationStore?

    init() {
        setupObservers()
        setupAlarmObserver()
    }

    private func setupObservers() {
        locationManager.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                if let location = location {
                    self?.fetchSunriseForDisplay(latitude: location.latitude, longitude: location.longitude)
                }
            }.store(in: &cancellables)
    }

    private func setupAlarmObserver() {
        // Observe alarm manager state changes
        alarmManager.$currentAlarm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alarm in
                self?.alarmEnabled = alarm != nil
            }.store(in: &cancellables)
    }

    func getCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        locationManager.requestLocation(completion: completion)
    }

    func updateSelectedLocation(_ location: SavedLocation) {
        currentLocationName = location.name
        fetchSunriseForDisplay(latitude: location.latitude, longitude: location.longitude)
    }

    func requestPermissions() {
        locationManager.requestPermission()

        Task {
            let granted = await alarmManager.requestAuthorization()
            if granted {
                print("AlarmKit permission granted")
            }
        }
    }

    /// Check if AlarmKit is authorized
    var isAlarmAuthorized: Bool {
        alarmManager.isAuthorized
    }

    // MARK: - Fetch Sunrise for Display (without scheduling alarm)

    func refreshSunriseData() {
        guard let locationStore = locationStore, let selectedLocation = locationStore.selectedLocation else {
            return
        }
        fetchSunriseForDisplay(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
    }

    private func fetchSunriseForDisplay(latitude: Double, longitude: Double) {
        isLoading = true
        errorMessage = nil

        // Always fetch tomorrow's sunrise for display (next upcoming sunrise)
        sunriseService.fetchTomorrowSunriseTime(latitude: latitude, longitude: longitude) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let sunrise):
                    self.sunriseTime = sunrise

                    // If alarm is enabled, update the alarm time too
                    if self.alarmEnabled {
                        self.updateAlarmTime(for: sunrise)
                    }

                case .failure(let error):
                    self.errorMessage = "Failed to fetch sunrise time: \(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: - Alarm Management

    func setupAlarm() {
        guard let locationStore = locationStore, let selectedLocation = locationStore.selectedLocation else {
            errorMessage = "Please select a location first"
            return
        }

        guard let sunrise = sunriseTime else {
            // Need to fetch sunrise first
            isLoading = true
            sunriseService.fetchTomorrowSunriseTime(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude) { [weak self] result in
                guard let self = self else { return }

                Task { @MainActor in
                    switch result {
                    case .success(let sunrise):
                        self.sunriseTime = sunrise
                        await self.scheduleAlarm(for: sunrise)
                    case .failure(let error):
                        self.isLoading = false
                        self.errorMessage = "Failed to fetch sunrise time: \(error.localizedDescription)"
                    }
                }
            }
            return
        }

        Task {
            await scheduleAlarm(for: sunrise)
        }
    }

    private func scheduleAlarm(for sunrise: Date) async {
        guard let locationStore = locationStore, let selectedLocation = locationStore.selectedLocation else {
            isLoading = false
            errorMessage = "Location store not initialized"
            return
        }

        let minuteOffset = locationStore.alarmTiming == .before ? -10 : 10
        guard let alarmDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: sunrise) else {
            isLoading = false
            errorMessage = "Failed to calculate alarm time"
            return
        }

        self.alarmTime = alarmDate
        let isBefore = locationStore.alarmTiming == .before
        let locationName = selectedLocation.name

        do {
            let success = try await alarmManager.scheduleAlarm(
                at: alarmDate,
                isBefore: isBefore,
                locationName: locationName
            )

            isLoading = false
            if success {
                alarmEnabled = true
                errorMessage = nil
            } else {
                errorMessage = "Failed to schedule alarm"
            }
        } catch {
            isLoading = false
            errorMessage = "Failed to schedule alarm: \(error.localizedDescription)"
        }
    }

    private func updateAlarmTime(for sunrise: Date) {
        guard let locationStore = locationStore else { return }

        let minuteOffset = locationStore.alarmTiming == .before ? -10 : 10
        if let alarmDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: sunrise) {
            self.alarmTime = alarmDate
        }
    }

    func cancelAlarm() {
        Task {
            await alarmManager.cancelAlarm()
            alarmEnabled = false
            alarmTime = nil
        }
    }

    // MARK: - Test Alarm

    /// Schedule a test alarm that fires in a few seconds (for testing)
    func scheduleTestAlarm(delaySeconds: TimeInterval = 10) {
        let testFireDate = Date().addingTimeInterval(delaySeconds)
        let locationName = locationStore?.selectedLocation?.name ?? "Test Location"

        Task {
            // First ensure we have authorization
            let authorized = await alarmManager.requestAuthorization()
            print("AlarmKit authorized: \(authorized)")

            guard authorized else {
                errorMessage = "AlarmKit not authorized. Please enable in Settings."
                print("AlarmKit authorization denied")
                return
            }

            do {
                print("Scheduling test alarm for: \(testFireDate)")
                let success = try await alarmManager.scheduleAlarm(
                    at: testFireDate,
                    isBefore: false,
                    locationName: locationName
                )

                if success {
                    alarmTime = testFireDate
                    alarmEnabled = true
                    errorMessage = nil
                    print("Test alarm scheduled successfully for \(testFireDate)")
                } else {
                    errorMessage = "Failed to schedule test alarm"
                    print("scheduleAlarm returned false")
                }
            } catch {
                errorMessage = "Test alarm error: \(error.localizedDescription)"
                print("Test alarm error: \(error)")
            }
        }
    }
}
