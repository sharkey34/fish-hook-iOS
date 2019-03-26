//
//  WeatherVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    @IBOutlet weak var weatherIV: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet var marinWeatherLables: [UILabel]!
    @IBOutlet weak var weatherDescLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var API_KEY: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "Current Weather"
        
//         Getting the api key from the plist and checking location.
        if let key = getKeys() {
            API_KEY = key
            checkLocationServices()
        }
    }
    
    // Getting the api key from the plist
    func getKeys() -> String? {
        guard let keyPath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {return nil}
        
        let keys = NSDictionary(contentsOfFile: keyPath)
        guard let dict = keys else {return nil}
    
        return dict.object(forKey: "WeatherAPI") as? String
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
    
    // Fetching the marine data
    func fetchMarineWeather(lat: String, long: String){
        let marineWeatherString = "https://api.worldweatheronline.com/premium/v1/marine.ashx?q=27.929097,-82.610179&format=json&key=85afa02d0e724309a44233800192203"
        
        let url = URL(string: marineWeatherString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)

                DispatchQueue.main.async {
                     let alert = Utils.basicAlert(title: "Error retrieving Weather Data", message: error.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            if let data = data {
                do{
                    if let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                        
                        guard let jsonData = jsonObj["data"] as? [String:Any], let weather = jsonData["weather"] as? [[String:Any]], let hourly = weather[0]["hourly"] as? [[String:Any]], let weatherDesc = hourly[0]["weatherDesc"] as? [[String:Any]] else {return}
                        
                        let temp = hourly[0]["tempF"] as? String ?? ""
                        let weatherDescription = weatherDesc[0]["value"] as? String ?? ""
                         let visibility = hourly[0]["visibility"] as? String ?? ""
                         let windDirection = hourly[0]["winddir16Point"] as? String ?? ""
                        let windSpeed = hourly[0]["windspeedMiles"] as? String ?? ""
                        let swellHeight = hourly[0]["swellHeight_ft"] as? String ?? ""
                        let waterTemp = hourly[0]["waterTemp_F"] as? String ?? ""
                        
                        DispatchQueue.main.async {

                            // Updating Weather labels
                            self.tempLabel.text = "\(temp)°"
                            self.weatherDescLabel.text = weatherDescription
                            
                            if let visibilityAsDouble = Double(visibility) {
                                
                                let visibilityInMiles = visibilityAsDouble * 0.6213712
                                let visibilityRounded = String.init(format: "%.2f", visibilityInMiles)
                                
                                self.marinWeatherLables[0].text = "Visibility: \(visibilityRounded) Miles"
                            }
                            self.marinWeatherLables[1].text = "Wind Direction: \(windDirection)"
                            self.marinWeatherLables[2].text = "Wind Speed: \(windSpeed) mph"
                            self.marinWeatherLables[3].text = "Swell Height: \(swellHeight) ft"
                            self.marinWeatherLables[4].text = "Water Temp: \(waterTemp)°"
                        }
                    }
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

// Extension for CLLocationManger
extension WeatherVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latLong = manager.location?.coordinate else {return}
        
        let lat = "\(latLong.latitude)"
        let long = "\(latLong.longitude)"
        locationManager.stopUpdatingLocation()
        fetchMarineWeather(lat: lat, long: long)
    }
}
