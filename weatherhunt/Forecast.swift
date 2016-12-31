//
//  Forecast.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/16/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import Foundation
import MapKit

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

enum ForecastError: Error {
    case NoWeatherAvailable
}


class Forecast {
    
    var calculatedOn = Date.init();
    var location: CLLocationCoordinate2D
    private var dailyWeather: [DailyWeather] = []
    
    var startDate: Date? {
        return try? self.on(day: 0).date
    }
    
    var availableDays: Int {
        return dailyWeather.count
    }
    
    init(fromWeatherProxy response:[Any]) throws {
        guard let jsonObj = response.first as? [String: Any] else {
         throw SerializationError.missing("forecast")
        }
        guard let coordinatesJSON = jsonObj["coordinates"] as? [String: String],
            let latitude = CLLocationDegrees(coordinatesJSON["lat"]!),
            let longitude = CLLocationDegrees(coordinatesJSON["lng"]!)
            else {
                throw SerializationError.missing("coordinates")
        }
        
        guard case (-90...90, -180...180) = (latitude, longitude) else {
            throw SerializationError.invalid("coordinates", (latitude, longitude))
        }
        self.location = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)

        
        var forecasts: [DailyWeather] = []

        guard let dailyWeather = jsonObj["daily_weather"] as? [String: Any] else {
            throw SerializationError.missing("daily_weather")
        }
        
        for (day, weather) in dailyWeather {
            let dateStr = day
            guard let weatherDetails = weather as? [String: Any] else {
                throw SerializationError.missing("daily_weather")
            }
            guard let tempHigh = weatherDetails["high"] as? Int,
                let tempLow = weatherDetails["low"] as? Int,
                let condition = weatherDetails["condition"] as? String
                else {
                    throw SerializationError.missing("daily_weather entry")
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateStr) else {
                throw SerializationError.invalid("date", dateStr)
            }
            forecasts.append(DailyWeather.init(tempHigh: tempHigh, tempLow: tempLow, condition: condition, date: date, coordinate:self.location))
        }
        self.dailyWeather = forecasts.sorted{ $0.date < $1.date}
    }
    
    func on(day:Int) throws -> DailyWeather {
        guard day < dailyWeather.count else {
            throw ForecastError.NoWeatherAvailable
        }
        return dailyWeather[day]
    }
    
}
