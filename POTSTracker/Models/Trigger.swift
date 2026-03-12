import Foundation

enum Trigger: String, CaseIterable, Identifiable, Codable {
    case heat = "Heat"
    case dehydration = "Dehydration"
    case stress = "Stress"
    case menstrualCycle = "Menstrual Cycle"
    case exercise = "Exercise"
    case foodMeals = "Food/Meals"
    case poorSleep = "Poor Sleep"
    case standingTooLong = "Standing Too Long"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .heat: return "thermometer.sun"
        case .dehydration: return "drop.triangle"
        case .stress: return "brain.head.profile"
        case .menstrualCycle: return "calendar.circle"
        case .exercise: return "figure.run"
        case .foodMeals: return "fork.knife"
        case .poorSleep: return "moon.zzz"
        case .standingTooLong: return "figure.stand"
        }
    }
}
