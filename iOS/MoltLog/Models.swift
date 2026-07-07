import Foundation

struct MoltLogEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var date: Date
    var animal: String
    var notes: String
    var notes: String = ""
}
