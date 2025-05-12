import SwiftUI
import FirebaseAuth


struct RootView: View {
    @Binding
    var path: [Route]
    
    
    func testlogin() {
        if let user = Auth.auth().currentUser {
            print("User is signed in with UID:", user.uid)
            path.append(.dashboard)
        } else {
            print("Not signed in")
            
        }
        
    }
    
    var body: some View {
        Group {
            ZStack {
                Image("forest_background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    Text("Trailmark")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Discover and save your favorite trails!")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                    
                    BigButton(content: "Log in", action: { path.append(.login) })
                    BigButton(content: "Sign up", action: { path.append(.signup) })
                }
                .padding(15)
                .background(Color("forest_green").opacity(0.3))
                .background(.ultraThinMaterial)
                .cornerRadius(25)
                .shadow(radius: 10)
                .padding(.horizontal, 24)
            }
        }
        .onAppear {
            testlogin()
        }
    }
    
}
