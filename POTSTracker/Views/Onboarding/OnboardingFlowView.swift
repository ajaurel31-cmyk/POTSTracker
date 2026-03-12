import SwiftUI

struct OnboardingFlowView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager

    var body: some View {
        TabView(selection: $onboardingManager.currentPage) {
            WelcomeView {
                withAnimation {
                    onboardingManager.currentPage = 1
                }
            }
            .tag(0)

            PersonalizationView {
                withAnimation {
                    onboardingManager.currentPage = 2
                }
            }
            .tag(1)

            PermissionsView {
                // Onboarding complete — handled by OnboardingManager
            }
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .ignoresSafeArea(.keyboard)
    }
}
