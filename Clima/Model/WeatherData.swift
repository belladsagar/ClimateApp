//
//  WeatherData.swift
//  Clima
//
//  Created by Sagar c bellad on 12/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {//Codable is the typeAlies of both encoadble and decodeable and struct is turned into a type where it can decode itself from an external representation
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double //name of this should be exactly the same in the jason file here instead of 'temp' if we gave 'Temp' it wont work
}

struct Weather: Codable {
    let description: String
    let id: Int
}
