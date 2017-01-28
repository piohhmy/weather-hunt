//
//  ForecastTests.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/16/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import XCTest

import MapKit

class ForecastTests: XCTestCase {
    func createWeatherProxyFixture(resource: String = "weatherProxyTestFixture") -> [Any]? {
        let bundle = Bundle(for: type(of: self));
        let fileUrl = bundle.url(forResource: resource, withExtension: "json")
        do {
            let data = try Data(contentsOf: fileUrl!)
            if let jsonData = try JSONSerialization.jsonObject(with: data) as? [Any] {
                return jsonData
            }
        } catch {
            print("Could not open test fixture")
        }
        return nil;
    }
    
    func testCalculatedOn_SetToCurrentDay() {
        let forecast = try! Forecast(fromWeatherProxy: createWeatherProxyFixture()!)
        XCTAssert(Calendar.current.isDateInToday(forecast.calculatedOn))
    }
    
    func testLocation_DerivedFromLatLngInJson() {
        let forecast = try! Forecast(fromWeatherProxy: createWeatherProxyFixture()!)
        XCTAssert(type(of: forecast.location) == CLLocationCoordinate2D.self)
    }
    
    func testOnDay_validDay_ReturnsDailyWeatherWithCorrectCondition() {
        let forecast = try! Forecast(fromWeatherProxy: createWeatherProxyFixture()!)
        let weather = try! forecast.on(day: 0)
        XCTAssert(weather.condition == "Increasing Clouds")
    }
    
    func testOnDay_validDay_ReturnsDailyWeatherWithCorrectTemps() {
        let forecast = try! Forecast(fromWeatherProxy: createWeatherProxyFixture()!)
        let weather = try! forecast.on(day: 0)
        XCTAssert(weather.tempHigh == 32)
        XCTAssert(weather.tempLow == 16)
        
    }
    
    func testOnDay_validDay_ReturnsDailyWeatherWithCorrectDate() {
        let forecast = try! Forecast(fromWeatherProxy: createWeatherProxyFixture()!)
        let weather = try! forecast.on(day: 0)
        
        let userCalendar = Calendar.current
        var comp = DateComponents()
        comp.year = 2016
        comp.month = 12
        comp.day = 16
        let expectedDate = userCalendar.date(from: comp)!
        
        XCTAssert(weather.date == expectedDate)
    }
    
    func testStartDate_forecastExists_ReturnsFirstDayOfForecast() {
        let forecast = try! Forecast(fromWeatherProxy: createWeatherProxyFixture()!)
        let userCalendar = Calendar.current
        var comp = DateComponents()
        comp.year = 2016
        comp.month = 12
        comp.day = 16
        let expectedDate = userCalendar.date(from: comp)!
        XCTAssert(forecast.startDate == expectedDate)
    }
    
    func testStartDate_forecastDoesNotExist_ReturnsNull() {
        let forecast = try! Forecast(fromWeatherProxy: createWeatherProxyFixture(resource: "weatherProxyEmptyTestFixture")!)
        XCTAssert(forecast.startDate == nil)
    }
    
    func testAvailableDays_forecast6days_returns6() {
        let forecast = try! Forecast(fromWeatherProxy: createWeatherProxyFixture()!)
        XCTAssert(forecast.availableDays == 6)
    }
    
    func testAvailableDays_forecast0days_returns0() {
        let forecast = try! Forecast(fromWeatherProxy: createWeatherProxyFixture(resource: "weatherProxyEmptyTestFixture")!)
        XCTAssert(forecast.availableDays == 0)
    }
    
    func testOnDay_nullHighValue_returnsDailyWeatherWithEmptyHigh() {
        let forecast = try! Forecast(fromWeatherProxy: createWeatherProxyFixture(resource: "weatherProxyNullHighTestFixture")!)
        XCTAssert(forecast.availableDays == 6)
    }
    
}
