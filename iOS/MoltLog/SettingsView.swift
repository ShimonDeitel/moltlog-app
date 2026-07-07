import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var purchaseManager: PurchaseManager

    @AppStorage("settings.reminders") private var remindersEnabled = true
    @AppStorage("settings.hapticFeedback") private var hapticsEnabled = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Reminders", isOn: $remindersEnabled)
                        .accessibilityIdentifier("remindersToggle")
                    Toggle("Haptic Feedback", isOn: $hapticsEnabled)
                        .accessibilityIdentifier("hapticsToggle")
                }
                Section("Pro") {
                    if purchaseManager.isPro {
                        Label("Pro Unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Upgrade to Pro") {
                            // Handled by PaywallView presented from ContentView
                        }
                        .accessibilityIdentifier("upgradeButton")
                    }
                    Button("Restore Purchases") {
                        Task { await purchaseManager.restore() }
                    }
                    .accessibilityIdentifier("restoreButton")
                }
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/terms.html")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
        }
        .tint(Theme.accent)
    }
}
