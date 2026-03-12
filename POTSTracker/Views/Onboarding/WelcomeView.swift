import SwiftUI

struct WelcomeView: View {
    var onContinue: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "heart.text.clipboard")
                .font(.system(size: 80))
                .foregroundStyle(.pink.gradient)

            VStack(spacing: 12) {
                Text("POTSTracker")
                    .font(.largeTitle.bold())

                Text("Track. Understand. Thrive.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Living with POTS or dysautonomia means navigating a complex web of symptoms, triggers, and treatments. POTSTracker helps you:")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Log symptoms and vitals daily")
                    FeatureRow(icon: "lightbulb", text: "Discover your personal triggers")
                    FeatureRow(icon: "doc.text", text: "Share reports with your doctor")
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)

            Spacer()

            Button(action: onContinue) {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.pink.gradient)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.pink)
                .frame(width: 28)

            Text(text)
                .font(.body)
        }
    }
}
