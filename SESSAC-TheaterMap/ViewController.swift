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
    
    private var theaterList: [Theater] = TheaterList.mapAnnotations
    
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
//        checkDeviceLocationAuthorization()
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
    
    private func centerMapOnCampus() {
        let centerCoor = CampusCoor.centerCoor
        let region = MKCoordinateRegion(center: centerCoor, latitudinalMeters: 5000, longitudinalMeters: 5000)
        movieMapView.setRegion(region, animated: true)
        
        let annotaion = MKPointAnnotation()
        annotaion.coordinate = centerCoor
        annotaion.title = CampusCoor.location
        movieMapView.addAnnotation(annotaion)
    }
    
    private func centerMapOnCurrentLocation(_ coor: CLLocationCoordinate2D?) {
        if let coor {
            let region = MKCoordinateRegion(center: coor, latitudinalMeters: 5000, longitudinalMeters: 5000)
            movieMapView.setRegion(region, animated: true)
        }
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
    func configureLocationManager() {
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapOnCurrentLocation(locations.last?.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        centerMapOnCampus()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
}

// MARK: - Location Authorization Methods

extension ViewController {
    
    // 사용자 "기기" 위치 서비스 활성화 여부 체크
    func checkDeviceLocationAuthorization() {
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
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
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            centerMapOnCampus()
            locationSettingAlert()
        case .authorizedWhenInUse:
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
        
        let rightBarButtonItem = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonTapped))
        navigationItem.leftBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(title: "현재 위치", style: .plain, target: self, action: #selector(getCurrentLocation))
        navigationItem.rightBarButtonItem = leftBarButtonItem
    }
    
    @objc func filterButtonTapped() {
        fillterButtonAlert()
    }
    
    @objc func getCurrentLocation() {
        checkDeviceLocationAuthorization()
    }
}

