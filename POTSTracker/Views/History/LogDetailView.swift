import SwiftUI

struct LogDetailView: View {
    let log: DailyLog

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Overall rating
                LogCard(title: "Overall Day Rating", icon: "star.fill") {
                    HStack {
                        ForEach(1...10, id: \.self) { i in
                            Image(systemName: i <= log.overallRating ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundStyle(i <= log.overallRating ? .yellow : .gray.opacity(0.3))
                        }
                        Spacer()
                        Text("\(log.overallRating)/10")
                            .font(.headline)
                    }
                }

                // Vitals
                if log.lyingHR != nil || log.standingHR != nil {
                    LogCard(title: "Heart Rate", icon: "heart.fill") {
                        VStack(spacing: 8) {
                            vitalRow("Lying", value: log.lyingHR, unit: "BPM")
                            vitalRow("Sitting", value: log.sittingHR, unit: "BPM")
                            vitalRow("Standing", value: log.standingHR, unit: "BPM")
                            if let delta = log.orthostaticHRIncrease {
                                Divider()
                                HStack {
                                    Text("Orthostatic Increase")
                                        .font(.subheadline.weight(.medium))
                                    Spacer()
                                    Text("+\(delta) BPM")
                                        .font(.subheadline.weight(.bold))
                                        .foregroundStyle(delta >= 30 ? .red : .green)
                                }
                                if delta >= 30 {
                                    WarningBadge(text: "Meets POTS criteria (≥30 BPM)")
                                }
                            }
                        }
                    }
                }

                // Blood Pressure
                if log.lyingSystolic != nil || log.standingSystolic != nil {
                    LogCard(title: "Blood Pressure", icon: "waveform.path.ecg") {
                        VStack(spacing: 8) {
                            if let sys = log.lyingSystolic, let dia = log.lyingDiastolic {
                                bpRow("Lying", systolic: sys, diastolic: dia)
                            }
                            if let sys = log.standingSystolic, let dia = log.standingDiastolic {
                                bpRow("Standing", systolic: sys, diastolic: dia)
                            }
                            if log.hasOrthostaticHypotension {
                                WarningBadge(text: "Orthostatic Hypotension detected")
                            }
                        }
                    }
                }

                // Symptoms
                if !log.symptoms.isEmpty {
                    LogCard(title: "Symptoms (\(log.symptoms.count))", icon: "staroflife") {
                        VStack(spacing: 6) {
                            ForEach(log.symptoms) { symptom in
                                HStack {
                                    Text(symptom.name)
                                        .font(.subheadline)
                                    Spacer()
                                    HStack(spacing: 2) {
                                        ForEach(1...5, id: \.self) { level in
                                            Circle()
                                                .fill(level <= symptom.severity ? severityColor(symptom.severity) : Color.gray.opacity(0.2))
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Hydration
                LogCard(title: "Hydration", icon: "drop.fill") {
                    VStack(spacing: 6) {
                        if let water = log.waterIntake {
                            detailRow("Water", value: "\(Int(water)) \(log.waterUnit.rawValue)")
                        }
                        detailRow("Electrolytes", value: log.electrolyteDrinks ? "Yes" : "No")
                        if let salt = log.saltIntakeValue {
                            detailRow("Salt", value: "\(Int(salt)) \(log.saltUnit.rawValue)")
                        }
                    }
                }

                // Activity
                LogCard(title: "Activity", icon: "figure.walk") {
                    VStack(spacing: 6) {
                        if let level = log.activityLevel {
                            detailRow("Level", value: level.rawValue)
                        }
                        detailRow("Time Upright", value: String(format: "%.1f hours", log.timeUprightHours))
                        if log.exercisePerformed {
                            detailRow("Exercise", value: "\(log.exerciseType?.rawValue ?? "Yes") — \(log.exerciseDurationMinutes ?? 0) min")
                        }
                    }
                }

                // Sleep
                LogCard(title: "Sleep", icon: "moon.fill") {
                    VStack(spacing: 6) {
                        detailRow("Hours", value: String(format: "%.1f", log.hoursSlept))
                        detailRow("Quality", value: "\(log.sleepQuality)/5")
                        if log.wokeUnrefreshed {
                            WarningBadge(text: "Woke unrefreshed")
                        }
                    }
                }

                // Triggers
                if !log.triggersToday.isEmpty {
                    LogCard(title: "Triggers", icon: "exclamationmark.triangle") {
                        FlowLayout(spacing: 6) {
                            ForEach(log.triggersToday, id: \.self) { trigger in
                                Text(trigger)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.orange.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }

                // Medications
                if !log.medicationEntries.isEmpty {
                    LogCard(title: "Medications", icon: "pills.fill") {
                        VStack(spacing: 6) {
                            ForEach(log.medicationEntries) { med in
                                HStack {
                                    Text(med.name)
                                        .font(.subheadline)
                                    Spacer()
                                    Label(med.status.rawValue, systemImage: med.status.icon)
                                        .font(.caption)
                                        .foregroundStyle(statusColor(med.status))
                                }
                            }
                        }
                    }
                }

                // Cycle
                if let phase = log.cyclePhase {
                    LogCard(title: "Menstrual Cycle", icon: "calendar.circle") {
                        Text(phase.rawValue)
                            .font(.subheadline)
                    }
                }

                // Notes
                if !log.notes.isEmpty {
                    LogCard(title: "Notes", icon: "note.text") {
                        Text(log.notes)
                            .font(.subheadline)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(log.date.formatted(.dateTime.month().day().year()))
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helpers

    private func vitalRow(_ label: String, value: Int?, unit: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            if let val = value {
                Text("\(val) \(unit)")
                    .font(.subheadline.weight(.medium))
            } else {
                Text("—")
                    .foregroundStyle(.tertiary)
            }
        }
    }

    private func bpRow(_ label: String, systolic: Int, diastolic: Int) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(systolic)/\(diastolic) mmHg")
                .font(.subheadline.weight(.medium))
        }
    }

    private func detailRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
        }
    }

    private func severityColor(_ severity: Int) -> Color {
        switch severity {
        case 1: return .green
        case 2: return .yellow
        case 3: return .orange
        case 4...5: return .red
        default: return .gray
        }
    }

    private func statusColor(_ status: MedicationStatus) -> Color {
        switch status {
        case .taken: return .green
        case .skipped: return .red
        case .doseChanged: return .orange
        }
    }
}

// Simple flow layout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
