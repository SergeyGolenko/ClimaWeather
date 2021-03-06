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
    @IBOutlet weak var speedWind: UILabel!
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var clouds: UILabel!
    @IBOutlet weak var latiude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var viewForContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewForContainer.layer.cornerRadius = view.frame.width / 5
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
            guard   let tempResult = json["main"]["temp"].double else {return}
            weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.speedWind = json["wind"]["speed"].intValue
        weatherDataModel.city = json["name"].string!
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.station = json["sys"]["country"].string!
        weatherDataModel.latitude = json["coord"]["lat"].doubleValue
        weatherDataModel.longitude = json["coord"]["lon"].doubleValue
        weatherDataModel.clouds = json["weather"][0]["main"].stringValue
        weatherDataModel.intDate = json["sys"]["sunrise"].intValue
        weatherDataModel.intDate2 = json["sys"]["sunset"].intValue
        updateUIWithWeatherData()
    }
    
    //MARK: - UI Updates
    func updateUIWithWeatherData(){
        temperatureLabel.text = "Temperature : " + String(weatherDataModel.temperature) + "℃"
        cityLabel.text = weatherDataModel.city
        weatherIcon.image = UIImage(named: weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition))
        speedWind.text = "Speed wind : " + String(weatherDataModel.speedWind) + "💨"
        station.text =  "Country : " + weatherDataModel.station
        latiude.text = "latitude : " + String(weatherDataModel.latitude)
        longitude.text = "longitude : " + String(weatherDataModel.longitude)
        clouds.text = "Cloudy : " + weatherDataModel.clouds
        sunset.text = "Sunset " + weatherDataModel.formatDate(date: weatherDataModel.sunset) + "🌘"
        sunrise.text = "Sunrise " + weatherDataModel.formatDate(date: weatherDataModel.sunrise) + "🌕"
       
        
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    /*****************************************************/
    //write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
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

extension WeatherViewController : ChangeCityProtocol {
    func userEnterNewCity(city: String) {
        let params : [String:String] = ["appid":APP_ID,"q":city,"lang":"ru"]
        getWeatherData(url: WEATHER_URL, param: params)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destinationVC = segue.destination as? ChangeCityViewController
            destinationVC?.delegate = self
            
        }
    }
    
}

