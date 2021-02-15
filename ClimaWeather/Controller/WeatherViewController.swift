//
//  ViewController.swift
//  ClimaWeather
//
//  Created by Сергей Голенко on 13.02.2021.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //Constants
    let APP_ID = "6c3304582b53d366dff5ef35000eecaa"
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Set up the location manager here
        locationManager.delegate = self
        //set acciracy distanse
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
      
    }
    
    //MARK: - Networking
    
    func getWeatherData(url:String,param:[String:String]){
        AF.request(url,method: .get,parameters: param).responseJSON { response in
            if response.error != nil {
                self.cityLabel.text = "Проблема"
                print("Здесь какая то ошибка")
            } else {
                print("Успех! Быстрее покажи погоду")
                let weatherJSON : JSON = JSON(response.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
        }
    }
    }
    
    //MARK: - updateWeatherData method here
    func updateWeatherData(json : JSON) {
        let tempResult = json["main"]["temp"].double
        let city = json["name"].string
        temperatureLabel.text = String(Int(tempResult! - 273.15))
        cityLabel.text = city!
        
     
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    /*****************************************************/
    //write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        print(location)
        if location!.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let latitude = String((location?.coordinate.latitude)!)
            let longitude = String((location?.coordinate.longitude)!)
            print(longitude)
            let param : [String:String] = ["lat":latitude,"lon":longitude,"appid":APP_ID]
            
        getWeatherData(url: WEATHER_URL, param: param)
    }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable"
    }
    



}

