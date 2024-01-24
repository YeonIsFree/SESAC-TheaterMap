
import Foundation
import CoreLocation

struct Theater {
    let type: String
    let location: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

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






