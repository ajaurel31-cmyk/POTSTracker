import SwiftUI

struct TriggersCard: View {
    @ObservedObject var viewModel: DailyLogViewModel
    @EnvironmentObject var onboardingManager: OnboardingManager
    @State private var customTriggerText = ""

    private var allTriggers: [String] {
        let personalizedTriggers = DatabaseManager.shared.loadUserProfile()?.selectedTriggers.map(\.rawValue) ?? []
        let customTriggers = viewModel.log.triggersToday.filter { name in
            !Trigger.allCases.contains(where: { $0.rawValue == name })
        }
        return personalizedTriggers + customTriggers
    }

    var body: some View {
        LogCard(title: "Triggers Today", icon: "bolt.fill") {
            VStack(alignment: .leading, spacing: 12) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(allTriggers, id: \.self) { trigger in
                        Button {
                            if viewModel.log.triggersToday.contains(trigger) {
                                viewModel.log.triggersToday.removeAll { $0 == trigger }
                            } else {
                                viewModel.log.triggersToday.append(trigger)
                            }
                        } label: {
                            Text(trigger)
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(viewModel.log.triggersToday.contains(trigger) ?
                                              Color.orange.opacity(0.12) : Color(.tertiarySystemBackground))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(viewModel.log.triggersToday.contains(trigger) ?
                                                Color.orange.opacity(0.4) : .clear, lineWidth: 1)
                                )
                                .foregroundStyle(viewModel.log.triggersToday.contains(trigger) ? .orange : .primary)
                        }
                    }
                }

                HStack {
                    TextField("Add custom trigger", text: $customTriggerText)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        let trimmed = customTriggerText.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        viewModel.log.triggersToday.append(trimmed)
                        customTriggerText = ""
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.orange)
                    }
                    .disabled(customTriggerText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
