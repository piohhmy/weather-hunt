//
//  weatherproxy.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/2/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import Foundation
import MapKit



func getWeatherFor(coord: CLLocationCoordinate2D, completion: @escaping (_ err: String?, _ forecast: Forecast? ) -> Void) {
    let startTime = DispatchTime.now()
    let base = "https://bh6cj0clm5.execute-api.us-west-2.amazonaws.com/"
    let resource = "dev/weather/forecast"
    let queryparams = "?lat=\(coord.latitude)&lng=\(coord.longitude)"
    var request = URLRequest(url: URL(string: base+resource+queryparams)!)
    request.httpMethod = "GET"
    let session = URLSession.shared
    print(request)
    
    session.dataTask(with: request) {
        data, response, error in

        if error != nil {
            completion(error!.localizedDescription, nil)
            return
        }

        do {
            guard let data = data else {
                completion("Data is empty", nil)
                return
            }
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [Any] {
                let forecast = try Forecast.init(fromWeatherProxy: json, overrideCoodinateWith: coord)
                if(forecast.availableDays>0) {
                    completion(nil, forecast)
                    let endTime = DispatchTime.now()
                    let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                    let milliTime = NSNumber(value: Int(Double(nanoTime) / 1_000_000))
                    Analytics.sendTimeEvent(category: "Map", interval: milliTime, name: "Forecast Load Time", label: nil)
                }
                else {
                    completion("No weather found", nil)
                }
            }
            else {
                completion("error in JSONSerialization", nil)
            }
        } catch {
            completion("error in JSONSerialization", nil)
            }
        }.resume()
}
