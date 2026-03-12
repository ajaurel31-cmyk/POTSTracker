import SwiftUI

struct PersonalizationView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    var onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Personalize Your Experience")
                        .font(.title2.bold())
                    Text("Help us tailor the app to your needs.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 16)

                // Diagnosis Type
                VStack(alignment: .leading, spacing: 12) {
                    Text("Diagnosis")
                        .font(.headline)

                    VStack(spacing: 8) {
                        ForEach(DiagnosisType.allCases) { diagnosis in
                            DiagnosisRow(
                                diagnosis: diagnosis,
                                isSelected: onboardingManager.selectedDiagnosis == diagnosis
                            ) {
                                onboardingManager.selectedDiagnosis = diagnosis
                            }
                        }
                    }
                }

                // Triggers
                VStack(alignment: .leading, spacing: 12) {
                    Text("Primary Triggers to Track")
                        .font(.headline)
                    Text("Select all that apply")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(Trigger.allCases) { trigger in
                            TriggerChip(
                                trigger: trigger,
                                isSelected: onboardingManager.selectedTriggers.contains(trigger)
                            ) {
                                if onboardingManager.selectedTriggers.contains(trigger) {
                                    onboardingManager.selectedTriggers.remove(trigger)
                                } else {
                                    onboardingManager.selectedTriggers.insert(trigger)
                                }
                            }
                        }
                    }
                }

                // Medications
                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Medications")
                        .font(.headline)
                    Text("Optional — you can add these later")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    TextField("e.g., Midodrine, Fludrocortisone, Metoprolol", text: $onboardingManager.medications, axis: .vertical)
                        .lineLimit(3...6)
                        .textFieldStyle(.roundedBorder)
                }

                // Continue Button
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.pink.gradient)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Subviews

private struct DiagnosisRow: View {
    let diagnosis: DiagnosisType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(diagnosis.rawValue)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .pink : .secondary)
                    .font(.title3)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.pink.opacity(0.08) : Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.pink.opacity(0.4) : .clear, lineWidth: 1.5)
            )
        }
    }
}

private struct TriggerChip: View {
    let trigger: Trigger
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: trigger.icon)
                    .font(.footnote)
                Text(trigger.rawValue)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.pink.opacity(0.12) : Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.pink.opacity(0.5) : .clear, lineWidth: 1.5)
            )
            .foregroundStyle(isSelected ? .pink : .primary)
        }
    }
}
