import SwiftUI

struct BloodPressureCard: View {
    @ObservedObject var viewModel: DailyLogViewModel

    var body: some View {
        LogCard(title: "Blood Pressure", icon: "gauge.with.dots.needle.bottom.50percent") {
            VStack(spacing: 12) {
                Text("Lying")
                    .font(.subheadline.weight(.medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 8) {
                    NumericField(label: "Sys", text: $viewModel.lyingSystolicText, unit: "mmHg")
                }
                HStack(spacing: 8) {
                    NumericField(label: "Dia", text: $viewModel.lyingDiastolicText, unit: "mmHg")
                }

                Divider()

                Text("Standing")
                    .font(.subheadline.weight(.medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 8) {
                    NumericField(label: "Sys", text: $viewModel.standingSystolicText, unit: "mmHg")
                }
                HStack(spacing: 8) {
                    NumericField(label: "Dia", text: $viewModel.standingDiastolicText, unit: "mmHg")
                }

                // Orthostatic hypotension detection
                if let warning = orthostaticWarning {
                    WarningBadge(text: warning)
                }
            }
        }
    }

    private var orthostaticWarning: String? {
        guard let lyingSys = Int(viewModel.lyingSystolicText),
              let standingSys = Int(viewModel.standingSystolicText),
              let lyingDia = Int(viewModel.lyingDiastolicText),
              let standingDia = Int(viewModel.standingDiastolicText) else { return nil }

        let sysDrop = lyingSys - standingSys
        let diaDrop = lyingDia - standingDia

        if sysDrop >= 20 || diaDrop >= 10 {
            return "Orthostatic hypotension detected (Sys drop: \(sysDrop), Dia drop: \(diaDrop) mmHg)"
        }
        return nil
    }
}
