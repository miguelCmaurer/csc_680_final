import SwiftUI


struct AllMessagesView: View {
    var body: some View {
        Text("All Messages")
    }
}



struct ContentView: View {
    
    @State
    var path: [Route] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            RootView(path: $path)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .login: LogInView(path: $path)
                    case .signup: SignUpView(path: $path)
                    case .dashboard: DashBoardView(path: $path)
                    case .account: AccountView(path: $path)
                    case .facility(let id): FacilityView(path: $path, facilityId: id)
                    }
                    
            }
        }
    }
}


#Preview {
    ContentView()
}
