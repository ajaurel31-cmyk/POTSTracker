import SwiftUI

struct ActivityCard: View {
    @ObservedObject var viewModel: DailyLogViewModel

    var body: some View {
        LogCard(title: "Activity & Posture", icon: "figure.walk") {
            VStack(alignment: .leading, spacing: 14) {
                // Activity level
                Text("Activity level today")
                    .font(.subheadline.weight(.medium))

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(ActivityLevel.allCases) { level in
                        Button {
                            viewModel.log.activityLevel = level
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: level.icon)
                                    .font(.title3)
                                Text(level.rawValue)
                                    .font(.caption2)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(viewModel.log.activityLevel == level ?
                                          Color.pink.opacity(0.12) : Color(.tertiarySystemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(viewModel.log.activityLevel == level ?
                                            Color.pink.opacity(0.4) : .clear, lineWidth: 1)
                            )
                            .foregroundStyle(viewModel.log.activityLevel == level ? .pink : .primary)
                        }
                    }
                }

                Divider()

                // Time upright
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Time spent upright")
                            .font(.subheadline)
                        Spacer()
                        Text("\(String(format: "%.0f", viewModel.log.timeUprightHours))h")
                            .font(.subheadline.weight(.medium))
                    }
                    Slider(value: $viewModel.log.timeUprightHours, in: 0...16, step: 1)
                        .tint(.pink)
                }

                Divider()

                // Exercise
                Toggle(isOn: $viewModel.log.exercisePerformed) {
                    Text("Exercise performed")
                        .font(.subheadline)
                }

                if viewModel.log.exercisePerformed {
                    VStack(spacing: 10) {
                        // Type
                        HStack {
                            Text("Type")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Picker("", selection: Binding(
                                get: { viewModel.log.exerciseType ?? .walking },
                                set: { viewModel.log.exerciseType = $0 }
                            )) {
                                ForEach(ExerciseType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        // Duration
                        NumericField(label: "Duration", text: $viewModel.exerciseDurationText, unit: "min")

                        // Intensity
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Intensity")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(viewModel.log.exerciseIntensity ?? 5)/10")
                                    .font(.subheadline.weight(.medium))
                            }
                            Slider(
                                value: Binding(
                                    get: { Double(viewModel.log.exerciseIntensity ?? 5) },
                                    set: { viewModel.log.exerciseIntensity = Int($0) }
                                ),
                                in: 1...10,
                                step: 1
                            )
                            .tint(.pink)
                        }
                    }
                }
            }
        }
    }
}
