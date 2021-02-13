//
//  ViewController.swift
//  ClimaWeather
//
//  Created by Сергей Голенко on 13.02.2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //Constants
    let key = "6c3304582b53d366dff5ef35000eecaa"
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    
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
    }
    



}

