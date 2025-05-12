import SwiftUI

enum appState {
    case ready
    case loading
}

struct CameraLocation {
    var lat: Double
    var lon: Double
}

@MainActor
class DashboardViewModel: ObservableObject {
    
    private let service = ActivityService()
    
    private(set) var currentActivity: ActivityType = .camping
    
    @Published
    var isMapVisible: Bool = false
    
    @Published
    var locationName = "Mount Dana"
    
    @Published
    var facilities: [Facility] = []
    
    @Published
    var state: appState = .loading
    
    @Published
    var currentLocation = CameraLocation(lat: 37.773972, lon: -119.12141392084965)
    
    func updateCurrentLocation(loc: CameraLocation){
        currentLocation = loc
    }
    
    func setLocationName(name:String){
        locationName = name
    }
    
    func asyncAwaitUpdate(activity: ActivityType, cameraLocation: CameraLocation? = nil) async {
        let location = cameraLocation ?? self.currentLocation
        
        if activity == currentActivity &&
            !facilities.isEmpty &&
            self.currentLocation.lat == location.lat
        {
            return
        }
        self.updateCurrentLocation(loc:location)
        
        if !self.isMapVisible {
            state = .loading
        }
        
        currentActivity = activity
        facilities = await service
            .fetchActivities(activity: activity, currentLocation: location)
            .sorted(by: { !$0.MEDIA.isEmpty && $1.MEDIA.isEmpty })
        state = .ready
    }
    
}
