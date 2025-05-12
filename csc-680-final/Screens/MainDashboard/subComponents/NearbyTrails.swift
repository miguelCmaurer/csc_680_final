import SwiftUI
import FirebaseFirestore
import FirebaseAuth


func saveFacility(facilityId: String) {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    let db = Firestore.firestore()
    let userRef = db.collection("users").document(uid)

    userRef.setData([
        "savedFacilities": FieldValue.arrayUnion([facilityId])
    ], merge: true)
}

func getActivityName(_ activity: ActivityType) -> String {
    switch activity {
    case .hiking:
        return "Trails"
    case .camping:
        return "Camping"
    case .swimming:
        return "Swimming"
    case .all:
        return "Activities"
    }
}

struct NearbyTrails: View {
    
    @Binding
    var path: [Route]
    
    @ObservedObject
    var viewModel: DashboardViewModel
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Nearby \(getActivityName(viewModel.currentActivity))")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "map")
                        .foregroundColor(.forestGreen)
                    
                    Toggle("", isOn: $viewModel.isMapVisible)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .forestGreen))
                }
            }
            
            
            if(viewModel.state == .loading){
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
            }else {
                if viewModel.isMapVisible {
                    MapView(viewModel: viewModel)
                } else {
                    if viewModel.facilities.isEmpty {
                        VStack {
                            Text("No Activities found.")
                                .foregroundColor(.secondary)
                                .padding()
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(viewModel.facilities) { facility in
                                TrailCard(facility: facility)
                                    .padding(.vertical, 5)
                                    .onTapGesture {
                                        path.append(.facility(facility.id))
                                    }.swipeActions(edge: .trailing) {
                                        Button {
                                            saveFacility(facilityId:facility.id)
                                        } label: {
                                            Label("Favorite", systemImage: "star")
                                        }
                                        .tint(.yellow)
                                        
                                    }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
        }.task{
            await viewModel.asyncAwaitUpdate(activity: .hiking)
        }
    }
}
