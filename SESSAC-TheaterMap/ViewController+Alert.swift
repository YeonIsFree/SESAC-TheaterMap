//
//  ViewController+Alert.swift
//  SESSAC-TheaterMap
//
//  Created by Seryun Chun on 2024/01/24.
//

import UIKit

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

extension ViewController {
    func alert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let megaBoxAction = UIAlertAction(title: Theaters.megabox.type, style: .default, handler: alertAction)
        
        let lotteAction = UIAlertAction(title: Theaters.lotteCinema.type, style: .default, handler: alertAction)
        
        let cgvAction = UIAlertAction(title: Theaters.cgv.type, style: .default, handler: alertAction)
        
        let allAction = UIAlertAction(title: Theaters.all.type, style: .default, handler: alertAction)
        
        alert.addAction(megaBoxAction)
        alert.addAction(lotteAction)
        alert.addAction(cgvAction)
        alert.addAction(allAction)
        
        present(alert, animated: true)
    }
    
    func alertAction(action: UIAlertAction) -> Void {
        let targetTheaterType = action.title ?? ""
        if targetTheaterType == Theaters.all.type {
            showAllAnnotations()
        } else {
            displayOne(targetTheaterType)
        }
    }
}
