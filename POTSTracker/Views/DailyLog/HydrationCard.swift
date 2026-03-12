import SwiftUI

struct HydrationCard: View {
    @ObservedObject var viewModel: DailyLogViewModel

    var body: some View {
        LogCard(title: "Hydration & Salt Intake", icon: "drop.fill") {
            VStack(spacing: 14) {
                // Water intake
                HStack {
                    Text("Water intake")
                        .font(.subheadline)
                    Spacer()
                    TextField("0", text: $viewModel.waterIntakeText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 60)
                    Picker("", selection: $viewModel.log.waterUnit) {
                        ForEach(VolumeUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 90)
                }

                // Electrolyte drinks
                Toggle(isOn: $viewModel.log.electrolyteDrinks) {
                    Text("Electrolyte drinks")
                        .font(.subheadline)
                }

                if viewModel.log.electrolyteDrinks {
                    NumericField(label: "Amount", text: $viewModel.electrolyteDrinkOzText, unit: "oz")
                }

                Divider()

                // Salt intake
                HStack {
                    Text("Salt intake")
                        .font(.subheadline)
                    Spacer()
                    TextField("0", text: $viewModel.saltIntakeText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 60)
                    Picker("", selection: $viewModel.log.saltUnit) {
                        ForEach(SaltUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 100)
                }

                // Auto-calculated sodium
                if viewModel.log.saltUnit == .grams, let value = Double(viewModel.saltIntakeText), value > 0 {
                    HStack {
                        Text("Sodium estimate")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(Int(value * 388)) mg")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
}
