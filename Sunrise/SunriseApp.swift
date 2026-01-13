import SwiftUI
import UserNotifications
import BackgroundTasks

@main
struct SunriseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var locationStore = LocationStore()
    @StateObject private var viewModel = SunriseViewModel()

    init() {
        let locationStore = LocationStore()
        let viewModel = SunriseViewModel()
        viewModel.locationStore = locationStore
        _locationStore = StateObject(wrappedValue: locationStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(locationStore)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }

        registerBackgroundTasks()

        return true
    }

    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.sunrise.app.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()

        let locationStore = LocationStore()
        let sunriseService = SunriseService()
        let notificationManager = NotificationManager()

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        guard let selectedLocation = locationStore.selectedLocation else {
            task.setTaskCompleted(success: false)
            return
        }

        sunriseService.fetchSunriseTime(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude) { result in
            switch result {
            case .success(let sunriseDate):
                let minuteOffset = locationStore.alarmTiming == .before ? -10 : 10
                let alarmDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: sunriseDate)!
                notificationManager.scheduleDailyAlarm(at: alarmDate, isBefore: locationStore.alarmTiming == .before) { success in
                    task.setTaskCompleted(success: success)
                }
            case .failure:
                task.setTaskCompleted(success: false)
            }
        }
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.sunrise.app.refresh")
        request.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 12, to: Date())

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}
