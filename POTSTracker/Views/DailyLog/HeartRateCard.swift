import SwiftUI

struct HeartRateCard: View {
    @ObservedObject var viewModel: DailyLogViewModel

    var body: some View {
        LogCard(title: "Heart Rate", icon: "heart.fill") {
            VStack(spacing: 12) {
                NumericField(label: "Lying", text: $viewModel.lyingHRText)
                NumericField(label: "Sitting", text: $viewModel.sittingHRText)
                NumericField(label: "Standing", text: $viewModel.standingHRText)

                // Orthostatic HR increase
                if let increase = computedIncrease {
                    HStack {
                        Text("Orthostatic increase:")
                            .font(.subheadline)
                        Spacer()
                        Text("+\(increase) BPM")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(increase >= 30 ? .orange : .green)
                    }

                    if increase >= 30 {
                        WarningBadge(text: "Possible POTS criteria met (\u{2265}30 BPM increase)")
                    }
                }

                if HealthKitManager.shared.isAvailable {
                    Button {
                        Task { await viewModel.importFromHealthKit() }
                    } label: {
                        HStack(spacing: 6) {
                            if viewModel.isImportingHealthData {
                                ProgressView()
                                    .controlSize(.small)
                            } else {
                                Image(systemName: "heart.text.clipboard")
                            }
                            Text("Import from Apple Health")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.pink.opacity(0.1))
                        .foregroundStyle(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .disabled(viewModel.isImportingHealthData)
                }
            }
        }
    }

    private var computedIncrease: Int? {
        guard let lying = Int(viewModel.lyingHRText),
              let standing = Int(viewModel.standingHRText) else { return nil }
        return standing - lying
    }
}
