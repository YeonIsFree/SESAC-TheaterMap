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
            centerMapOnSeoul()
        }
    }
    
    // MARK: - Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNagivationBar()
        fillAllAnnotationsArray()
        centerMapOnSeoul()
        showAllAnnotations()
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
    
    func centerMapOnSeoul() {
        let centerCoor = CLLocationCoordinate2D(latitude: 37.554921, longitude: 126.970345)
        let region = MKCoordinateRegion(center: centerCoor, latitudinalMeters: 20000, longitudinalMeters: 20000)
        movieMapView.setRegion(region, animated: true)
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

// MARK: - Navigation Controller Configuration Methods

extension ViewController {
    func configureNagivationBar() {
        navigationItem.title = "영화보러가쟈"
        
        let barButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(barButtonItemTapped))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func barButtonItemTapped() {
        alert()
    }
}

