import SwiftUI

struct SymptomsCard: View {
    @ObservedObject var viewModel: DailyLogViewModel

    var body: some View {
        LogCard(title: "Symptoms", icon: "list.clipboard") {
            VStack(alignment: .leading, spacing: 12) {
                // Standard symptoms grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(StandardSymptom.allCases, id: \.rawValue) { symptom in
                        SymptomToggle(
                            name: symptom.rawValue,
                            isSelected: viewModel.selectedSymptomNames.contains(symptom.rawValue)
                        ) {
                            viewModel.toggleSymptom(symptom.rawValue)
                        }
                    }
                }

                // Custom symptom names already added
                let customSymptoms = viewModel.selectedSymptomNames.filter { name in
                    !StandardSymptom.allCases.contains(where: { $0.rawValue == name })
                }
                if !customSymptoms.isEmpty {
                    ForEach(Array(customSymptoms), id: \.self) { name in
                        SymptomToggle(name: name, isSelected: true) {
                            viewModel.toggleSymptom(name)
                        }
                    }
                }

                // Add custom symptom
                HStack {
                    TextField("Add custom symptom", text: $viewModel.customSymptomText)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        viewModel.addCustomSymptom()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.pink)
                    }
                    .disabled(viewModel.customSymptomText.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                // Severity sliders for selected symptoms
                if !viewModel.selectedSymptomNames.isEmpty {
                    Divider()
                    Text("Severity")
                        .font(.subheadline.weight(.medium))

                    ForEach(Array(viewModel.selectedSymptomNames).sorted(), id: \.self) { name in
                        SeverityRow(
                            name: name,
                            severity: viewModel.severityForSymptom(name)
                        ) { newValue in
                            viewModel.updateSymptomSeverity(name: name, severity: newValue)
                        }
                    }
                }
            }
        }
    }
}

private struct SymptomToggle: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 36)
                .padding(.vertical, 4)
                .padding(.horizontal, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.pink.opacity(0.12) : Color(.tertiarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.pink.opacity(0.4) : .clear, lineWidth: 1)
                )
                .foregroundStyle(isSelected ? .pink : .primary)
        }
    }
}

private struct SeverityRow: View {
    let name: String
    let severity: Int
    let onChange: (Int) -> Void

    @State private var sliderValue: Double

    init(name: String, severity: Int, onChange: @escaping (Int) -> Void) {
        self.name = name
        self.severity = severity
        self.onChange = onChange
        self._sliderValue = State(initialValue: Double(severity))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(name)
                    .font(.caption)
                    .lineLimit(1)
                Spacer()
                Text("\(Int(sliderValue))/5")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(severityColor)
            }
            Slider(value: $sliderValue, in: 1...5, step: 1) { _ in
                onChange(Int(sliderValue))
            }
            .tint(severityColor)
        }
    }

    private var severityColor: Color {
        switch Int(sliderValue) {
        case 1...2: return .green
        case 3: return .yellow
        case 4: return .orange
        default: return .red
        }
    }
}
