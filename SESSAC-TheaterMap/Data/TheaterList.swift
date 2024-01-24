//
//  TheaterList.swift
//  SESSAC-TheaterMap
//
//  Created by Seryun Chun on 2024/01/24.
//

import Foundation
import CoreLocation

enum Theaters {
    case megabox
    case lotteCinema
    case cgv
    case all
    
    var type: String {
        switch self {
        case .megabox:
            return "메가박스"
        case .lotteCinema:
            return "롯데시네마"
        case .cgv:
            return "CGV"
        case .all:
            return "전체보기"
        }
    }
}

struct Theater {
    let type: String
    let location: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

struct TheaterList {
    static var mapAnnotations: [Theater] = [
        Theater(type: "메가박스", location: "메가박스 창동", latitude: 37.6545747, longitude: 127.0387545),
        Theater(type: "메가박스", location: "메가박스 상봉", latitude: 37.5932324, longitude: 127.0746815),
        Theater(type: "메가박스", location: "메가박스 동대문", latitude: 37.5663954, longitude: 127.0073743),
        Theater(type: "CGV", location: "CGV 하계", latitude: 37.6389868, longitude: 127.0647402),
        Theater(type: "CGV", location: "CGV 중계", latitude: 37.6396308, longitude:  127.0687009),
        Theater(type: "CGV", location: "CGV 미아", latitude: 37.6120557, longitude:  127.0307389),
        Theater(type: "롯데시네마", location: "롯데시네마 노원", latitude: 37.6548365, longitude: 127.061187),
        Theater(type: "롯데시네마", location: "롯데시네마 수유", latitude: 37.6356772, longitude: 127.0238386),
        Theater(type: "롯데시네마", location: "롯데시네마 중랑", latitude: 37.6150983, longitude: 127.0759492),
        Theater(type: "롯데시네마", location: "롯데시네마 청량리", latitude: 37.5810103, longitude: 127.0480831)
    ]
}
