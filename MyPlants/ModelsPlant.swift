import Foundation

struct Plant: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var room: String
    var light: String
    var wateringDays: String
    var waterAmount: String
    var dueToday: Bool = true      // shows up in Today list
    var isDone: Bool = false       // toggled by the check button
    var timeNote: String = "20–30 min"
}
