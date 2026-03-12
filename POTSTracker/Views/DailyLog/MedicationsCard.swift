import SwiftUI

struct MedicationsCard: View {
    @ObservedObject var viewModel: DailyLogViewModel

    private var savedMedications: [String] {
        let medsString = DatabaseManager.shared.loadUserProfile()?.medications ?? ""
        return medsString
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        LogCard(title: "Medications Taken", icon: "pills.fill") {
            VStack(alignment: .leading, spacing: 10) {
                if savedMedications.isEmpty {
                    Text("No medications saved. Add them in your profile settings.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(savedMedications, id: \.self) { med in
                        MedicationRow(
                            name: med,
                            entry: viewModel.log.medicationEntries.first(where: { $0.name == med })
                        ) { status in
                            if let index = viewModel.log.medicationEntries.firstIndex(where: { $0.name == med }) {
                                viewModel.log.medicationEntries[index].status = status
                            } else {
                                viewModel.log.medicationEntries.append(MedicationEntry(name: med, status: status))
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct MedicationRow: View {
    let name: String
    let entry: MedicationEntry?
    let onStatusChange: (MedicationStatus) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(name)
                .font(.subheadline.weight(.medium))

            HStack(spacing: 8) {
                ForEach(MedicationStatus.allCases, id: \.rawValue) { status in
                    Button {
                        onStatusChange(status)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: status.icon)
                                .font(.caption2)
                            Text(status.rawValue)
                                .font(.caption)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(entry?.status == status ?
                                      statusColor(status).opacity(0.15) : Color(.tertiarySystemBackground))
                        )
                        .foregroundStyle(entry?.status == status ? statusColor(status) : .secondary)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func statusColor(_ status: MedicationStatus) -> Color {
        switch status {
        case .taken: return .green
        case .skipped: return .red
        case .doseChanged: return .orange
        }
    }
}
