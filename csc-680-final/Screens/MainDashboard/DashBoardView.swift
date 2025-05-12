import SwiftUI
import FirebaseAuth


struct DashBoardView: View {
    
    @StateObject
    var viewModel = DashboardViewModel()
    
    @Binding
    var path: [Route]
    

    let fullName = Auth.auth().currentUser?.displayName ?? "Explorer"
    
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Text("Hello, \(fullName.components(separatedBy: " ").first ?? "Explorer") 👋")
                    .font(.largeTitle)
                    .padding(.bottom, 25)
                    .bold(true)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        Image(systemName: "location.circle").imageScale(.large)
                            .fontWeight(.light)
                        Text("Showing activities near:")
                            .font(.title2)
                            .bold(true)
                    }
                    
                    Text(viewModel.locationName)
                        .font(.largeTitle)
                        .fontWeight(.light)
                }

                
                NearbyTrails(path: $path, viewModel: viewModel).padding(.top, 5)

            }
            PopularAvtivities(viewModel: viewModel)
            
        }
        .padding(.leading, 15)
        .padding(.trailing,15)
        .background(Color.yellow.opacity(0.02))
        .toolbar {
            Button("Account"){
                path.append(.account)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}








//#Preview {
//    DashBoardView()
//}
