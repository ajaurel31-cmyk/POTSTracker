import SwiftUI

struct PermissionsView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    var onComplete: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "lock.shield")
                .font(.system(size: 60))
                .foregroundStyle(.pink.gradient)

            VStack(spacing: 8) {
                Text("Permissions")
                    .font(.title2.bold())
                Text("These help the app work better for you, but both are optional.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            VStack(spacing: 16) {
                PermissionCard(
                    icon: "heart.fill",
                    title: "Apple Health",
                    description: "Automatically pull in heart rate, blood pressure, steps, and sleep data so you don't have to log them manually.",
                    buttonTitle: onboardingManager.healthKitEnabled ? "Enabled" : "Enable Health Access",
                    isEnabled: onboardingManager.healthKitEnabled
                ) {
                    Task {
                        await onboardingManager.requestHealthKitPermission()
                    }
                }

                PermissionCard(
                    icon: "bell.fill",
                    title: "Notifications",
                    description: "Get gentle daily reminders to log your symptoms and stay on top of your tracking.",
                    buttonTitle: onboardingManager.notificationsEnabled ? "Enabled" : "Enable Notifications",
                    isEnabled: onboardingManager.notificationsEnabled
                ) {
                    Task {
                        await onboardingManager.requestNotificationPermission()
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            VStack(spacing: 12) {
                Button(action: {
                    onboardingManager.completeOnboarding()
                    onComplete()
                }) {
                    Text("Finish Setup")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.pink.gradient)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button(action: {
                    onboardingManager.completeOnboarding()
                    onComplete()
                }) {
                    Text("Skip for Now")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}

private struct PermissionCard: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(.pink)
                    .font(.title3)
                Text(title)
                    .font(.headline)
                if isEnabled {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }

            Text(description)
                .font(.footnote)
                .foregroundStyle(.secondary)

            if !isEnabled {
                Button(action: action) {
                    Text(buttonTitle)
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.pink.opacity(0.1))
                        .foregroundStyle(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
