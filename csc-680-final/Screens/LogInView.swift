import SwiftUI
import FirebaseAuth


struct LogInView: View {
    
    @Binding
    var path: [Route]
    
    @State
    private var state: appState = .ready
    
    @State
    private var email: String = ""
    
    @State
    private var password: String = ""
    
    @State
    private var errorMessage: String?

    func signIn() {
        state = .loading
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = nil
                path = [.dashboard]
            }
            state = .ready
        }
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image("mountain_range")
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.main.bounds.height * 0.4)
                .clipped()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Welcome \nBack")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                    
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 4)
                    }
                    
                    BigButton(
                        content: state == .loading ? "Loading..." :"Log In",
                        action: signIn
                        )
                    
                    Text("Don't Have an Account? Sign Up")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                    
                    BigButton(
                        content: "Sign Up",
                        action: {path = [.signup]},
                        type: "outline")
                }
                .padding()
            }
            .frame(height: UIScreen.main.bounds.height * 0.6)
            .background(Color.gray.opacity(0.2))
        }
        .edgesIgnoringSafeArea(.top)
    }
}

