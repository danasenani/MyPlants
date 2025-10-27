

import SwiftUI


struct LandingView: View {
    
    // These will later control navigation to other pages (like SetReminder or Today)
    @State private var showSetReminder = false
    @State private var showToday = false
    
    var body: some View {
       
        ZStack {
//     
//            Color.black
//                .ignoresSafeArea()
//            
        
            VStack() {
              
                VStack(alignment: .leading, spacing: 18) {
                    Text("My Plants 🌱")
                        .font(.system(size: 34, weight: .bold)) // big bold title
                        .foregroundColor(.white) // white text
                    
                    // small thin white line under the title
                  
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 1)
                }
              
                .padding(.horizontal) // add space from screen edges
                
                
            
                Image("SmilingCacti")
                    .resizable()                // lets the image resize
                    .scaledToFit()              // keeps correct proportions
                    .frame(width: 164, height: 200) // exact size from your design
                    .padding(.top, 50)          // moves it a bit lower (adjust until it matches)
                    .padding(.bottom, 30)
                  
                
             
                VStack(spacing: 20) {
                    Text("Start your plant journey!")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center) // center the title
                    
                    Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                
         
                Spacer(minLength: 0)
                Button {
                    // This will later open the Set Reminder page
                    showSetReminder = true
                } label: {
                    
                    Text("Set Plant Reminder")
                          .font(.headline)
                          .foregroundColor(.white)
                          .frame(width: 280)
                    
                        .padding(.vertical, 14)
                        .background(Color(red: 0.36, green: 0.81, blue: 0.59))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                    
                    
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 120)
                .buttonStyle(.glass)
            
                
                
              
               
            }
        }
        // These are placeholders for next steps — they’ll connect to new pages later
        .navigationDestination(isPresented: $showSetReminder) {
            Text("Set Reminder Page (coming soon)")
                .foregroundColor(.gray)
                .font(.title)
        }
        .navigationDestination(isPresented: $showToday) {
            Text("Today’s Page (coming soon)")
                .foregroundColor(.gray)
                .font(.title)
        }
    }
}


// This shows a preview inside Xcode’s canvas
#Preview {
    NavigationStack {
        LandingView().preferredColorScheme(.dark)
    }
}
