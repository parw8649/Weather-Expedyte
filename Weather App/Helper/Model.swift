//
//  Model.swift
//  Weather App
//
//  Created by Chaitanya on 12/12/22.
//

import Foundation

struct WeatherDetails : Codable{
    var current : current
    var main : main
    var hourly : [hourly]
    var list : [list]
}

struct main : Codable {
    var temp : Double
    var temp_min : Double
    var temp_max : Double
    var aqi : Int
    
    init(){
        temp = 0.0
        temp_min = 0.0
        temp_max = 0.0
        aqi = 0
    }
}

struct current : Codable {
    var dt : Int
    var sunrise : Int
    var sunset : Int
    var uvi : Double
    var weather : [weather]
    
    init(){
        dt = 0
        sunrise = 0
        sunset = 0
        uvi = 0.0
        weather = []
    }
}

struct hourly : Codable{
    var dt : Int
    var temp : Double
    var wind_speed : Double
    var weather : [weather]	
    
    init(){
        dt = 0
        temp = 0.0
        wind_speed = 0.0
        weather = []
    }
}

struct weather : Codable {
    var icon : String
    
    init(){
        icon = ""
    }
}

struct list : Codable {
    var components : components
    var dt : Int
}

struct components : Codable {
    var co : Double
    var no : Double
    var no2 : Double
    var o3 : Double
    var so2 : Double
    var pm2_5 : Double
    var pm10 : Double
    var nh3 : Double
    
    init(){
        co = 0.0
        no = 0.0
        no2 = 0.0
        o3 = 0.0
        so2 = 0.0
        pm2_5 = 0.0
        pm10 = 0.0
        nh3 = 0.0
    }
}


struct Temprature {
    var time : Int
    var temp : Double
    
    init(){
        time = 0
        temp = 0.0
    }
}

struct Information {
    
    var windSpeed : Double
    var time : Int
    
    init(){
        windSpeed = 0.0
        time = 0
    }
}

struct Info {
    
    var windSpeed : Double
    var time : Int
    var temp : Double
    
    init(){
        windSpeed = 0.0
        time = 0
        temp = 0.0
    }
}

struct InfoAirQlty{
    var time : Int
    var aqi : Int
    var  co : Double
    var no : Double
    var no2 : Double
    var o3 : Double
    var so2 : Double
    var pm2_5 : Double
    var pm10 : Double
    var nh3 : Double
    
    init(){
        time = 0
        aqi = 0
        co = 0.0
        no = 0.0
        no2 = 0.0
        o3 = 0.0
        so2 = 0.0
        pm2_5 = 0.0
        pm10 = 0.0
        nh3 = 0.0
    }
}

