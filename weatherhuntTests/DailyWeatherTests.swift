//
//  DailyWeatherTests.swift
//  weatherhunt
//
//  Created by Danny Varner on 5/6/17.
//  Copyright © 2017 Danny Varner. All rights reserved.
//

import Foundation
import XCTest


class DailyWeatherTests: XCTestCase {
    
    func testDailyWeather_lookupValidIcon() {
        let dailyWeather = DailyWeather.init(tempHigh: 1, tempLow: 1, condition: "Sunny", date: Date.init(), coordinate: CLLocationCoordinate2D.init())
        XCTAssertTrue(dailyWeather.imgFound)
        XCTAssertEqual(#imageLiteral(resourceName: "Sun"), dailyWeather.imageSmall)
        XCTAssertEqual(#imageLiteral(resourceName: "Sun-big"),dailyWeather.imageLarge)
    }
    
    func testDailyWeather_ignoreCompoundForecasts() {
        let dailyWeather = DailyWeather.init(tempHigh: 1, tempLow: 1, condition: "Rain And Snow", date: Date.init(), coordinate: CLLocationCoordinate2D.init())
        XCTAssertTrue(dailyWeather.imgFound)
        XCTAssertEqual(#imageLiteral(resourceName: "Cloud-Rain"), dailyWeather.imageSmall)
        XCTAssertEqual(#imageLiteral(resourceName: "Cloud-Rain-big"),dailyWeather.imageLarge)
    }
}
