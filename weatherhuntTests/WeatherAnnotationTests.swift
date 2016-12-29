//
//  ForecastTests.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/16/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import XCTest

import MapKit

class WeatherAnnotationTests: XCTestCase {
   
    func testInit_Valid_SetsTitleWithCondition() {
        let portland = CLLocationCoordinate2D(latitude: 45.5, longitude: -122.6)

        let weather = DailyWeather(tempHigh: 100, tempLow: 0, condition: "Snow", date: Date.init(), coordinate: portland)
        let annotation = WeatherAnnotation.init(fromDailyWeather: weather)
        
        XCTAssert(annotation.title == "Snow")
        
    }
    
}
