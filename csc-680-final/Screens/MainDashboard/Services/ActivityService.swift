
//  Created by Miguel Maurer on 5/11/25.
//
import Foundation




struct ActivityService {
    
    
    func fetchActivity(facilityId: String) async -> Facility? {
        let urlString = "https://ridb.recreation.gov/api/v1/facilities/\(facilityId)?full=false"
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("42bed47a-cc67-479a-a678-6572b3b98b36", forHTTPHeaderField: "apikey")

        
        let (data, _) = try! await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        let predictionsResponse = try! decoder.decode(Facility.self, from: data)
        return predictionsResponse
    }
    
    func fetchActivities(activity: ActivityType, currentLocation: CameraLocation) async -> [Facility]  {
        
        let urlString = "https://ridb.recreation.gov/api/v1/facilities?limit=50&offset=0&full=false&latitude=\(currentLocation.lat)&longitude=\(currentLocation.lon)&radius=25&activity=\(activity.rawValue.uppercased())&lastupdated=10-01-2000"
        
        
        guard let url = URL(string: urlString) else {
            return []
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("42bed47a-cc67-479a-a678-6572b3b98b36", forHTTPHeaderField: "apikey")

        
        let (data, _) = try! await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        let predictionsResponse = try! decoder.decode(recData.self, from: data)
        return predictionsResponse.RECDATA
        }
        
}
