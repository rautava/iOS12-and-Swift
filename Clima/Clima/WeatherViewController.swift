//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import Alamofire
import CoreLocation
import SwiftyJSON
import UIKit

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    // Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = getApiKey(name: "OpenWeatherMapApiKey") ?? ""

    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    var currentCity: String?

    // Pre-linked IBOutlets
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Networking

    /***************************************************************/

    func getWeatherData(parameters: [String: String]) {
        let request = Alamofire.request(WEATHER_URL, method: .get, parameters: parameters)
        request.responseJSON {
            response in
            if response.result.isSuccess {
                let json: JSON = JSON(response.result.value ?? "")
                self.updateWeatherData(json: json)
                self.updateUIWithWeatherData()
            } else {
                if let error = response.result.error {
                    print(error)
                }
            }
        }
    }

    // MARK: - JSON Parsing

    /***************************************************************/

    func updateWeatherData(json: JSON) {
        weatherDataModel.temperature = json["main"]["temp"].intValue
        weatherDataModel.city = json["name"].string ?? "Not Available"
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        weatherDataModel.dateTime = Date(timeIntervalSince1970: json["dt"].doubleValue)

        currentCity = json["name"].string
    }

    // MARK: - UI Updates

    /***************************************************************/

    func updateUIWithWeatherData() {
        temperatureLabel.text = "\(weatherDataModel.temperature)°C"
        cityLabel.text = weatherDataModel.city
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        timeLabel.text = weatherDataModel.timeStamp()
    }

    // MARK: - Location Manager Delegate Methods

    /***************************************************************/

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Stop updating after the first valid location.
            if location.horizontalAccuracy > 0 {
                locationManager.stopUpdatingLocation()

                let latitude = String(location.coordinate.latitude)
                let longitude = String(location.coordinate.longitude)

                let params: [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_ID, "units": "metric"]
                getWeatherData(parameters: params)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }

    // MARK: - Change City Delegate methods

    /***************************************************************/

    func userEnteredCityName(city: String?) {
        if let city = city {
            let params: [String: String] = ["q": city, "appid": APP_ID, "units": "metric"]
            getWeatherData(parameters: params)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController

            destinationVC.delegate = self
        }
    }
}
