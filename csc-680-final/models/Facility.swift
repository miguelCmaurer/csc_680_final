//
//  Facility.swift
//  csc-680-final
//
//  Created by Miguel Maurer on 5/2/25.
//

import Foundation


struct Media: Codable, Identifiable {
    let EntityMediaID: String
    var id: String { EntityMediaID }
    let Title: String
    let URL: String
}


struct Facility: Codable, Identifiable {
    let FacilityID: String
    var id: String { FacilityID }
    let FacilityName: String
    let FacilityDescription: String
    let FacilityLatitude: Double
    let FacilityLongitude: Double
    let FacilityEmail: String
    let FacilityPhone: String
    let Keywords: String
    let LastUpdatedDate: String
    let Reservable: Bool
    let MEDIA: [Media]
}

struct recData: Codable {
    let RECDATA: [Facility]
}


