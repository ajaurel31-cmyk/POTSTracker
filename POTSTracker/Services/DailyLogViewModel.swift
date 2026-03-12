import Foundation
import SwiftUI

@MainActor
final class DailyLogViewModel: ObservableObject {
    @Published var log: DailyLog
    @Published var showSaveSuccess = false
    @Published var showExportPrompt = false
    @Published var isImportingHealthData = false

    // Symptom management
    @Published var selectedSymptomNames: Set<String> = []
    @Published var customSymptomText = ""

    // String bindings for numeric text fields
    @Published var lyingHRText = ""
    @Published var sittingHRText = ""
    @Published var standingHRText = ""
    @Published var lyingSystolicText = ""
    @Published var lyingDiastolicText = ""
    @Published var standingSystolicText = ""
    @Published var standingDiastolicText = ""
    @Published var waterIntakeText = ""
    @Published var electrolyteDrinkOzText = ""
    @Published var saltIntakeText = ""
    @Published var exerciseDurationText = ""

    private let database = DatabaseManager.shared
    private let healthKit = HealthKitManager.shared

    init(date: Date = Date()) {
        if let existing = database.loadDailyLog(for: date) {
            self.log = existing
            // Populate text fields from existing data
            lyingHRText = existing.lyingHR.map(String.init) ?? ""
            sittingHRText = existing.sittingHR.map(String.init) ?? ""
            standingHRText = existing.standingHR.map(String.init) ?? ""
            lyingSystolicText = existing.lyingSystolic.map(String.init) ?? ""
            lyingDiastolicText = existing.lyingDiastolic.map(String.init) ?? ""
            standingSystolicText = existing.standingSystolic.map(String.init) ?? ""
            standingDiastolicText = existing.standingDiastolic.map(String.init) ?? ""
            waterIntakeText = existing.waterIntake.map { String(format: "%.0f", $0) } ?? ""
            electrolyteDrinkOzText = existing.electrolyteDrinkOz.map { String(format: "%.0f", $0) } ?? ""
            saltIntakeText = existing.saltIntakeValue.map { String(format: "%.1f", $0) } ?? ""
            exerciseDurationText = existing.exerciseDurationMinutes.map(String.init) ?? ""
            selectedSymptomNames = Set(existing.symptoms.map(\.name))
        } else {
            self.log = DailyLog(date: date)
        }
    }

    // MARK: - Sync text fields to model

    func syncFieldsToModel() {
        log.lyingHR = Int(lyingHRText)
        log.sittingHR = Int(sittingHRText)
        log.standingHR = Int(standingHRText)
        log.lyingSystolic = Int(lyingSystolicText)
        log.lyingDiastolic = Int(lyingDiastolicText)
        log.standingSystolic = Int(standingSystolicText)
        log.standingDiastolic = Int(standingDiastolicText)
        log.waterIntake = Double(waterIntakeText)
        log.electrolyteDrinkOz = Double(electrolyteDrinkOzText)
        log.saltIntakeValue = Double(saltIntakeText)
        log.exerciseDurationMinutes = Int(exerciseDurationText)

        // Auto-calculate sodium
        if let value = log.saltIntakeValue, let mgPerUnit = log.saltUnit.sodiumMgPerUnit {
            log.sodiumEstimateMg = value * mgPerUnit
        } else {
            log.sodiumEstimateMg = nil
        }

        // Sync symptoms
        log.symptoms = selectedSymptomNames.map { name in
            if let existing = log.symptoms.first(where: { $0.name == name }) {
                return existing
            }
            return SymptomEntry(name: name)
        }
    }

    func updateSymptomSeverity(name: String, severity: Int) {
        if let index = log.symptoms.firstIndex(where: { $0.name == name }) {
            log.symptoms[index].severity = severity
        } else {
            log.symptoms.append(SymptomEntry(name: name, severity: severity))
        }
    }

    func severityForSymptom(_ name: String) -> Int {
        log.symptoms.first(where: { $0.name == name })?.severity ?? 3
    }

    func addCustomSymptom() {
        let trimmed = customSymptomText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        selectedSymptomNames.insert(trimmed)
        log.symptoms.append(SymptomEntry(name: trimmed, severity: 3, isCustom: true))
        customSymptomText = ""
    }

    func toggleSymptom(_ name: String) {
        if selectedSymptomNames.contains(name) {
            selectedSymptomNames.remove(name)
            log.symptoms.removeAll { $0.name == name }
        } else {
            selectedSymptomNames.insert(name)
            log.symptoms.append(SymptomEntry(name: name))
        }
    }

    // MARK: - HealthKit Import

    func importFromHealthKit() async {
        guard healthKit.isAvailable else { return }
        isImportingHealthData = true
        defer { isImportingHealthData = false }

        if let hr = await healthKit.fetchLatestHeartRate() {
            // Import as resting/lying HR if empty
            if lyingHRText.isEmpty {
                lyingHRText = String(hr)
            }
        }

        if let bp = await healthKit.fetchLatestBloodPressure() {
            if lyingSystolicText.isEmpty {
                lyingSystolicText = String(bp.systolic)
                lyingDiastolicText = String(bp.diastolic)
            }
        }
    }

    // MARK: - Save

    func save() {
        syncFieldsToModel()
        database.saveDailyLog(log)
        showSaveSuccess = true

        if log.hasCriticalVitals {
            showExportPrompt = true
        }

        // Auto-dismiss success after 2 seconds
        Task {
            try? await Task.sleep(for: .seconds(2))
            showSaveSuccess = false
        }
    }
}
