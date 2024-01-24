//
//  Campus.swift
//  SESSAC-TheaterMap
//
//  Created by Seryun Chun on 2024/01/24.
//

import Foundation
import CoreLocation

struct CampusCoor {
    static var location: String = "새싹 도봉캠퍼스"
    static var latitude: CLLocationDegrees = 37.6543906
    static var longitude: CLLocationDegrees = 127.0498832
    static var centerCoor: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
