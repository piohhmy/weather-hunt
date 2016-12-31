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
        let fixture = ForecastTests().createWeatherProxyFixture()
        let forecast = try! Forecast.init(fromWeatherProxy: fixture!)

        let annotation = WeatherAnnotation.init(from: forecast, on: 0)
        
        XCTAssert(annotation.title == "Increasing Clouds")
        
    }
    
}
