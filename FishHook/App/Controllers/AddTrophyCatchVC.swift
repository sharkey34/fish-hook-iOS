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
    var lat: Double?
    var long: Double?
    
    var currentUser: User?
    var imageID: String!
    var newCatch: Catch?
    var tID: String?
    var trophyID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        subscribeUnsubscribe(bool: true)
    }
    
    // Setting up Firestore, storage, location manager and image picker
    func setUp(){
        navigationItem.title = "Add Catch"
        tID = UserDefaults.standard.string(forKey: "activeTournament")
        storage = Storage.storage()
        db = Firestore.firestore()
        imagePicker.delegate = self
        checkLocationServices()
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
        // Validating inputs
        guard !fishTF.isNullOrWhitespace(), !metricTF.isNullOrWhitespace(), let catchImage = catchIV.image, let UID = currentUser?.uid, let id = tID, let latitude = lat, let longitude = long, let userName = currentUser?.userName
            else{
            let alert = Utils.basicAlert(title: "Invalid Entries", message: "Please make sure every field is filled out correctly and not left blank.", Button: "OK")
            present(alert, animated: true, completion: nil)
            return}
        
        let catchID = db.collection("trophy").document().documentID
        imageID = NSUUID().uuidString
    
        newCatch = Catch(_id: catchID, _aID: nil, _userName: userName, _place: nil, _userID: UID, _metric: metricTF.text!, _fish: fishTF.text!, _image: catchImage, _imageID: imageID, _tID: id, _lat: latitude, _long: longitude)
        
        // Saving image
        uploadImage(imageID: imageID, image: catchImage)
        
        // Saving to user
        addTrophyCatch(lat: latitude, long: longitude)
    }
    
    // Saving the trophy catch to firestore.
    func addTrophyCatch(lat: Double, long: Double){
        
        if let c = newCatch {
            db.collection("trophy").document(c.id).setData(
            [
                "tID": tID!,
                "userName": c.userName,
                "lat": c.lat!,
                "long": c.long!,
                "userID": c.userID,
                "image": c.imageID!,
                "fish": c.fish,
                "metric": c.metric
            ]
            ) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    self.saveCatchToUser()
                }
            }
        }
    }
    
    // Saving the catch to the current user.
    func saveCatchToUser(){
        
        db.collection("users").document(currentUser!.uid).updateData(
            [
                "trophies": FieldValue.arrayUnion([newCatch!.id])
            ]
        ) { (error) in
            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "fromAddTrophy", sender: self)
            }
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
    
    @objc func show(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    @objc func hide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Subscribing and unsubscribing to keyboard observers.
    func subscribeUnsubscribe(bool: Bool){
        if bool == true {
            NotificationCenter.default.addObserver(self, selector: #selector(show(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(hide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
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
