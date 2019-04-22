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
import FirebaseFirestore

class MapsVC: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    // Core Location
    var locationManager = CLLocationManager()
    var catches = [Catch]()
    var currentUser: User!
    var db: Firestore!
    var currentLocation: CLLocationCoordinate2D?
    var testLocation: CLLocationCoordinate2D?
    var annotations: [MKAnnotation]?
    
    var testCoordinates = [(27.944138, -82.576719), (27.905503, -82.579033), (27.904776, -82.610531
        ), (27.920907, -82.586123),(27.938795, -82.590103),(27.943244, -82.622278), (27.937913, -82.662145),(27.985131, -82.633544),(27.974599, -82.654735),(27.964158, -82.588436)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocationServices()
        
        if currentUser.admin {
            fetchAllCatches()
        } else {
            fetchUserCatches()
        }
    }
    
    func setUp(){
        db = Firestore.firestore()
        map.delegate = self
        
        navigationItem.title = "Current Location"
        
        if let tabVC = tabBarController as? TabVC {
            currentUser = tabVC.currentUser
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        catches.removeAll()
        if let a = annotations {
            map.removeAnnotations(a)
        }
        annotations?.removeAll()
    }
    
    
    // fetching catches specific to the user
    func fetchUserCatches(){
        
        db.collection("trophy").whereField("userID", isEqualTo: currentUser.uid).getDocuments(source: .default) { (documents, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let docs = documents?.documents {
                
                for doc in docs {
                    let map = doc.data()
                    let id = doc.documentID
                    let tID = map["tID"] as? String
                    let userName = map["userName"] as! String
                    let lat = map["lat"] as? Double
                    let long = map["long"] as? Double
                    let userID = map["userID"] as! String
                    let imageID = map["image"] as? String
                    let fish = map["fish"] as! String
                    let metric = map["metric"] as! String
                    
                    self.catches.append(Catch(_id: id, _aID: nil, _userName: userName, _place: nil, _userID: userID, _metric: metric, _fish: fish, _image: nil, _imageID: imageID, _tID: tID, _lat: lat, _long: long))
                }
                self.displayCatches()
            }
        }
    }
    
    // fetching all catches for the admin to see
    func fetchAllCatches(){
        db.collection("trophy").getDocuments(source: .default) { (documents, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let docs = documents?.documents {
                
                for doc in docs {
                    let map = doc.data()
                    let id = doc.documentID
                    let tID = map["tID"] as? String
                    let userName = map["userName"] as! String
                    let lat = map["lat"] as? Double
                    let long = map["long"] as? Double
                    let userID = map["userID"] as! String
                    let imageID = map["image"] as? String
                    let fish = map["fish"] as! String
                    let metric = map["metric"] as! String
                    
                    self.catches.append(Catch(_id: id, _aID: nil, _userName: userName, _place: nil, _userID: userID, _metric: metric, _fish: fish, _image: nil, _imageID: imageID, _tID: tID, _lat: lat, _long: long))
                }
                self.displayCatches()
            }
        }
    }
    
    func displayCatches() {
        // For Testing Purposes
        let lat = CLLocationDegrees(exactly: 27.929097)
        let long = CLLocationDegrees(exactly: -82.610179)
        
        testLocation = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        let testCoordinate = MKPointAnnotation()
        testCoordinate.coordinate = testLocation!
        map.addAnnotation(testCoordinate)
        
        let zoomRegion = MKCoordinateRegion.init(
            center: CLLocationCoordinate2DMake(lat!, long!), latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        map.setRegion(zoomRegion, animated: true)
        
        annotations?.append(testCoordinate)
        
        for trophyCatch in catches.enumerated() {
            let annotation = MKPointAnnotation()
            annotation.title = trophyCatch.element.fish
            annotation.subtitle = trophyCatch.element.imageID
            
            if trophyCatch.offset > testCoordinates.count - 1 {
                 annotation.coordinate = CLLocationCoordinate2D(latitude: testCoordinates[0].0, longitude: testCoordinates[0].1)
            } else {
                 annotation.coordinate = CLLocationCoordinate2D(latitude: testCoordinates[trophyCatch.offset].0, longitude: testCoordinates[trophyCatch.offset].1)
            }
           
            
            annotations?.append(annotation)
            map.addAnnotation(annotation)
        }
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
        @unknown default:
            print("Unknown error occurred")
        }
    }
    
    func zoomToLocation(location: CLLocationCoordinate2D){
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1100, longitudinalMeters: 1100)
        map.setRegion(region, animated: true)
    }
}

// Getting the location from the user for adding the catch.
extension MapsVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        guard let location = locations.first else {return}
        //
        //        if currentLocation == nil {
        //            zoomToLocation(location: location.coordinate)
        //        }
        //        currentLocation = location.coordinate
    }
}


// Map Delegate
extension MapsVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Create and display custom views
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "view")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "view")
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        
        if let imageID = annotation.subtitle! {
            print("Image ID \(imageID)")
            
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/fish-hook-3ef8d.appspot.com/o/trophy%2F\(imageID).jpg?alt=media&token=c29ad4be-23a0-4bce-945a-00d1298bf8d8")
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        let size = CGSize(width: 75, height: 75)
                        UIGraphicsBeginImageContext(size)
                        if let i = image {
                            i.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                            let small = UIGraphicsGetImageFromCurrentImageContext()
                            annotationView?.image = small
                        }
                    }
                }
                }.resume()
        } else {
            DispatchQueue.main.async {
                let image = UIImage(named: "UserBoat")
                let size = CGSize(width: 85, height: 85)
                UIGraphicsBeginImageContext(size)
                image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let small = UIGraphicsGetImageFromCurrentImageContext()
                annotationView?.image = small
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected")
    }
}
