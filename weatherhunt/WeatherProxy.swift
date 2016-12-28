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
                completion(nil, try Forecast.init(fromWeatherProxy: json))
            }
            else {
                completion("error in JSONSerialization", nil)
            }
        } catch {
            completion("error in JSONSerialization", nil)
            }
        }.resume()
}