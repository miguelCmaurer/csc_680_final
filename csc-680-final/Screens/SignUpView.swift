import SwiftUI
import FirebaseAuth


struct SignUpView: View {
    
    
    @Binding
    var path: [Route]
    
    @State
    private var errorMessage: String?

    @State
    private var state: appState = .ready
    
    @State
    private var email: String = ""
    
    @State
    private var password: String = ""
    
    @State
    private var name: String = ""
    
    func signUp() {
        state = .loading
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = result?.user {
                errorMessage = nil
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Failed to set display name:", error)
                    }
                    path = [.dashboard]
                }
            }
            state = .ready
        }
    }

    
    var body: some View {
        VStack(spacing: 0) {
            Image("yosemitte")
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.main.bounds.height * 0.4)
                .clipped()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Get \nStarted")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                    
                    TextField("Name", text: $name)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
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
                    
                    BigButton(content: state == .loading ? "Loading..." :"Sign Up", action: signUp)
                    
                    Text("Already Have an Account? Log In")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                    
                    BigButton(content: "Log In", action: {
                        path = [.login]
                    }, type: "outline")
                }
                .padding()
            }
            .frame(height: UIScreen.main.bounds.height * 0.6)
            .background(Color.gray.opacity(0.2))
        }
        .edgesIgnoringSafeArea(.top)
    }
}


