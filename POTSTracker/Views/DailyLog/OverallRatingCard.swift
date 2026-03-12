import SwiftUI

struct OverallRatingCard: View {
    @ObservedObject var viewModel: DailyLogViewModel

    private var emoji: String {
        switch viewModel.log.overallRating {
        case 1: return "😫"
        case 2: return "😣"
        case 3: return "😞"
        case 4: return "😕"
        case 5: return "😐"
        case 6: return "🙂"
        case 7: return "😊"
        case 8: return "😄"
        case 9: return "🤩"
        case 10: return "🌟"
        default: return "😐"
        }
    }

    var body: some View {
        LogCard(title: "Overall Day Rating", icon: "face.smiling") {
            VStack(spacing: 12) {
                Text(emoji)
                    .font(.system(size: 48))

                HStack {
                    Text("1")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Slider(
                        value: Binding(
                            get: { Double(viewModel.log.overallRating) },
                            set: { viewModel.log.overallRating = Int($0) }
                        ),
                        in: 1...10,
                        step: 1
                    )
                    .tint(.pink)
                    Text("10")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text("\(viewModel.log.overallRating)/10")
                    .font(.title3.weight(.semibold))
            }
        }
    }
}
