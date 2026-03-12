import SwiftUI

@main
struct POTSTrackerApp: App {
    @StateObject private var onboardingManager = OnboardingManager()

    var body: some Scene {
        WindowGroup {
            if onboardingManager.hasCompletedOnboarding {
                ContentView()
                    .environmentObject(onboardingManager)
            } else {
                OnboardingFlowView()
                    .environmentObject(onboardingManager)
            }
        }
    }
}
