import SwiftUI

final class PlantStore: ObservableObject {
    @Published var plants: [Plant] = [
        // Sample seed so Page 3 isn’t empty on first run
        Plant(name: "Monstera", room: "Kitchen", light: "Full sun", wateringDays: "Every day", waterAmount: "20–30 ml"),
        Plant(name: "Pothos", room: "Bedroom", light: "Full sun", wateringDays: "Every day", waterAmount: "20–30 ml"),
        Plant(name: "Orchid", room: "Living Room", light: "Full sun", wateringDays: "Every day", waterAmount: "20–30 ml"),
        Plant(name: "Spider", room: "Kitchen", light: "Full sun", wateringDays: "Every day", waterAmount: "20–30 ml")
    ]

    var dueToday: [Plant] {
        plants.filter { $0.dueToday }
    }

    var completedCount: Int {
        dueToday.filter { $0.isDone }.count
    }

    var progress: Double {
        let total = max(1, dueToday.count)
        return Double(completedCount) / Double(total)
    }

    func add(_ plant: Plant) {
        plants.append(plant)
    }

    func toggleDone(_ plant: Plant) {
        guard let idx = plants.firstIndex(of: plant) else { return }
        plants[idx].isDone.toggle()
    }

    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
    }

    func update(_ plant: Plant, with updated: Plant) {
        guard let idx = plants.firstIndex(of: plant) else { return }
        plants[idx] = updated
    }
}

// Accent color fallback (in case Assets/“GREEN” not added yet)
enum AppColors {
    static let green = Color("GREEN", bundle: .main) ?? Color.green
}
