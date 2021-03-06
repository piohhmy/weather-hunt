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
    
    init(fromWeatherProxy response:[Any], overrideCoodinateWith coord:CLLocationCoordinate2D?=nil) throws {
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
        self.location = coord != nil ? coord! : CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        
        var forecasts: [DailyWeather] = []

        guard let dailyWeather = jsonObj["daily_weather"] as? [Any] else {
            throw SerializationError.missing("daily_weather")
        }
        
        for (index, day) in dailyWeather.enumerated() {
            guard let weatherDetails = day as? [String: Any] else {
                throw SerializationError.missing("daily_weather")
            }
            guard let dateStr = weatherDetails["date"] as? String else {
                throw SerializationError.missing("date")
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateStr) else {
                throw SerializationError.invalid("date", dateStr)
            }

            let tempHigh = weatherDetails["high"] as? Int
            let tempLow = weatherDetails["low"] as? Int
            let condition = weatherDetails["condition"] as? String
            
            if (tempHigh == nil) {
                reportMissing("high", atIndex: index)
            }
            if (tempLow == nil) {
                reportMissing("low", atIndex: index)
            }
            if (condition == nil) {
                reportMissing("condition", atIndex: index)
            }
            
            
            let dailyWeather = DailyWeather.init(tempHigh: tempHigh, tempLow: tempLow, condition: condition, date: date, coordinate:self.location)
            if let cond = condition {
                if !dailyWeather.imgFound  {
                    Analytics.sendException(description: "No image for \(cond)", isFatal: false)
                }
            }
            
            forecasts.append(dailyWeather)
        }
        self.dailyWeather = forecasts.sorted{ $0.date < $1.date}
    }
    
    func reportMissing(_ dataPoint: String, atIndex index: Int) {
        Analytics.sendEvent(category: "API", action: "Missing Data Point", label: "\(dataPoint)-\(index)", value: nil)
    }
    
    func on(day:Int) throws -> DailyWeather {
        guard day < dailyWeather.count else {
            throw ForecastError.NoWeatherAvailable
        }
        return dailyWeather[day]
    }
    
}
