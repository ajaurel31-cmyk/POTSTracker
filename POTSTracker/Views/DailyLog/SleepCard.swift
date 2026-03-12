import SwiftUI

struct SleepCard: View {
    @ObservedObject var viewModel: DailyLogViewModel

    var body: some View {
        LogCard(title: "Sleep", icon: "moon.zzz.fill") {
            VStack(spacing: 14) {
                // Hours slept
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Hours slept")
                            .font(.subheadline)
                        Spacer()
                        Text(String(format: "%.1f", viewModel.log.hoursSlept))
                            .font(.subheadline.weight(.medium))
                    }
                    Slider(value: $viewModel.log.hoursSlept, in: 0...14, step: 0.5)
                        .tint(.indigo)
                }

                // Sleep quality
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sleep quality")
                        .font(.subheadline)
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { star in
                            Button {
                                viewModel.log.sleepQuality = star
                            } label: {
                                Image(systemName: star <= viewModel.log.sleepQuality ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundStyle(star <= viewModel.log.sleepQuality ? .yellow : .secondary)
                            }
                        }
                        Spacer()
                    }
                }

                Toggle(isOn: $viewModel.log.wokeUnrefreshed) {
                    Text("Woke up unrefreshed")
                        .font(.subheadline)
                }
            }
        }
    }
}
