import Foundation

struct UserProfile: Codable {
    var diagnosisType: DiagnosisType
    var selectedTriggers: [Trigger]
    var medications: String
    var healthKitEnabled: Bool
    var notificationsEnabled: Bool
    var createdAt: Date

    init(
        diagnosisType: DiagnosisType = .undiagnosed,
        selectedTriggers: [Trigger] = [],
        medications: String = "",
        healthKitEnabled: Bool = false,
        notificationsEnabled: Bool = false
    ) {
        self.diagnosisType = diagnosisType
        self.selectedTriggers = selectedTriggers
        self.medications = medications
        self.healthKitEnabled = healthKitEnabled
        self.notificationsEnabled = notificationsEnabled
        self.createdAt = Date()
    }
}
