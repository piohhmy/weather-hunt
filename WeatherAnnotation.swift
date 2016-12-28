//
//  WeatherAnnotation.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/17/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import Foundation
import UIKit
import MapKit

let conditionImages = [
    "Sunny": #imageLiteral(resourceName: "sun"),
    "Mostly Sunny": #imageLiteral(resourceName: "sun"),
    "Cold": #imageLiteral(resourceName: "sun"),
    "Hot": #imageLiteral(resourceName: "sun"),
    "Partly Sunny": #imageLiteral(resourceName: "mostlysun"),
    "Becoming Sunny": #imageLiteral(resourceName: "mostlysun"),
    "Partly Cloudy": #imageLiteral(resourceName: "mostlysun"),
    "Mostly Cloudy": #imageLiteral(resourceName: "mostlysun"),
    "Becoming Cloudy": #imageLiteral(resourceName: "mostlysun"),
    "Increasing Clouds": #imageLiteral(resourceName: "mostlysun"),
    "Decreasing Clouds": #imageLiteral(resourceName: "mostlysun"),
    "Gradual Clearing": #imageLiteral(resourceName: "mostlysun"),
    "Cloudy": #imageLiteral(resourceName: "cloudy"),
    "Thunderstorm": #imageLiteral(resourceName: "tstorm"),
    "Thunderstorms": #imageLiteral(resourceName: "tstorm"),
    "Slight Chance Thunderstorm": #imageLiteral(resourceName: "tstorm"),
    "Slight Chance Thunderstorms": #imageLiteral(resourceName: "tstorm"),
    "Chance Thunderstorm": #imageLiteral(resourceName: "tstorm"),
    "Chance Thunderstorms": #imageLiteral(resourceName: "tstorm"),
    "Thunderstrom Likely": #imageLiteral(resourceName: "tstorm"),
    "Thunderstorms Likely": #imageLiteral(resourceName: "tstorm"),
    "Isolated Thunderstorm": #imageLiteral(resourceName: "tstorm"),
    "Isolated Thunderstorms": #imageLiteral(resourceName: "tstorm"),
    "Severe Tstms": #imageLiteral(resourceName: "tstorm"),
    "Chance Rain Showers": #imageLiteral(resourceName: "rainchance"),
    "Slight Chance Rain Showers": #imageLiteral(resourceName: "rainchance"),
    "Rain Showers Likely": #imageLiteral(resourceName: "rainchance"),
    "Chance Rain": #imageLiteral(resourceName: "rainchance"),
    "Slight Chance Rain": #imageLiteral(resourceName: "rainchance"),
    "Rain Likely": #imageLiteral(resourceName: "rainchance"),
    "Chance Rain/Snow": #imageLiteral(resourceName: "rainchance"),
    "Slight Chance Rain/Snow": #imageLiteral(resourceName: "rainchance"),
    "Rain/Snow Likely": #imageLiteral(resourceName: "rainchance"),
    "Chance Rain/Freezing Rain":#imageLiteral(resourceName: "rainchance"),
    "Slight Chance Rain/Freezing Rain":#imageLiteral(resourceName: "rainchance"),
    "Rain/Freezing Rain Likely":#imageLiteral(resourceName: "rainchance"),
    "Chance Freezing Rain": #imageLiteral(resourceName: "rainchance"),
    "Slight Chance Freezing Rain":#imageLiteral(resourceName: "rainchance"),
    "Freezing Rain Likely":#imageLiteral(resourceName: "rainchance"),
    "Chance Drizzle":#imageLiteral(resourceName: "rainchance"),
    "Slight Chance Drizzle":#imageLiteral(resourceName: "rainchance"),
    "Drizzle Likely":#imageLiteral(resourceName: "rainchance"),
    "Drizzle":#imageLiteral(resourceName: "rainchance"),
    "Chance Freezing Drizzle":#imageLiteral(resourceName: "rainchance"),
    "Slight Chance Freezing Drizzle":#imageLiteral(resourceName: "rainchance"),
    "Freezing Drizzle Likely":#imageLiteral(resourceName: "rainchance"),
    "Chance Rain/Sleet":#imageLiteral(resourceName: "rainchance"),
    "Slight Chance Rain/Sleet":#imageLiteral(resourceName: "rainchance"),
    "Rain/Sleet Likely":#imageLiteral(resourceName: "rainchance"),
    "Rain":#imageLiteral(resourceName: "rain"),
    "Rain Showers":#imageLiteral(resourceName: "rain"),
    "Rain/Snow":#imageLiteral(resourceName: "rain"),
    "Freezing Rain":#imageLiteral(resourceName: "rain"),
    "Rain/Freezing Rain":#imageLiteral(resourceName: "rain"),
    "Freezing Drizzle":#imageLiteral(resourceName: "rain"),
    "Rain/Sleet":#imageLiteral(resourceName: "rain"),
    "Snow":#imageLiteral(resourceName: "snow"),
    "Snow Showers":#imageLiteral(resourceName: "snow"),
    "Blizzard":#imageLiteral(resourceName: "snow"),
    "Blowing Snow":#imageLiteral(resourceName: "snow"),
    "Wintry Mix":#imageLiteral(resourceName: "snow"),
    "Flurries":#imageLiteral(resourceName: "snow"),
    "Snow/Sleet":#imageLiteral(resourceName: "snow"),
    "Sleet":#imageLiteral(resourceName: "snow"),
    "Chance Snow Showers":#imageLiteral(resourceName: "snowchance"),
    "Slight Chance Snow Showers":#imageLiteral(resourceName: "snowchance"),
    "Snow Showers Likely":#imageLiteral(resourceName: "snowchance"),
    "Chance Snow":#imageLiteral(resourceName: "snowchance"),
    "Slight Chance Snow":#imageLiteral(resourceName: "snowchance"),
    "Snow Likely":#imageLiteral(resourceName: "snowchance"),
    "Chance Wintry Mix":#imageLiteral(resourceName: "snowchance"),
    "Slight Chance Wintry Mix":#imageLiteral(resourceName: "snowchance"),
    "Wintry Mix Likely":#imageLiteral(resourceName: "snowchance"),
    "Chance Snow/Sleet":#imageLiteral(resourceName: "snowchance"),
    "Slight Chance Snow/Sleet":#imageLiteral(resourceName: "snowchance"),
    "Snow/Sleet Likely":#imageLiteral(resourceName: "snowchance"),
    "Chance Sleet":#imageLiteral(resourceName: "snowchance"),
    "Slight Chance Sleet":#imageLiteral(resourceName: "snowchance"),
    "Sleet Likely":#imageLiteral(resourceName: "snowchance"),
    "Chance Flurries":#imageLiteral(resourceName: "snowchance"),
    "Slight Chance Flurries":#imageLiteral(resourceName: "snowchance"),
    "Flurries Likely":#imageLiteral(resourceName: "snowchance"),
    "Patchy Fog":#imageLiteral(resourceName: "patchyfog.png"),
    "Areas Fog":#imageLiteral(resourceName: "patchyfog.png"),
    "Patchy Freezing Fog":#imageLiteral(resourceName: "patchyfog.png"),
    "Areas Freezing Fog":#imageLiteral(resourceName: "patchyfog"),
    "Patchy Smoke":#imageLiteral(resourceName: "patchyfog"),
    "Areas Smoke":#imageLiteral(resourceName: "patchyfog"),
    "Breezy":#imageLiteral(resourceName: "windy"),
    "Blustery":#imageLiteral(resourceName: "windy"),
    "Windy":#imageLiteral(resourceName: "windy"),
    "Fog":#imageLiteral(resourceName: "fog"),
    "Dense Fog":#imageLiteral(resourceName: "fog"),
    "Freezing Fog":#imageLiteral(resourceName: "fog"),
    "Smoke":#imageLiteral(resourceName: "fog")
    ]


class WeatherAnnotation: MKPointAnnotation {
    var image:UIImage?
    
    init(fromDailyWeather weather:DailyWeather) {
        self.image = conditionImages[weather.condition]
        super.init()
        self.title = weather.condition
        self.subtitle = "High: \(weather.tempHigh) Low: \(weather.tempLow)"
        self.coordinate = weather.coordinate
    }
}
