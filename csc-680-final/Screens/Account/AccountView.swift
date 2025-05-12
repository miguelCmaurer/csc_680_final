import SwiftUI
import FirebaseAuth
import FirebaseFirestore

func deleteFacility(facilityId: String) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    let db = Firestore.firestore()
    
    db.collection("users")
      .document(uid)
      .updateData([
          "savedFacilities": FieldValue.arrayRemove([facilityId])
      ])
}

func loadSavedFacilities(completion: @escaping ([String]) -> Void) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(uid)
    
    userRef.getDocument { snapshot, error in
        if let data = snapshot?.data(),
           let saved = data["savedFacilities"] as? [String] {
            completion(saved)
        } else {
            completion([])
        }
    }
}


public struct AccountView: View {
    
    @Binding var path: [Route]
    @StateObject var viewModel = AccountViewModel()
    
    public var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome,")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(Auth.auth().currentUser?.displayName ?? "User")
                    .font(.title)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Saved Facilities")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                if viewModel.allFacilities.isEmpty {
                    if viewModel.state == .loading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text("You haven't saved any facilities yet.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                } else {
                    List {
                        ForEach(viewModel.allFacilities, id: \.id) { facility in
                            TrailCard(facility: facility)
                                .onTapGesture {
                                    path.append(Route.facility(facility.id))
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        deleteFacility(facilityId: facility.id)
                                        viewModel.allFacilities.removeAll { $0.id == facility.id }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    do {
                        try Auth.auth().signOut()
                        path = []
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            loadSavedFacilities {
                viewModel.facilityStrings = $0
                Task {
                    await viewModel.asyncGetSavedIds()
                }
            }
        }
    }
}
