//
//  MapsVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapsVC: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    // Core Location
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
    }

    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    // Location Manager Functions
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            checkLocationPermissions()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            let alert = Utils.basicAlert(title: "Unable to access location", message: "Please enable access to loctation services", Button: "OK")
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Checking the location permissions granted. If There has been no decision than requesting access
    func checkLocationPermissions(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // logic here
            break
        case .authorizedAlways:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Let user know about possible parental restrictions
            break
        case . denied:
            // Display alert telling the user to authorize permissions
            break
        }
    }
}

// Getting the location from the user for adding the catch.
extension MapsVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latLong = manager.location?.coordinate else {return}
        
        let zoomRegion = MKCoordinateRegion.init(
            center: CLLocationCoordinate2DMake(latLong.latitude, latLong.longitude), latitudinalMeters: 350, longitudinalMeters: 350)
        
        map.setRegion(zoomRegion, animated: true)
    }
}