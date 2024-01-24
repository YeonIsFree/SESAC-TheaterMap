//
//  ViewController+Alert.swift
//  SESSAC-TheaterMap
//
//  Created by Seryun Chun on 2024/01/24.
//

import UIKit

extension ViewController {
    
    func locationSettingAlert() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "기기의 설정 > 개인정보 보호에서 위치 서비스를 켜주세요", preferredStyle: .alert)
        let goAction = UIAlertAction(title: "이동", style: .default) { _ in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            } else {
                print("설정으로 가주세요")
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func fillterButtonAlert() {
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
