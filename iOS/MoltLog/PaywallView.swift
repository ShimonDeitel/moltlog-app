import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var purchaseManager: PurchaseManager

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Theme.accent)
                    Text("MoltLog Pro")
                        .font(Theme.titleFont)
                        .foregroundStyle(Theme.ink)
                    Text("Growth measurement tracking and multi-animal profiles")
                        .font(Theme.bodyFont)
                        .foregroundStyle(Theme.muted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    if let product = purchaseManager.product {
                        Text(product.displayPrice)
                            .font(Theme.titleFont)
                            .foregroundStyle(Theme.accent)
                    }
                    Button {
                        Task {
                            await purchaseManager.purchase()
                            if purchaseManager.isPro { dismiss() }
                        }
                    } label: {
                        Text("Unlock Pro")
                            .font(Theme.bodyFont.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .accessibilityIdentifier("unlockProButton")
                    .padding(.horizontal)

                    Button("Restore Purchases") {
                        Task { await purchaseManager.restore() }
                    }
                    .accessibilityIdentifier("paywallRestoreButton")
                    .foregroundStyle(Theme.muted)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .accessibilityIdentifier("paywallCloseButton")
                }
            }
        }
        .tint(Theme.accent)
    }
}
