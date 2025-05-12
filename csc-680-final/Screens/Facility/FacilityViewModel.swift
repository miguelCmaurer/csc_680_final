import SwiftUI

@MainActor
class FacilityViewModel: ObservableObject {
    
    private let service = ActivityService()
    
    
    @Published
    var facility: Facility? = nil
    
    @Published
    var state: appState = .loading
    
    
    func asyncAwaitUpdate(facilityId: String) async {
        state = .loading
        facility = await service
            .fetchActivity(facilityId: facilityId)
        state = .ready
    }
    
}

