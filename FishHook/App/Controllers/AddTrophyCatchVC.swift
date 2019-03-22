//
//  AddTrophyCatchVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import CoreLocation

class AddTrophyCatchVC: UIViewController {
    @IBOutlet weak var catchIV: UIImageView!
    @IBOutlet weak var fishTF: UITextField!
    @IBOutlet weak var metricTF: UITextField!
    
    // Firebase
    var storage: Storage!
    var db: Firestore!
    
    // ImagePicker
    var imagePicker = UIImagePickerController()

    // Location Manager
    var locationManager = CLLocationManager()
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    
    var currentUser: User?
    var imageID: String!
    var newCatch: Catch?
    var tID: String?
    var trophyID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        storage = Storage.storage()
        db = Firestore.firestore()
        imagePicker.delegate = self
        tID = UserDefaults.standard.string(forKey: "activeTournament")
    

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        catchIV.addGestureRecognizer(tap)
    }
    
    // ACTIONS
    
    @objc
    func imageTapped(sender: UITapGestureRecognizer) {
        addImage()
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        addImage()
    }
    @IBAction func submitCatch(_ sender: UIButton) {
        
        // TODO: Validating inputs
        guard !fishTF.isNullOrWhitespace(), !metricTF.isNullOrWhitespace(), let catchImage = catchIV.image else{
            let alert = Utils.basicAlert(title: "Invalid Entries", message: "Please make sure every field is filled out correctly and not left blank.", Button: "OK")
            present(alert, animated: true, completion: nil)
            return}
        
        // Saving image
        imageID = NSUUID().uuidString
        uploadImage(imageID: imageID, image: catchImage)
        
        // Saving to user
//        addTrophyCatch()
    }
    
    // Location Manager Functions
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            checkLocationPermissions()
        } else {
            let alert = Utils.basicAlert(title: "Unable to access location", message: "Please enable access to loctation services", Button: "OK")
            present(alert, animated: true, completion: nil)
        }
    }
    
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

    // Selecting image from camera alerting user if access is not available
    func addImage(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = Utils.basicAlert(title: "Access not granted", message: "Please navigate to settings and grant access to the camera.", Button: "OK")
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Function to upload image to Storage
    func uploadImage(imageID: String, image: UIImage){
        guard let storageRef = storage?.reference().child("trophy/\(imageID).jpg") else {return}
        
        // Local file you want to upload
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {return}
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload file and metadata
        let uploadTask = storageRef.putData(imageData, metadata: metadata)
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete.description)
        }
    }
//
//    func addTrophyCatch(){
//        db.collection("trophy").document().setData([String : Any]) { (error) in
//
//        }
//    }
    
    func saveCatchToUser(imageID: String){
        
        
    }
}

extension AddTrophyCatchVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Getting the image from the picker.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let edited = info[.editedImage] as? UIImage {
            catchIV.image = edited
        } else if let original = info[.originalImage] as? UIImage {
            catchIV.image = original
        } else {
            // TODO: Present the user with an Alert
            print("No image selected.")
        }
        dismiss(animated: true, completion: nil)
    }
}

// Getting the location from the user for adding the catch.
extension AddTrophyCatchVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latLong = manager.location?.coordinate else {return}
        
        self.lat = latLong.latitude
        self.long = latLong.longitude
        
        locationManager.stopUpdatingLocation()
    }
}
