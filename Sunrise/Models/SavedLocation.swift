import Foundation
import CoreLocation

enum AlarmTiming: String, Codable, CaseIterable {
    case before = "Before Sunrise"
    case after = "After Sunrise"
}

struct SavedLocation: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var isSelected: Bool

    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.isSelected = isSelected
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

class LocationStore: ObservableObject {
    @Published var savedLocations: [SavedLocation] = []
    @Published var alarmTiming: AlarmTiming = .before

    private let locationsKey = "SavedLocations"
    private let timingKey = "AlarmTiming"

    init() {
        loadLocations()
        loadAlarmTiming()
    }

    var selectedLocation: SavedLocation? {
        savedLocations.first(where: { $0.isSelected })
    }

    func addLocation(_ location: SavedLocation) {
        savedLocations.append(location)
        saveLocations()
    }

    func deleteLocation(at offsets: IndexSet) {
        savedLocations.remove(atOffsets: offsets)
        saveLocations()
    }

    func deleteLocation(_ location: SavedLocation) {
        savedLocations.removeAll(where: { $0.id == location.id })
        saveLocations()
    }

    func selectLocation(_ location: SavedLocation) {
        for index in savedLocations.indices {
            savedLocations[index].isSelected = (savedLocations[index].id == location.id)
        }
        saveLocations()
    }

    func updateAlarmTiming(_ timing: AlarmTiming) {
        alarmTiming = timing
        UserDefaults.standard.set(timing.rawValue, forKey: timingKey)
    }

    private func saveLocations() {
        if let encoded = try? JSONEncoder().encode(savedLocations) {
            UserDefaults.standard.set(encoded, forKey: locationsKey)
        }
    }

    private func loadLocations() {
        if let data = UserDefaults.standard.data(forKey: locationsKey),
           let decoded = try? JSONDecoder().decode([SavedLocation].self, from: data) {
            savedLocations = decoded
        }
    }

    private func loadAlarmTiming() {
        if let timingString = UserDefaults.standard.string(forKey: timingKey),
           let timing = AlarmTiming(rawValue: timingString) {
            alarmTiming = timing
        }
    }
}
