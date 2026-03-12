import Foundation
import SQLite3

final class DatabaseManager {
    static let shared = DatabaseManager()

    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createTables()
    }

    deinit {
        sqlite3_close(db)
    }

    // MARK: - Database Setup

    private func openDatabase() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("POTSTracker.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database: \(String(cString: sqlite3_errmsg(db)))")
        }
    }

    private func createTables() {
        let statements = [
            """
            CREATE TABLE IF NOT EXISTS user_profile (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                diagnosis_type TEXT NOT NULL,
                selected_triggers TEXT NOT NULL,
                medications TEXT NOT NULL DEFAULT '',
                healthkit_enabled INTEGER NOT NULL DEFAULT 0,
                notifications_enabled INTEGER NOT NULL DEFAULT 0,
                created_at TEXT NOT NULL
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS daily_logs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                date TEXT NOT NULL UNIQUE,
                data_json TEXT NOT NULL,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL
            );
            """
        ]

        for sql in statements {
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) != SQLITE_DONE {
                    print("Error creating table: \(String(cString: sqlite3_errmsg(db)))")
                }
            }
            sqlite3_finalize(statement)
        }
    }

    // MARK: - User Profile Operations

    func saveUserProfile(_ profile: UserProfile) {
        // Delete any existing profile first (single-user app)
        let deleteSQL = "DELETE FROM user_profile;"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteSQL, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_step(deleteStatement)
        }
        sqlite3_finalize(deleteStatement)

        let insertSQL = """
        INSERT INTO user_profile (diagnosis_type, selected_triggers, medications, healthkit_enabled, notifications_enabled, created_at)
        VALUES (?, ?, ?, ?, ?, ?);
        """

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK else {
            print("Error preparing insert: \(String(cString: sqlite3_errmsg(db)))")
            return
        }

        let triggersJSON = (try? JSONEncoder().encode(profile.selectedTriggers))
            .flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
        let dateString = ISO8601DateFormatter().string(from: profile.createdAt)

        sqlite3_bind_text(statement, 1, (profile.diagnosisType.rawValue as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (triggersJSON as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, (profile.medications as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 4, profile.healthKitEnabled ? 1 : 0)
        sqlite3_bind_int(statement, 5, profile.notificationsEnabled ? 1 : 0)
        sqlite3_bind_text(statement, 6, (dateString as NSString).utf8String, -1, nil)

        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error inserting profile: \(String(cString: sqlite3_errmsg(db)))")
        }
        sqlite3_finalize(statement)
    }

    func loadUserProfile() -> UserProfile? {
        let sql = "SELECT diagnosis_type, selected_triggers, medications, healthkit_enabled, notifications_enabled, created_at FROM user_profile LIMIT 1;"

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else { return nil }
        defer { sqlite3_finalize(statement) }

        guard sqlite3_step(statement) == SQLITE_ROW else { return nil }

        let diagnosisRaw = String(cString: sqlite3_column_text(statement, 0))
        let triggersJSON = String(cString: sqlite3_column_text(statement, 1))
        let medications = String(cString: sqlite3_column_text(statement, 2))
        let healthKitEnabled = sqlite3_column_int(statement, 3) == 1
        let notificationsEnabled = sqlite3_column_int(statement, 4) == 1

        let diagnosis = DiagnosisType(rawValue: diagnosisRaw) ?? .undiagnosed
        let triggers = (try? JSONDecoder().decode([Trigger].self, from: Data(triggersJSON.utf8))) ?? []

        return UserProfile(
            diagnosisType: diagnosis,
            selectedTriggers: triggers,
            medications: medications,
            healthKitEnabled: healthKitEnabled,
            notificationsEnabled: notificationsEnabled
        )
    }

    func hasUserProfile() -> Bool {
        let sql = "SELECT COUNT(*) FROM user_profile;"
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else { return false }
        defer { sqlite3_finalize(statement) }

        guard sqlite3_step(statement) == SQLITE_ROW else { return false }
        return sqlite3_column_int(statement, 0) > 0
    }

    // MARK: - Daily Log Operations

    private static let dateKeyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    func saveDailyLog(_ log: DailyLog) {
        let dateKey = Self.dateKeyFormatter.string(from: log.date)
        let now = ISO8601DateFormatter().string(from: Date())

        guard let jsonData = try? JSONEncoder().encode(log),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("Error encoding daily log")
            return
        }

        let sql = """
        INSERT INTO daily_logs (date, data_json, created_at, updated_at)
        VALUES (?, ?, ?, ?)
        ON CONFLICT(date) DO UPDATE SET data_json = excluded.data_json, updated_at = excluded.updated_at;
        """

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("Error preparing daily log insert: \(String(cString: sqlite3_errmsg(db)))")
            return
        }
        defer { sqlite3_finalize(statement) }

        sqlite3_bind_text(statement, 1, (dateKey as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (jsonString as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, (now as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 4, (now as NSString).utf8String, -1, nil)

        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error saving daily log: \(String(cString: sqlite3_errmsg(db)))")
        }
    }

    func loadDailyLog(for date: Date) -> DailyLog? {
        let dateKey = Self.dateKeyFormatter.string(from: date)
        let sql = "SELECT data_json FROM daily_logs WHERE date = ? LIMIT 1;"

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else { return nil }
        defer { sqlite3_finalize(statement) }

        sqlite3_bind_text(statement, 1, (dateKey as NSString).utf8String, -1, nil)

        guard sqlite3_step(statement) == SQLITE_ROW else { return nil }

        let jsonString = String(cString: sqlite3_column_text(statement, 0))
        return try? JSONDecoder().decode(DailyLog.self, from: Data(jsonString.utf8))
    }

    func loadAllDailyLogs() -> [DailyLog] {
        let sql = "SELECT data_json FROM daily_logs ORDER BY date DESC;"

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else { return [] }
        defer { sqlite3_finalize(statement) }

        var logs: [DailyLog] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            let jsonString = String(cString: sqlite3_column_text(statement, 0))
            if let log = try? JSONDecoder().decode(DailyLog.self, from: Data(jsonString.utf8)) {
                logs.append(log)
            }
        }
        return logs
    }

    func loadDailyLogs(last days: Int) -> [DailyLog] {
        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: Date()) else { return [] }
        let startKey = Self.dateKeyFormatter.string(from: startDate)

        let sql = "SELECT data_json FROM daily_logs WHERE date >= ? ORDER BY date ASC;"

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else { return [] }
        defer { sqlite3_finalize(statement) }

        sqlite3_bind_text(statement, 1, (startKey as NSString).utf8String, -1, nil)

        var logs: [DailyLog] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            let jsonString = String(cString: sqlite3_column_text(statement, 0))
            if let log = try? JSONDecoder().decode(DailyLog.self, from: Data(jsonString.utf8)) {
                logs.append(log)
            }
        }
        return logs
    }

    func deleteDailyLog(for date: Date) {
        let dateKey = Self.dateKeyFormatter.string(from: date)
        let sql = "DELETE FROM daily_logs WHERE date = ?;"

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else { return }
        defer { sqlite3_finalize(statement) }

        sqlite3_bind_text(statement, 1, (dateKey as NSString).utf8String, -1, nil)
        sqlite3_step(statement)
    }

    func deleteAllData() {
        let tables = ["daily_logs", "user_profile"]
        for table in tables {
            let sql = "DELETE FROM \(table);"
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                sqlite3_step(statement)
            }
            sqlite3_finalize(statement)
        }
    }

    func exportToCSV() -> String {
        let logs = loadAllDailyLogs()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var csv = "Date,Lying HR,Sitting HR,Standing HR,HR Increase,Lying BP,Standing BP,Symptoms,Symptom Count,Water (oz),Electrolytes,Activity Level,Hours Upright,Exercise,Sleep Hours,Sleep Quality,Unrefreshed,Triggers,Cycle Phase,Overall Rating,Notes\n"

        for log in logs {
            let date = dateFormatter.string(from: log.date)
            let lyingHR = log.lyingHR.map { "\($0)" } ?? ""
            let sittingHR = log.sittingHR.map { "\($0)" } ?? ""
            let standingHR = log.standingHR.map { "\($0)" } ?? ""
            let hrIncrease = log.orthostaticHRIncrease.map { "\($0)" } ?? ""
            let lyingBP = [log.lyingSystolic, log.lyingDiastolic].compactMap { $0.map { "\($0)" } }.joined(separator: "/")
            let standingBP = [log.standingSystolic, log.standingDiastolic].compactMap { $0.map { "\($0)" } }.joined(separator: "/")
            let symptoms = log.symptoms.map { "\($0.name)(\($0.severity))" }.joined(separator: "; ")
            let symptomCount = String(log.symptoms.count)
            let water = log.waterIntake.map(String.init) ?? ""
            let electrolytes = log.electrolyteDrinks ? "Yes" : "No"
            let activity = log.activityLevel?.rawValue ?? ""
            let upright = String(format: "%.1f", log.timeUprightHours)
            let exercise = log.exercisePerformed ? "\(log.exerciseType?.rawValue ?? "Yes") \(log.exerciseDurationMinutes ?? 0)min" : "No"
            let sleepHrs = String(format: "%.1f", log.hoursSlept)
            let sleepQual = String(log.sleepQuality)
            let unrefreshed = log.wokeUnrefreshed ? "Yes" : "No"
            let triggers = log.triggersToday.joined(separator: "; ")
            let cycle = log.cyclePhase?.rawValue ?? ""
            let rating = String(log.overallRating)
            let notes = log.notes.replacingOccurrences(of: ",", with: ";").replacingOccurrences(of: "\n", with: " ")

            csv += "\(date),\(lyingHR),\(sittingHR),\(standingHR),\(hrIncrease),\(lyingBP),\(standingBP),\"\(symptoms)\",\(symptomCount),\(water),\(electrolytes),\(activity),\(upright),\(exercise),\(sleepHrs),\(sleepQual),\(unrefreshed),\"\(triggers)\",\(cycle),\(rating),\"\(notes)\"\n"
        }

        return csv
    }
}
