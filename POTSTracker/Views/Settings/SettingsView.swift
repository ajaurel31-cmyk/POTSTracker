import SwiftUI

struct SettingsView: View {
    @State private var profile: UserProfile?
    @State private var showExportSheet = false
    @State private var showDeleteConfirm = false
    @State private var showResetConfirm = false
    @State private var csvString = ""
    @State private var exportURL: URL?

    var body: some View {
        NavigationStack {
            List {
                // Profile section
                Section("Profile") {
                    if let profile = profile {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundStyle(.pink)
                            VStack(alignment: .leading) {
                                Text(profile.diagnosisType.rawValue)
                                    .font(.headline)
                                Text("Since \(profile.createdAt, format: .dateTime.month().year())")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)

                        NavigationLink("Edit Profile") {
                            EditProfileView(profile: $profile)
                        }
                    } else {
                        Text("No profile set up")
                            .foregroundStyle(.secondary)
                    }
                }

                // Medications
                if let profile = profile, !profile.medications.isEmpty {
                    Section("Medications") {
                        let meds = profile.medications.split(separator: ",").map(String.init)
                        ForEach(meds, id: \.self) { med in
                            Label(med.trimmingCharacters(in: .whitespaces), systemImage: "pills")
                        }
                    }
                }

                // Triggers
                if let profile = profile, !profile.selectedTriggers.isEmpty {
                    Section("Tracked Triggers") {
                        ForEach(profile.selectedTriggers) { trigger in
                            Label(trigger.rawValue, systemImage: trigger.icon)
                        }
                    }
                }

                // Integrations
                Section("Integrations") {
                    HStack {
                        Label("HealthKit", systemImage: "heart.text.square")
                        Spacer()
                        Text(profile?.healthKitEnabled == true ? "Enabled" : "Disabled")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Label("Notifications", systemImage: "bell.badge")
                        Spacer()
                        Text(profile?.notificationsEnabled == true ? "Enabled" : "Disabled")
                            .foregroundStyle(.secondary)
                    }
                }

                // Data Management
                Section("Data") {
                    Button {
                        exportData()
                    } label: {
                        Label("Export Data (CSV)", systemImage: "square.and.arrow.up")
                    }

                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        Label("Delete All Logs", systemImage: "trash")
                    }
                }

                // About
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Built for")
                        Spacer()
                        Text("POTS & Dysautonomia")
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showResetConfirm = true
                    } label: {
                        Label("Reset App & Profile", systemImage: "arrow.counterclockwise")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear { loadProfile() }
            .sheet(isPresented: $showExportSheet) {
                if let url = exportURL {
                    ShareSheet(items: [url])
                }
            }
            .alert("Delete All Logs?", isPresented: $showDeleteConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    DatabaseManager.shared.deleteAllData()
                    // Re-save profile so only logs are deleted
                    if let p = profile {
                        DatabaseManager.shared.saveUserProfile(p)
                    }
                }
            } message: {
                Text("This will permanently delete all your daily logs. Your profile will be kept.")
            }
            .alert("Reset Everything?", isPresented: $showResetConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    DatabaseManager.shared.deleteAllData()
                    profile = nil
                }
            } message: {
                Text("This will delete all data including your profile. You'll need to set up the app again.")
            }
        }
    }

    private func loadProfile() {
        profile = DatabaseManager.shared.loadUserProfile()
    }

    private func exportData() {
        let csv = DatabaseManager.shared.exportToCSV()
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("POTSTracker_Export.csv")
        try? csv.write(to: tempURL, atomically: true, encoding: .utf8)
        exportURL = tempURL
        showExportSheet = true
    }
}

// MARK: - Edit Profile

struct EditProfileView: View {
    @Binding var profile: UserProfile?
    @Environment(\.dismiss) private var dismiss
    @State private var diagnosisType: DiagnosisType = .undiagnosed
    @State private var selectedTriggers: Set<Trigger> = []
    @State private var medications: String = ""

    var body: some View {
        Form {
            Section("Diagnosis") {
                Picker("Type", selection: $diagnosisType) {
                    ForEach(DiagnosisType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }

            Section("Triggers") {
                ForEach(Trigger.allCases) { trigger in
                    Button {
                        if selectedTriggers.contains(trigger) {
                            selectedTriggers.remove(trigger)
                        } else {
                            selectedTriggers.insert(trigger)
                        }
                    } label: {
                        HStack {
                            Label(trigger.rawValue, systemImage: trigger.icon)
                                .foregroundStyle(.primary)
                            Spacer()
                            if selectedTriggers.contains(trigger) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.pink)
                            }
                        }
                    }
                }
            }

            Section("Medications") {
                TextField("e.g. Midodrine, Fludrocortisone", text: $medications)
                Text("Separate multiple medications with commas")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveProfile()
                    dismiss()
                }
            }
        }
        .onAppear {
            if let p = profile {
                diagnosisType = p.diagnosisType
                selectedTriggers = Set(p.selectedTriggers)
                medications = p.medications
            }
        }
    }

    private func saveProfile() {
        var updated = profile ?? UserProfile()
        updated.diagnosisType = diagnosisType
        updated.selectedTriggers = Array(selectedTriggers)
        updated.medications = medications
        DatabaseManager.shared.saveUserProfile(updated)
        profile = updated
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
