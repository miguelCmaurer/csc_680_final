import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}


func getLocationName(from coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        if let placemark = placemarks?.first {
            let name = placemark.locality ?? placemark.name ?? "Unknown"
            completion(name)
        } else {
            completion(nil)
        }
    }
}

struct MapView: View {
    @ObservedObject
    var viewModel: DashboardViewModel
    
    @State
    private var position: MapCameraPosition = .automatic
    
    @State
    private var tappedCoordinate: CLLocationCoordinate2D?
    
    @State
    var screenCenter: CLLocationCoordinate2D?
    
    
    func getCameraLocation() {
        
        guard let region = position.region else {
            return
        }
        
        let location = CameraLocation(lat:region.center.latitude, lon:region.center.longitude)
        Task {
            await viewModel.asyncAwaitUpdate(activity: viewModel.currentActivity, cameraLocation: location )
        }
    }
    
    
    var body: some View {
        let locations: [Location] = viewModel.facilities.map{
            Location(
                name: $0.FacilityName,
                coordinate: CLLocationCoordinate2D(latitude: $0.FacilityLatitude, longitude: $0.FacilityLongitude)
            )
        }
        
        
        VStack {
            ZStack(alignment: .bottom) {
                Map(position: $position) {
                    ForEach(locations) { location in
                        Marker(location.name, coordinate: location.coordinate)
                    }
                }
                .onMapCameraChange { context in
                    position = .region(context.region)
                    screenCenter = context.region.center
                }
                .onAppear {
                    let center = CLLocationCoordinate2D(
                        latitude: viewModel.currentLocation.lat,
                        longitude: viewModel.currentLocation.lon
                    )
                    position = .camera(
                        MapCamera(centerCoordinate: center, distance: 300_000, heading: 0)
                    )
                }
                .ignoresSafeArea(edges: .horizontal)
                
                Button(action: {
                    getCameraLocation()
                    guard let centerGood = screenCenter else { return }
                    getLocationName(from: centerGood) { name in
                        if let name = name {
                            viewModel.setLocationName(name: name)
                        }
                    }
                }) {
                    Text("Search This Area")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.green)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .padding()
                }
            }
        }
    }
}
