//
//  DailyWeather.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/17/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import Foundation
import MapKit

func removeCompound(condition: String) -> String {
    return condition.components(separatedBy: " And")[0]
}

struct DailyWeather {
    let tempHigh: Int?
    let tempLow: Int?
    let condition: String?
    let date: Date
    let coordinate: CLLocationCoordinate2D
    var imgFound: Bool {
        get {
            guard let cond = self.condition else {
                return false
            }
            let simpleCond = removeCompound(condition: cond)
            return conditionImages[simpleCond] != nil
        }
    }
    
    var imageSmall: UIImage? {
        get {
            if imgFound {
                let cond = removeCompound(condition: condition!)
                return conditionImages[cond]!["small"]
            } else {
                return #imageLiteral(resourceName: "Moon-New")
            }
        }
    }
    var imageLarge: UIImage? {
        get {
            if imgFound {
                let cond = removeCompound(condition: condition!)
                return conditionImages[cond]!["big"]
            } else {
                return #imageLiteral(resourceName: "Moon-New-big")
            }
        }
    }
}


let conditionImages = [
    "Sunny": ["small": #imageLiteral(resourceName: "Sun"), "big": #imageLiteral(resourceName: "Sun-big")],
    "Mostly Sunny": ["small": #imageLiteral(resourceName: "Sun"), "big": #imageLiteral(resourceName: "Sun-big")],
    "Mostly Clear": ["small": #imageLiteral(resourceName: "Sun"), "big": #imageLiteral(resourceName: "Sun-big")],
    "Cold": ["small": #imageLiteral(resourceName: "Thermometer-25"), "big": #imageLiteral(resourceName: "Thermometer-25-big")],
    "Hot": ["small": #imageLiteral(resourceName: "Thermometer-100"), "big": #imageLiteral(resourceName: "Thermometer-100-big")],
    "Partly Sunny": ["small": #imageLiteral(resourceName: "Cloud-Sun"), "big": #imageLiteral(resourceName: "Cloud-Sun-big")],
    "Becoming Sunny": ["small": #imageLiteral(resourceName: "Cloud-Sun"), "big": #imageLiteral(resourceName: "Cloud-Sun-big")],
    "Partly Cloudy": ["small": #imageLiteral(resourceName: "Cloud-Sun"), "big": #imageLiteral(resourceName: "Cloud-Sun-big")],
    "Mostly Cloudy": ["small": #imageLiteral(resourceName: "Cloud-Sun"), "big": #imageLiteral(resourceName: "Cloud-Sun-big")],
    "Becoming Cloudy": ["small": #imageLiteral(resourceName: "Cloud-Sun"), "big": #imageLiteral(resourceName: "Cloud-Sun-big")],
    "Increasing Clouds": ["small": #imageLiteral(resourceName: "Cloud"), "big": #imageLiteral(resourceName: "Cloud-big")],
    "Decreasing Clouds": ["small": #imageLiteral(resourceName: "Cloud"), "big": #imageLiteral(resourceName: "Cloud-big")],
    "Gradual Clearing": ["small": #imageLiteral(resourceName: "Cloud-Sun"), "big": #imageLiteral(resourceName: "Cloud-Sun-big")],
    "Clearing Late": ["small": #imageLiteral(resourceName: "Cloud-Sun"), "big": #imageLiteral(resourceName: "Cloud-Sun-big")],
    "Cloudy": ["small": #imageLiteral(resourceName: "Cloud"), "big": #imageLiteral(resourceName: "Cloud-big")],
    "Thunderstorm": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Thunderstorms": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Slight Chance Thunderstorm": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Slight Chance Thunderstorms": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Chance Thunderstorm": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Chance Thunderstorms": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Thunderstrom Likely": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Thunderstorms Likely": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Isolated Thunderstorm": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Isolated Thunderstorms": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Severe Tstms": ["small": #imageLiteral(resourceName: "Cloud-Lightning"), "big": #imageLiteral(resourceName: "Cloud-Lightning-big")],
    "Chance Rain Showers": ["small": #imageLiteral(resourceName: "Cloud-Drizzle"), "big": #imageLiteral(resourceName: "Cloud-Drizzle-big")],
    "Chance Showers": ["small": #imageLiteral(resourceName: "Cloud-Drizzle"), "big": #imageLiteral(resourceName: "Cloud-Drizzle-big")],
    "Scattered Rain Showers": ["small": #imageLiteral(resourceName: "Cloud-Drizzle"), "big": #imageLiteral(resourceName: "Cloud-Drizzle-big")],
    "Scattered Showers": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")],
    "Slight Chance Rain Showers": ["small": #imageLiteral(resourceName: "Cloud-Rain-Alt"), "big": #imageLiteral(resourceName: "Cloud-Rain-Alt-big")],
    "Slight Chance Showers": ["small": #imageLiteral(resourceName: "Cloud-Rain-Alt"), "big": #imageLiteral(resourceName: "Cloud-Rain-Alt-big")],
    "Isolated Rain Showers": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")],
    "Isolated Showers": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")],
    "Rain Showers Likely": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")] ,
    "Showers Likely": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")] ,
    "Chance Rain": ["small": #imageLiteral(resourceName: "Cloud-Drizzle"), "big": #imageLiteral(resourceName: "Cloud-Drizzle-big")],
    "Chance Light Rain": ["small": #imageLiteral(resourceName: "Cloud-Drizzle"), "big": #imageLiteral(resourceName: "Cloud-Drizzle-big")],
    "Slight Chance Rain": ["small": #imageLiteral(resourceName: "Cloud-Rain-Alt"), "big": #imageLiteral(resourceName: "Cloud-Rain-Alt-big")],
    "Slight Chance Light Rain": ["small": #imageLiteral(resourceName: "Cloud-Rain-Alt"), "big": #imageLiteral(resourceName: "Cloud-Rain-Alt-big")],
    "Light Rain": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")],
    "Rain Likely": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")],
    "Chance Rain/Snow": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")] ,
    "Slight Chance Rain/Snow": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Rain/Snow Likely": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Chance Rain/Freezing Rain": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Slight Chance Rain/Freezing Rain": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Rain/Freezing Rain Likely": ["small": #imageLiteral(resourceName: "Cloud-Hail-Alt"), "big": #imageLiteral(resourceName: "Cloud-Hail-Alt-big")],
    "Chance Freezing Rain": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Slight Chance Freezing Rain": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Freezing Rain Likely": ["small": #imageLiteral(resourceName: "Cloud-Hail-Alt"), "big": #imageLiteral(resourceName: "Cloud-Hail-Alt-big")],
    "Chance Drizzle": ["small": #imageLiteral(resourceName: "Cloud-Drizzle-Alt"), "big": #imageLiteral(resourceName: "Cloud-Drizzle-Alt-big")],
    "Slight Chance Drizzle": ["small": #imageLiteral(resourceName: "Cloud-Drizzle-Alt"), "big": #imageLiteral(resourceName: "Cloud-Drizzle-Alt-big")],
    "Drizzle Likely": ["small": #imageLiteral(resourceName: "Cloud-Drizzle"), "big": #imageLiteral(resourceName: "Cloud-Drizzle-big")],
    "Drizzle": ["small": #imageLiteral(resourceName: "Cloud-Drizzle"), "big": #imageLiteral(resourceName: "Cloud-Drizzle-big")],
    "Chance Freezing Drizzle": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Slight Chance Freezing Drizzle": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Freezing Drizzle Likely": ["small": #imageLiteral(resourceName: "Cloud-Hail-Alt"), "big": #imageLiteral(resourceName: "Cloud-Hail-Alt-big")],
    "Chance Rain/Sleet": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Slight Chance Rain/Sleet": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Rain/Sleet Likely": ["small": #imageLiteral(resourceName: "Cloud-Drizzle"), "big": #imageLiteral(resourceName: "Cloud-Drizzle-big")],
    "Rain": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")],
    "Widespread Showers": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")],
    "Rain Showers": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")],
    "Showers": ["small": #imageLiteral(resourceName: "Cloud-Rain"), "big": #imageLiteral(resourceName: "Cloud-Rain-big")],
    "Rain/Snow": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Freezing Rain": ["small": #imageLiteral(resourceName: "Cloud-Hail-Alt"), "big": #imageLiteral(resourceName: "Cloud-Hail-Alt-big")],
    "Rain/Freezing Rain": ["small": #imageLiteral(resourceName: "Cloud-Hail-Alt"), "big": #imageLiteral(resourceName: "Cloud-Hail-Alt-big")],
    "Freezing Drizzle": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Rain/Sleet": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Snow": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Snow Showers": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Isolated Snow Showers": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Scattered Snow Showers": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],

    "Blizzard": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Blowing Snow": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Wintry Mix": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Flurries": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Snow/Sleet": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Sleet": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Chance Snow Showers": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Slight Chance Snow Showers": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Snow Showers Likely": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Chance Snow": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Chance Light Snow": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Slight Chance Snow": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Slight Chance Light Snow": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Snow Likely": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Light Snow Likely": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],

    "Areas Of Blowing Snow": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],

    "Chance Wintry Mix": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Slight Chance Wintry Mix": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Wintry Mix Likely": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Chance Snow/Sleet": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Slight Chance Snow/Sleet": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Snow/Sleet Likely": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Chance Sleet": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Slight Chance Sleet": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Sleet Likely": ["small": #imageLiteral(resourceName: "Cloud-Hail"), "big": #imageLiteral(resourceName: "Cloud-Hail-big")],
    "Chance Flurries": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Slight Chance Flurries": ["small": #imageLiteral(resourceName: "Cloud-Snow-Alt"), "big": #imageLiteral(resourceName: "Cloud-Snow-Alt-big")],
    "Flurries Likely": ["small": #imageLiteral(resourceName: "Cloud-Snow"), "big": #imageLiteral(resourceName: "Cloud-Snow-big")],
    "Patchy Fog": ["small": #imageLiteral(resourceName: "Cloud-Fog-Sun"), "big": #imageLiteral(resourceName: "Cloud-Fog-Sun-big")],
    "Areas Fog": ["small": #imageLiteral(resourceName: "Cloud-Fog-Sun"), "big": #imageLiteral(resourceName: "Cloud-Fog-Sun-big")],
    "Areas Ice Fog": ["small": #imageLiteral(resourceName: "Cloud-Fog-Sun"), "big": #imageLiteral(resourceName: "Cloud-Fog-Sun-big")],
    "Areas Of Freezing Fog": ["small": #imageLiteral(resourceName: "Cloud-Fog-Sun"), "big": #imageLiteral(resourceName: "Cloud-Fog-Sun-big")],
    "Patchy Freezing Fog": ["small": #imageLiteral(resourceName: "Cloud-Fog"), "big": #imageLiteral(resourceName: "Cloud-Fog-big")],
    "Areas Freezing Fog": ["small": #imageLiteral(resourceName: "Cloud-Fog"), "big": #imageLiteral(resourceName: "Cloud-Fog-big")],
    "Patchy Smoke": ["small": #imageLiteral(resourceName: "Cloud-Fog-Sun"), "big": #imageLiteral(resourceName: "Cloud-Fog-Sun-big")],
    "Areas Smoke": ["small": #imageLiteral(resourceName: "Cloud-Fog"), "big": #imageLiteral(resourceName: "Cloud-Fog-big")],
    "Breezy": ["small": #imageLiteral(resourceName: "Cloud-Wind"), "big": #imageLiteral(resourceName: "Cloud-Wind-big")],
    "Areas Of Blowing Dust": ["small": #imageLiteral(resourceName: "Cloud-Wind"), "big": #imageLiteral(resourceName: "Cloud-Wind-big")],
    "Blustery": ["small": #imageLiteral(resourceName: "Cloud-Wind"), "big": #imageLiteral(resourceName: "Cloud-Wind-big")],
    "Windy": ["small": #imageLiteral(resourceName: "Cloud-Wind"), "big": #imageLiteral(resourceName: "Cloud-Wind-big")],
    "Fog": ["small": #imageLiteral(resourceName: "Cloud-Fog"), "big": #imageLiteral(resourceName: "Cloud-Fog-big")],
    "Dense Fog": ["small": #imageLiteral(resourceName: "Cloud-Fog"), "big": #imageLiteral(resourceName: "Cloud-Fog-big")],
    "Freezing Fog": ["small": #imageLiteral(resourceName: "Cloud-Fog"), "big": #imageLiteral(resourceName: "Cloud-Fog-big")],
    "Smoke": ["small": #imageLiteral(resourceName: "Cloud-Fog"), "big": #imageLiteral(resourceName: "Cloud-Fog-big")]
]
