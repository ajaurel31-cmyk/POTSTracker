import Foundation

struct DailyLog: Codable, Identifiable {
    var id: Int64?
    var date: Date

    // Heart Rate
    var lyingHR: Int?
    var sittingHR: Int?
    var standingHR: Int?

    // Blood Pressure
    var lyingSystolic: Int?
    var lyingDiastolic: Int?
    var standingSystolic: Int?
    var standingDiastolic: Int?

    // Symptoms
    var symptoms: [SymptomEntry]

    // Hydration & Salt
    var waterIntake: Double?
    var waterUnit: VolumeUnit
    var electrolyteDrinks: Bool
    var electrolyteDrinkOz: Double?
    var saltIntakeValue: Double?
    var saltUnit: SaltUnit
    var sodiumEstimateMg: Double?

    // Activity & Posture
    var activityLevel: ActivityLevel?
    var timeUprightHours: Double
    var exercisePerformed: Bool
    var exerciseType: ExerciseType?
    var exerciseDurationMinutes: Int?
    var exerciseIntensity: Int?

    // Sleep
    var hoursSlept: Double
    var sleepQuality: Int
    var wokeUnrefreshed: Bool

    // Triggers
    var triggersToday: [String]

    // Menstrual Cycle
    var cyclePhase: CyclePhase?

    // Medications
    var medicationEntries: [MedicationEntry]

    // Overall
    var overallRating: Int
    var notes: String

    init(date: Date = Date()) {
        self.date = date
        self.symptoms = []
        self.waterUnit = .oz
        self.electrolyteDrinks = false
        self.saltUnit = .pinches
        self.activityLevel = nil
        self.timeUprightHours = 4
        self.exercisePerformed = false
        self.hoursSlept = 7
        self.sleepQuality = 3
        self.wokeUnrefreshed = false
        self.triggersToday = []
        self.medicationEntries = []
        self.overallRating = 5
        self.notes = ""
    }

    // MARK: - Computed Properties

    var orthostaticHRIncrease: Int? {
        guard let lying = lyingHR, let standing = standingHR else { return nil }
        return standing - lying
    }

    var systolicDrop: Int? {
        guard let lying = lyingSystolic, let standing = standingSystolic else { return nil }
        return lying - standing
    }

    var diastolicDrop: Int? {
        guard let lying = lyingDiastolic, let standing = standingDiastolic else { return nil }
        return lying - standing
    }

    var hasOrthostaticHypotension: Bool {
        (systolicDrop ?? 0) >= 20 || (diastolicDrop ?? 0) >= 10
    }

    var hasCriticalVitals: Bool {
        if let increase = orthostaticHRIncrease, increase >= 30 { return true }
        if hasOrthostaticHypotension { return true }
        return false
    }
}

// MARK: - Supporting Types

struct SymptomEntry: Codable, Identifiable {
    var id: String { name }
    var name: String
    var severity: Int // 1-5
    var isCustom: Bool

    init(name: String, severity: Int = 3, isCustom: Bool = false) {
        self.name = name
        self.severity = severity
        self.isCustom = isCustom
    }
}

enum VolumeUnit: String, Codable, CaseIterable {
    case oz = "oz"
    case mL = "mL"
}

enum SaltUnit: String, Codable, CaseIterable {
    case pinches = "pinches"
    case packets = "packets"
    case grams = "grams"

    var sodiumMgPerUnit: Double? {
        switch self {
        case .grams: return 388.0 // mg sodium per gram of table salt
        default: return nil
        }
    }
}

enum ActivityLevel: String, Codable, CaseIterable, Identifiable {
    case bedbound = "Bedbound"
    case mostlyResting = "Mostly Resting"
    case lightActivity = "Light Activity"
    case moderate = "Moderate"
    case active = "Active"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .bedbound: return "bed.double"
        case .mostlyResting: return "sofa"
        case .lightActivity: return "figure.walk"
        case .moderate: return "figure.hiking"
        case .active: return "figure.run"
        }
    }
}

enum ExerciseType: String, Codable, CaseIterable, Identifiable {
    case recumbentBike = "Recumbent Bike"
    case swimming = "Swimming"
    case walking = "Walking"
    case rowing = "Rowing"
    case other = "Other"

    var id: String { rawValue }
}

enum CyclePhase: String, Codable, CaseIterable, Identifiable {
    case onPeriod = "On Period"
    case prePeriod = "Pre-Period"
    case midCycle = "Mid-Cycle"
    case postPeriod = "Post-Period"

    var id: String { rawValue }
}

struct MedicationEntry: Codable, Identifiable {
    var id: String { name }
    var name: String
    var status: MedicationStatus

    init(name: String, status: MedicationStatus = .taken) {
        self.name = name
        self.status = status
    }
}

enum MedicationStatus: String, Codable, CaseIterable {
    case taken = "Taken"
    case skipped = "Skipped"
    case doseChanged = "Dose Changed"

    var icon: String {
        switch self {
        case .taken: return "checkmark.circle.fill"
        case .skipped: return "xmark.circle.fill"
        case .doseChanged: return "arrow.triangle.2.circlepath"
        }
    }

    var color: String {
        switch self {
        case .taken: return "green"
        case .skipped: return "red"
        case .doseChanged: return "orange"
        }
    }
}

enum StandardSymptom: String, CaseIterable {
    case lightheadedness = "Lightheadedness / Presyncope"
    case brainFog = "Brain Fog"
    case fatigue = "Fatigue"
    case palpitations = "Palpitations"
    case chestPain = "Chest Pain"
    case shortnessOfBreath = "Shortness of Breath"
    case headache = "Headache"
    case nausea = "Nausea"
    case exerciseIntolerance = "Exercise Intolerance"
    case tremors = "Tremors/Shakiness"
    case temperatureDysregulation = "Temperature Dysregulation"
    case visualDisturbances = "Visual Disturbances"
    case fainting = "Fainting / Near-fainting"
    case giIssues = "GI Issues"
}
