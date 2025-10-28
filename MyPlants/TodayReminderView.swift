//
//  TodayReminderView.swift
//  MyPlants
//
//  Third page: shows today's reminders with a progress line.
//  • Data is in-memory (@State) — it resets when the app restarts.
//  • Check a plant to mark it done; progress increases.
//  • When all are done, a simple "All Reminders Completed" screen appears.
//  • Floating + button can call an optional closure so the parent can open your SetReminder sheet.
//

import SwiftUI

// MARK: - Lightweight in-memory model (no database)
struct TempReminder: Identifiable, Equatable {
    let id = UUID()
    var plantName: String
    var room: String
    var light: String
    var water: String
    var isDone: Bool = false
}

struct TodayReminderView: View {

    // In-memory list that vanishes when the app closes (exactly what you wanted)
    @State private var reminders: [TempReminder]

    // Optional callback for the + button (parent can present your SetReminder sheet)
    var onAddTapped: (() -> Void)?

    // Custom init lets you pass starting items (e.g., from SetReminder),
    // and still keep @State inside this file.
    init(initial: [TempReminder] = [], onAddTapped: (() -> Void)? = nil) {
        _reminders = State(initialValue: initial)
        self.onAddTapped = onAddTapped
    }

    // Progress (0…1). If list is empty, return 0.
    private var progress: Double {
        guard !reminders.isEmpty else { return 0 }
        let done = reminders.filter { $0.isDone }.count
        return Double(done) / Double(reminders.count)
    }

    // Header text like your mockups
    private var headerText: String {
        if reminders.isEmpty { return "Add your first plant 🌱" }
        let left = reminders.filter { !$0.isDone }.count
        return left == 0 ? "All plants feel loved today ✨"
                         : "\(left) of your plants feel loved today ✨"
    }

    var body: some View {
        ZStack {
            // dark themed background (not pure black)
            LinearGradient(
                colors: [Color(red: 0.07, green: 0.07, blue: 0.09),
                         Color(red: 0.12, green: 0.12, blue: 0.14)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            // Main column
            VStack(spacing: 0) {

                // Title
                HStack {
                    Text("My Plants 🌱")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)

                // Thin divider
                Rectangle()
                    .fill(.white.opacity(0.15))
                    .frame(height: 1)
                    .padding(.horizontal)

                // Small note + progress line
                VStack(alignment: .leading, spacing: 8) {
                    Text(headerText)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))

                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.15))
                            .frame(height: 6)

                        // Green progress fill (width = progress * max)
                        Capsule()
                            .fill(Color("GREEN"))
                            .frame(
                                width: max(4, CGFloat(progress) * UIScreen.main.bounds.width * 0.65),
                                height: 6
                            )
                            .animation(.easeInOut(duration: 0.25), value: progress)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // List of plants
                List {
                    ForEach(reminders) { item in
                        TodayRow(
                            item: item,
                            onToggle: { toggle(item) }
                        )
                        .listRowBackground(Color.clear) // keep dark bg
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }

            // Floating + button (parent can hook it to open SetReminder)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        onAddTapped?()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .padding(18)
                            .background(Color("GREEN"), in: Circle())
                            .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 24)
                    .accessibilityLabel("Add reminder")
                }
            }
        }
        // When all items are marked done → show the celebration screen
        .fullScreenCover(isPresented: .constant(!reminders.isEmpty && progress == 1)) {
            AllDoneView()
        }
        // Provide a couple of sample items on first launch if empty
        .task {
            if reminders.isEmpty {
                reminders = [
                    TempReminder(plantName: "Monstera", room: "Kitchen",     light: "Full Sun",    water: "20–50 ml"),
                    TempReminder(plantName: "Pothos",   room: "Bedroom",     light: "Low Light",   water: "20–50 ml"),
                    TempReminder(plantName: "Orchid",   room: "Living Room",  light: "Partial Sun", water: "20–50 ml"),
                    TempReminder(plantName: "Spider",   room: "Kitchen",     light: "Full Sun",    water: "20–50 ml")
                ]
            }
        }
    }

    // MARK: - Actions (simple and in-memory)
    private func toggle(_ item: TempReminder) {
        if let i = reminders.firstIndex(of: item) {
            reminders[i].isDone.toggle()
        }
    }

    private func delete(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}

// MARK: - One row (checkbox + plant info + chips)
private struct TodayRow: View {
    let item: TempReminder
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Room label
            Text("in \(item.room)")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))

            HStack(spacing: 12) {
                // Left: checkbox
                Button(action: onToggle) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundStyle(.white.opacity(0.6))
                            .frame(width: 24, height: 24)

                        if item.isDone {
                            Circle()
                                .fill(Color("GREEN"))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(.white)
                                )
                        }
                    }
                }
                .buttonStyle(.plain)

                // Plant name
                Text(item.plantName)
                    .font(.headline)
                    .foregroundStyle(.white)

                Spacer()
            }

            // Chips: light + water
            HStack(spacing: 8) {
                Chip(text: item.light, systemName: "sun.max")
                Chip(text: item.water, systemName: "drop")
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.03))
        )
    }
}

// Small pill badge
private struct Chip: View {
    let text: String
    let systemName: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemName).font(.caption)
            Text(text).font(.caption).bold()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.08)))
    }
}

// MARK: - Celebration screen (also in the same file)
private struct AllDoneView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Text("My Plants 🌱")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.horizontal)

                Rectangle()
                    .fill(.white.opacity(0.15))
                    .frame(height: 1)
                    .padding(.horizontal)

                Spacer()

                Image("SmilingCacti")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)

                Text("All Done! 🎉")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                Text("All Reminders Completed")
                    .foregroundStyle(.white.opacity(0.7))

                Spacer()
            }
        }
    }
}

#Preview {
    TodayReminderView()              // starts with default sample data
        .preferredColorScheme(.dark) // matches your dark design
}
