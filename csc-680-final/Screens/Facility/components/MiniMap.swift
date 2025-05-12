import SwiftUI
import MapKit

struct MiniMap : View {
    let facility: Facility
    var body: some View {
        Map(
            initialPosition: .camera(
                MapCamera(
                    centerCoordinate: CLLocationCoordinate2D(latitude: facility.FacilityLatitude, longitude: facility.FacilityLongitude),
                    distance: 25_000
                )
            )
        ) {
            Marker(facility.FacilityName, coordinate: CLLocationCoordinate2D(
                latitude: facility.FacilityLatitude,
                longitude: facility.FacilityLongitude
            ))
        }
        .frame(height: 160)
        .cornerRadius(10)
    }
}
