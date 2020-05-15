//
//  WeatherManager.swift
//  Clima
//
//  Created by Sagar c bellad on 07/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import CoreLocation
import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=2c6fd00cd63e2e2459b6be8ca85b565f&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let UrlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: UrlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees,longitude: CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //Steps of networking
        //1 : Create an URL
        
        if let url = URL(string: urlString){    //URL is a standard structure
            print(url)
            //2 : Create an URL Session(Basically a web browser tab
            
            let session = URLSession(configuration: .default)
            
            //3 : Give session a task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return //this is written here so that we exit the function without moving furthur
                    //data,response and error of the dataTask is given by the browser only
                }
                
                if let safeData = data{
                    if let weather = self.parseJason(safeData){
                        self.delegate?.didUpdateWeather(self , weather: weather)
                    }
                }
            }
            
            //4 : Start a task-(Like giving the URL and pressing enter)
            
            task.resume()
        }
    }
    
    func parseJason(_ weatherData: Data) -> WeatherModel?{
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
           let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return (weather)
            
            //print(weather.temperatureString)
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
