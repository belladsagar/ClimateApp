//
//  ViewController.swift
//  Clima
//
//  Created by SAGAR C BELLAD on 31/03/2020.
//  Copyright © 2019 App. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    //UItextfielddelegate is a protocol
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    @IBAction func currentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        //Delegate is a function present in the "TextField" button
        //Delegate takes on "Class protocol datatype"
        //USE of delegate:A textField delegate is the one which respeonds to the keyboard operations we perform below,the function we used such as "textFieldShouldReturn","textFieldShouldReturn" are the ones used to perform the special fuction has keyboard return key being tapped,where the keyboard keys is referred as the delegate where in this case its the "searchTextField",which when written searchTextField(True) our return key closes the keyboard
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //Default transparent search is the placeholder name
        print(searchTextField.text!)
        //the below line tells the search_textfield that we are done editing and that it can close the keyboard
        searchTextField.endEditing(true)
    }
    
    //Below function are the delegates of the textField
    //this below function is used to trigger "enter" button on the built-in-keyboard to search
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        //the below line tells the search_textfield that we are done editing and that it can close the keyboard
        searchTextField.endEditing(true)
        return(true)
    }
    
    //this is used to provide validations for the textfield
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != ""{
            return(true)
        }
        else{
            searchTextField.placeholder = "Type something!"
            return(false)
        }
    }
    
    //this below function is to clear the search_bar when the text_field editing is done(i.e when the keyboard is minimized)
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = searchTextField.text{
            weatherManager.fetchWeather(cityName: cityName)
        }
        searchTextField.text = ""
        
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - ClLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            weatherManager.fetchWeather(latitude: lat,longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

