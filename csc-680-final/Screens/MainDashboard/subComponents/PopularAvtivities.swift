import SwiftUI


enum ActivityType: String, CaseIterable {
    case hiking = "Hiking"
    case camping = "Camping"
    case swimming = "Swimming"
    case all = ""
}


struct PopularAvtivities: View {
    @ObservedObject
    var viewModel: DashboardViewModel
    
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Popular Activities")
                .fontWeight(.semibold)
                .font(.title)
            HStack(spacing: 10) {
                ActivityButton(label: "Hiking",
                               iconName: "figure.walk",
                               action: {Task{await viewModel.asyncAwaitUpdate(activity: .hiking)}},
                               color: Color("forest_green"))
                
                ActivityButton(label: "Camping",
                               iconName: "tent",
                               action: {Task{await viewModel.asyncAwaitUpdate(activity: .camping)}},
                               color: Color("light_brown"))
                
                
            }
            HStack(spacing: 10) {
                ActivityButton(label: "Swimming",
                               iconName: "drop.fill",
                               action: {Task{await viewModel.asyncAwaitUpdate(activity: .swimming)}},
                               color: Color("olive"))
                
                ActivityButton(label: "All",
                               iconName: "mountain.2",
                               action: {Task{await viewModel.asyncAwaitUpdate(activity: .all)}},
                               color: Color("earth_brown"))
               
            }
            
        }.frame(maxWidth: .infinity, alignment: .topLeading)
        
    }
}
