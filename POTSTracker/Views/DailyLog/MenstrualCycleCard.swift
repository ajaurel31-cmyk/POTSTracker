import SwiftUI

struct MenstrualCycleCard: View {
    @ObservedObject var viewModel: DailyLogViewModel

    var body: some View {
        LogCard(title: "Menstrual Cycle", icon: "calendar.circle") {
            VStack(alignment: .leading, spacing: 10) {
                Text("Cycle phase")
                    .font(.subheadline)

                HStack(spacing: 8) {
                    ForEach(CyclePhase.allCases) { phase in
                        Button {
                            if viewModel.log.cyclePhase == phase {
                                viewModel.log.cyclePhase = nil
                            } else {
                                viewModel.log.cyclePhase = phase
                            }
                        } label: {
                            Text(phase.rawValue)
                                .font(.caption)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 6)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(viewModel.log.cyclePhase == phase ?
                                              Color.purple.opacity(0.12) : Color(.tertiarySystemBackground))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(viewModel.log.cyclePhase == phase ?
                                                Color.purple.opacity(0.4) : .clear, lineWidth: 1)
                                )
                                .foregroundStyle(viewModel.log.cyclePhase == phase ? .purple : .primary)
                        }
                    }
                }
            }
        }
    }
}
