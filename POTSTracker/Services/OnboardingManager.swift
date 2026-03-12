import Foundation
import HealthKit
import UserNotifications

@MainActor
final class OnboardingManager: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var hasCompletedOnboarding: Bool

    // Screen 2: Personalization
    @Published var selectedDiagnosis: DiagnosisType = .undiagnosed
    @Published var selectedTriggers: Set<Trigger> = []
    @Published var medications: String = ""

    // Screen 3: Permissions
    @Published var healthKitEnabled: Bool = false
    @Published var notificationsEnabled: Bool = false

    private let database = DatabaseManager.shared

    init() {
        self.hasCompletedOnboarding = database.hasUserProfile()
    }

    func completeOnboarding() {
        let profile = UserProfile(
            diagnosisType: selectedDiagnosis,
            selectedTriggers: Array(selectedTriggers),
            medications: medications.trimmingCharacters(in: .whitespacesAndNewlines),
            healthKitEnabled: healthKitEnabled,
            notificationsEnabled: notificationsEnabled
        )
        database.saveUserProfile(profile)
        hasCompletedOnboarding = true
    }

    func requestHealthKitPermission() async {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let store = HKHealthStore()
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        ]

        do {
            try await store.requestAuthorization(toShare: [], read: typesToRead)
            healthKitEnabled = true
        } catch {
            print("HealthKit authorization failed: \(error)")
            healthKitEnabled = false
        }
    }

    func requestNotificationPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            notificationsEnabled = granted
        } catch {
            print("Notification authorization failed: \(error)")
            notificationsEnabled = false
        }
    }
}
