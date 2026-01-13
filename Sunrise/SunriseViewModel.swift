import Foundation
import SwiftUI
import CoreLocation
import Combine

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
    private let notificationManager = NotificationManager()
    private var cancellables = Set<AnyCancellable>()

    var locationStore: LocationStore?

    init() {
        setupObservers()
    }

    private func setupObservers() {
        locationManager.$location.sink { [weak self] location in
            if let location = location {
                self?.fetchSunriseForDisplay(latitude: location.latitude, longitude: location.longitude)
            }
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

        notificationManager.requestAuthorization { granted in
            if granted {
                print("Notification permission granted")
            }
        }
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

                DispatchQueue.main.async {
                    switch result {
                    case .success(let sunrise):
                        self.sunriseTime = sunrise
                        self.scheduleAlarm(for: sunrise)
                    case .failure(let error):
                        self.isLoading = false
                        self.errorMessage = "Failed to fetch sunrise time: \(error.localizedDescription)"
                    }
                }
            }
            return
        }

        scheduleAlarm(for: sunrise)
    }

    private func scheduleAlarm(for sunrise: Date) {
        guard let locationStore = locationStore else {
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

        notificationManager.scheduleDailyAlarm(at: alarmDate, isBefore: locationStore.alarmTiming == .before) { [weak self] success in
            DispatchQueue.main.async {
                self?.isLoading = false
                if success {
                    self?.alarmEnabled = true
                    self?.errorMessage = nil
                } else {
                    self?.errorMessage = "Failed to schedule alarm"
                }
            }
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
        notificationManager.cancelAllAlarms()
        alarmEnabled = false
        alarmTime = nil
    }
}
