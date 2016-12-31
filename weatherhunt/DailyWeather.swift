//
//  DailyWeather.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/17/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import Foundation
import MapKit

struct DailyWeather {
    let tempHigh: Int
    let tempLow: Int
    let condition: String
    let date: Date
    let coordinate: CLLocationCoordinate2D
}
