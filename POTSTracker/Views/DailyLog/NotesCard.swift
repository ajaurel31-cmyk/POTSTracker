import SwiftUI

struct NotesCard: View {
    @ObservedObject var viewModel: DailyLogViewModel

    var body: some View {
        LogCard(title: "Notes", icon: "note.text") {
            VStack(alignment: .leading, spacing: 8) {
                TextField("How are you feeling? Any observations...", text: $viewModel.log.notes, axis: .vertical)
                    .lineLimit(4...8)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: viewModel.log.notes) { _, newValue in
                        if newValue.count > 500 {
                            viewModel.log.notes = String(newValue.prefix(500))
                        }
                    }

                Text("\(viewModel.log.notes.count)/500")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
