import SwiftUI

@MainActor
class AccountViewModel: ObservableObject {
    
    private let service = ActivityService()
    
    @Published
    var state:appState = .loading
    
    @Published
    var facilityStrings: [String] = []
    
    @Published
    var allFacilities: [Facility] = []
    
    func asyncGetSavedIds() async {
        state = .loading
        var results: [Facility] = []
        
        for id in self.facilityStrings {
            if let facility = await service.fetchActivity(facilityId: id) {
                results.append(facility)
            }
        }
        
        self.allFacilities = results
        print(results)
        state = .ready
    }
}
