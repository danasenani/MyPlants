import SwiftUI

struct SetReminderSheet: View {
    // Close the sheet when tapping X or ✅
    @Environment(\.dismiss) private var dismiss

    // User input (simple state)
    @State private var plantName: String = ""
    @State private var room: String      = "Bedroom"
    @State private var light: String     = "Full sun"
    @State private var days: String      = "Every day"
    @State private var water: String     = "20–50  ml"

    // Choices (for the dropdowns)
    private let rooms  = ["Bedroom", "Living room", "Kitchen", "Balcony","Bathroom"]
    private let lights = ["Full sun", "Partial sun", "Low Light"]
    private let allDays = ["Every day", "Every 2 days", "Weekly"]
    private let waters  = ["10–20  ml", "20–50  ml", "50–80  ml"]

    var body: some View {
        ZStack {
            // Dark themed background (not pure black)
            LinearGradient(
                colors: [Color(red: 0.07, green: 0.07, blue: 0.09),
                         Color(red: 0.12, green: 0.12, blue: 0.14)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            // Card container that matches the rounded sheet look
            VStack(spacing: 24) {

                // --- Header: (X)   Set Reminder    (✅) ---
                HStack {
                    // X in a subtle circle
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(.white.opacity(0.07), in: Circle())
                    }

                    Spacer()

                    Text("Set Reminder")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Spacer()

                    // ✅ inside green circle (GREEN asset)
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(Color("GREEN"), in: Circle())
                    }
                }
                .padding(.horizontal)

                // --- Plant Name field (rounded) ---
                VStack(alignment: .leading, spacing: 8) {
                    Text("Plant Name")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))

                    TextField("Pothos", text: $plantName)
                        .tint(Color("GREEN"))                       // green caret like the design
                        .padding(16)
                        .background(.white.opacity(0.08),
                                    in: RoundedRectangle(cornerRadius: 28))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)

                // --- Room & Light block (two rows, rounded card) ---
                VStack(spacing: 0) {
                    rowWithMenu(
                        title: "Room",
                        systemImage: "paperplane",
                        selection: $room,
                        options: rooms
                    )

                    Divider().background(.white.opacity(0.15))

                    rowWithMenu(
                        title: "Light",
                        systemImage: "sun.max",
                        selection: $light,
                        options: lights
                    )
                }
                .background(.white.opacity(0.07),
                            in: RoundedRectangle(cornerRadius: 28))
                .padding(.horizontal)

                // --- Watering Days & Water block (two rows, rounded card) ---
                VStack(spacing: 0) {
                    rowWithMenu(
                        title: "Watering Days",
                        systemImage: "drop",
                        selection: $days,
                        options: allDays
                    )

                    Divider().background(.white.opacity(0.15))

                    rowWithMenu(
                        title: "Water",
                        systemImage: "drop",
                        selection: $water,
                        options: waters
                    )
                }
                .background(.white.opacity(0.07),
                            in: RoundedRectangle(cornerRadius: 28))
                .padding(.horizontal)

                Spacer(minLength: 0)
            }
            .padding(.top, 8)
        }
        // Show as a sheet (large), hide the default grabber to match your header
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }

    // MARK: - One reusable row that looks like your dropdown row
    private func rowWithMenu(
        title: String,
        systemImage: String,
        selection: Binding<String>,
        options: [String]
    ) -> some View {
        HStack(spacing: 12) {
            // Left: icon + label
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .foregroundStyle(.white.opacity(0.9))
                Text(title)
                    .foregroundStyle(.white)
            }

            Spacer()

            // Right: “value  ⌃⌄” (menu)
            Menu {
                ForEach(options, id: \.self) { value in
                    Button(value) { selection.wrappedValue = value }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(selection.wrappedValue)
                        .foregroundStyle(.white.opacity(0.85))
                    // up/down chevrons to match your mock
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

#Preview {
    NavigationStack {
        SetReminderSheet().preferredColorScheme(.dark)
    }
}
