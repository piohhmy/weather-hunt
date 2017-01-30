//
//  WeatherAnnotation.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/17/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import Foundation
import UIKit
import Mapbox


class WeatherAnnotation: MGLPointAnnotation {
    var image:UIImage? = nil
    let forecast:Forecast
    var isViewable : Bool {
        return self.image != nil
    }
    
    init(from forecast: Forecast, on day: Int) {
        self.forecast = forecast
        super.init()
        self.coordinate = forecast.location
        
        self.switchTo(day: day)
    }
    
    
    func switchTo(day: Int)  {
        if let weather = try? forecast.on(day: day) {
            self.image = weather.imageSmall
            self.title = weather.condition ?? ""
            let high = (weather.tempHigh != nil) ? String(weather.tempHigh!) : ""
            let low = (weather.tempLow != nil) ? String(weather.tempLow!) : ""
            self.subtitle = "High: \(high) Low: \(low)"
            if (self.image == nil) {
                Analytics.sendException(description: "No image for \(weather.condition)", isFatal: false)
            }
        }
        else {
            self.image = nil
            self.title = ""
            self.subtitle = ""
        }
    }
    
    func isOverlapping(other annotation: WeatherAnnotation, on mapView: MGLMapView) -> Bool{
        if let anView1 = mapView.view(for: self) {
            if let anView2 = mapView.view(for: annotation) {
                let annotationPoint1 = CGPoint.init(x: anView1.frame.midX, y: anView1.frame.midY)
                let annotationPoint2 = CGPoint.init(x: anView2.frame.midX, y: anView2.frame.midY)
                return isOverlapping(p1: annotationPoint1, p2: annotationPoint2) && anView1 != anView2
            }
        }
        return false
    }
    
    func isOverlapping(with point: CGPoint, on mapView: MGLMapView) -> Bool {
        if let anView = mapView.view(for: self) {
            let annotationPoint = CGPoint.init(x: anView.frame.midX, y: anView.frame.midY)
            return isOverlapping(p1: annotationPoint, p2: point)
        }
        return false
    }
    
    func isOverlapping(p1: CGPoint, p2: CGPoint) -> Bool {
        let dist: CGFloat =  hypot((p1.x - p2.x), (p1.y - p2.y))
        return dist <= 20
    }

}
