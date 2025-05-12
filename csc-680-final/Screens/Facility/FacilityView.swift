import SwiftUI
import SDWebImageSwiftUI

struct FacilityView: View {
    @StateObject private var viewModel = FacilityViewModel()
    
    @Binding var path: [Route]
    let facilityId: String
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading facility...")
                    .progressViewStyle(CircularProgressViewStyle())
                
            case .ready:
                if let facility = viewModel.facility {
                    FacilityDetailView(facility: facility)
                } else {
                    Text("Facility not found.")
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.asyncAwaitUpdate(facilityId: facilityId)
            }
        }
    }
}

struct FacilityDetailView: View {
    let facility: Facility
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        if !facility.MEDIA.isEmpty {
                            ForEach(facility.MEDIA) { media in
                                WebImage(url: URL(string: media.URL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 300, height: 210)
                                .clipped()
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                
                Text(stripHTMLTags(from: facility.FacilityDescription))
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 8) {
                    MiniMap(facility: facility)
                    if !facility.FacilityPhone.isEmpty {
                        Label(facility.FacilityPhone, systemImage: "phone")
                    }
                    if !facility.FacilityEmail.isEmpty {
                        Label(facility.FacilityEmail, systemImage: "envelope")
                    }
                    if !facility.Keywords.isEmpty {
                        Label("Tags: \(facility.Keywords)", systemImage: "tag")
                    }
                    Label("Reservable: \(facility.Reservable ? "Yes" : "No")", systemImage: "calendar")
                    Label("Last Updated: \(facility.LastUpdatedDate)", systemImage: "clock")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
        }
        .navigationTitle(facility.FacilityName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
