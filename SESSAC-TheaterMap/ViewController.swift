//
//  ViewController.swift
//  SESSAC-TheaterMap
//
//  Created by Seryun Chun on 2024/01/24.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet var movieMapView: MKMapView!
    
    private var theaterList: [Theater] = TheaterList().mapAnnotations
    
    private var allAnnotations: [MKAnnotation] = []
    
    private var displayedAnnotations: [MKAnnotation]? {
        willSet { // 바뀌기 전: 맵에서 이전 데이터 모두 삭제
            if let currentAnnotations = displayedAnnotations {
                movieMapView.removeAnnotations(currentAnnotations)
            }
        }
        didSet { // 바뀐 후: 새로운 데이터로 맵 갱신, 지도 중앙
            if let newAnnotations = displayedAnnotations {
                movieMapView.addAnnotations(newAnnotations)
            }
            centerMapOnCampus()
        }
    }
    
    let locationManager = CLLocationManager()
    
    // MARK: - Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNagivationBar()
        configureLocationManager()
        centerMapOnCampus()
        fillAllAnnotationsArray()
        showAllAnnotations()
        
        checkDeviceLocationAuthorization()
    }
    
    // MARK: - MapView Configuratin Methods
    
    private func fillAllAnnotationsArray() {
        for theater in theaterList {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
            annotation.title = theater.location
            
            allAnnotations.append(annotation)
        }
    }
    
    func centerMapOnCampus() {
        let centerCoor = CLLocationCoordinate2D(latitude: 37.6543906, longitude: 127.0498832)
        let region = MKCoordinateRegion(center: centerCoor, latitudinalMeters: 5000, longitudinalMeters: 5000)
        movieMapView.setRegion(region, animated: true)
        
        let annotaion = MKPointAnnotation()
        annotaion.coordinate = centerCoor
        annotaion.title = "새싹 도봉캠퍼스"
        movieMapView.addAnnotation(annotaion)
    }
    
    func showAllAnnotations() {
        displayedAnnotations = allAnnotations
    }
    
    func displayOne(_ targetTheaterType: String) {
        let newAnnotations = allAnnotations.filter { annotation in
            if let theaterType = annotation.title {
                return targetTheaterType == theaterType?.components(separatedBy: " ").first
            }
            return false
        }
        displayedAnnotations = newAnnotations
    }
}

// MARK: - CLLocationManager Delegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, #line, #file)
        centerMapOnCampus()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, #line, #file)
        checkDeviceLocationAuthorization()
    }
}

// MARK: -

extension ViewController {
    func configureLocationManager() {
        locationManager.delegate = self
    }
    
    // 사용자 "기기" 위치 서비스 활성화 여부 체크
    func checkDeviceLocationAuthorization() {
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
//                print("위치 서비스 켜져있음")
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
                
            } else {
                print("위치 서비스 꺼져있음")
            }
        }
    }
    
    // 사용자 위치 "권한" 체크
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("최초 실행?")
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("거절됨")
            centerMapOnCampus()
            locationSettingAlert()
        case .authorizedWhenInUse:
            print("한번만 실행")
            locationManager.startUpdatingLocation()
        default:
            print("ERROR")
        }
    }
}

// MARK: - Navigation Controller Configuration Methods

extension ViewController {
    func configureNagivationBar() {
        navigationItem.title = "영화보러가쟈"
        
        let barButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(barButtonItemTapped))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func barButtonItemTapped() {
        fillterButtonAlert()
    }
}

