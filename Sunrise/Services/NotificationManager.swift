import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var isAuthorized = false

    init() {
        checkAuthorizationStatus()
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                completion(granted)
            }

            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }

    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }

    func scheduleDailyAlarm(at date: Date, isBefore: Bool, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = "Sunrise Alarm"
        content.body = isBefore ? "Good morning! The sun will rise in 10 minutes." : "Good morning! The sun has risen!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm.caf"))
        content.categoryIdentifier = "SUNRISE_ALARM"
        content.interruptionLevel = .timeSensitive

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: "daily_sunrise_alarm", content: content, trigger: trigger)

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_sunrise_alarm"])

        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error scheduling notification: \(error)")
                    completion(false)
                } else {
                    print("Successfully scheduled daily alarm for \(components.hour ?? 0):\(components.minute ?? 0)")
                    completion(true)
                }
            }
        }
    }

    func cancelAllAlarms() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
}
