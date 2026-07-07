import SwiftUI

enum Theme {
    static let accent = Color(red: 0.541, green: 0.427, blue: 0.231)
    static let background = Color(red: 0.090, green: 0.075, blue: 0.063)
    static let card = background.opacity(0.6)
    static let ink = Color(red: 0.92, green: 0.92, blue: 0.92)
    static let muted = Color(red: 0.6, green: 0.6, blue: 0.62)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}
