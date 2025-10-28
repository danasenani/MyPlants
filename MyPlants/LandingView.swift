import SwiftUI

struct LandingView: View {

    @State private var showSetReminder = false
    @State private var showToday = false

    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading, spacing: 18) {
                    Text("My Plants 🌱")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 1)
                }
                .padding(.horizontal)

                Image("SmilingCacti")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 164, height: 200)
                    .padding(.top, 50)
                    .padding(.bottom, 30)

                VStack(spacing: 20) {
                    Text("Start your plant journey!")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer(minLength: 0)

                Button {
                    // Present the Set Reminder sheet
                    showSetReminder = true
                } label: {
                    Text("Set Plant Reminder")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 280)
                        .padding(.vertical, 14)
                        .glassEffect(.clear.interactive().tint(Color("Green")))
                        .background(Color(red: 0.36, green: 0.81, blue: 0.59))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 120)
                .buttonStyle(.glass)
            }
        }
        // ⬇️ Present SetReminderSheet as a native swipe-up sheet
        .sheet(isPresented: $showSetReminder) {
            SetReminderSheet()
                .presentationDetents([.medium, .large])     // user can swipe between sizes
                .presentationDragIndicator(.visible)        // show the grabber
                .presentationCornerRadius(32)               // nice rounded top
        }

        // keep this for your future third page if you want
        .navigationDestination(isPresented: $showToday) {
            Text("Today’s Page (coming soon)")
                .foregroundColor(.gray)
                .font(.title)
        }
    }
}

#Preview {
    NavigationStack {
        LandingView().preferredColorScheme(.dark)
    }
}
