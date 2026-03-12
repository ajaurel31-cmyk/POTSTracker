import SwiftUI

struct DailyLogView: View {
    @StateObject private var viewModel = DailyLogViewModel()
    @EnvironmentObject var onboardingManager: OnboardingManager
    @State private var showMenstrualCycle = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        // Date header
                        Text(Date(), style: .date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)

                        HeartRateCard(viewModel: viewModel)
                        BloodPressureCard(viewModel: viewModel)
                        SymptomsCard(viewModel: viewModel)
                        HydrationCard(viewModel: viewModel)
                        ActivityCard(viewModel: viewModel)
                        SleepCard(viewModel: viewModel)
                        TriggersCard(viewModel: viewModel)

                        if showMenstrualCycle {
                            MenstrualCycleCard(viewModel: viewModel)
                        }

                        MedicationsCard(viewModel: viewModel)
                        OverallRatingCard(viewModel: viewModel)
                        NotesCard(viewModel: viewModel)

                        // Save button
                        Button {
                            viewModel.save()
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Save Today's Log")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.pink.gradient)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 16)
                }

                // Success overlay
                if viewModel.showSaveSuccess {
                    VStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Log saved successfully!")
                                .font(.subheadline.weight(.medium))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(radius: 8)
                        .padding(.bottom, 24)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: viewModel.showSaveSuccess)
                }
            }
            .navigationTitle("Log Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Toggle(isOn: $showMenstrualCycle) {
                        Image(systemName: "calendar.circle")
                    }
                    .toggleStyle(.button)
                    .tint(showMenstrualCycle ? .purple : .secondary)
                }
            }
            .alert("Critical Vitals Detected", isPresented: $viewModel.showExportPrompt) {
                Button("Share with Doctor") {
                    // TODO: Export functionality
                }
                Button("Dismiss", role: .cancel) {}
            } message: {
                Text("Your vitals today may indicate orthostatic changes. Consider sharing this data with your healthcare provider.")
            }
            .onAppear {
                // Check if menstrual cycle tracking is relevant based on triggers
                if let profile = DatabaseManager.shared.loadUserProfile() {
                    showMenstrualCycle = profile.selectedTriggers.contains(.menstrualCycle)
                }
            }
        }
    }
}
