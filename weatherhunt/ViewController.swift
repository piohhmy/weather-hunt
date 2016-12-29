//
//  ViewController.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/2/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    @IBAction func touchRecognizer(_ sender: Any) {}
    @IBOutlet weak var  mapView: MKMapView!
    var loadingSubview : LoadingSubview!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isRotateEnabled = false
        self.setupTapRecognizer()
        self.loadingSubview = LoadingSubview(superview: self.view)
        //let portland = CLLocationCoordinate2D(latitude: 45.5, longitude: -122.6)
    }
    
    func setupTapRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func onReceiveForecast(err: String?, forecast: Forecast?) {
        defer {
            DispatchQueue.main.async {
                self.loadingSubview.stopAnimating()
            }
        }
        if let forecast = forecast {
            do {
                let annotation = try WeatherAnnotation(fromDailyWeather: forecast.on(day: 0))
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation)

                }
            } catch ForecastError.NoWeatherAvailable{
                print("No weather found")
            } catch {
                print("Error")
            }
        }
    }
    
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
            self.loadingSubview.startAnimating()
            getWeatherFor(coord: coordinate, completion: self.onReceiveForecast)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let weatherAnnotations = mapView.annotations.flatMap({$0 as? WeatherAnnotation})
        for targetAn: WeatherAnnotation in weatherAnnotations  {
            for otherAn: WeatherAnnotation in weatherAnnotations {
                if targetAn.isOverlapping(other: otherAn, on: mapView){
                    mapView.removeAnnotation(otherAn)
                }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view as? MKAnnotationView) != nil {
            print("Ignore tap on existing annotation")
            return false
        }
        else {
            let p = touch.location(in: mapView)
            for annotation: MKAnnotation in mapView.annotations {
                if let weatherAnnotation = annotation as? WeatherAnnotation {
                    if weatherAnnotation.isOverlapping(with: p, on: mapView) {
                        print("Ignore tap nearby existing annotation")
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let weatherAnnotation = annotation as? WeatherAnnotation {
            let annotationIdentifier = "weather-annotation"
            if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
                existingView.annotation = annotation
                existingView.image = weatherAnnotation.image
                return existingView
            } else {
                let newView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: annotationIdentifier)
                newView.image = weatherAnnotation.image
                newView.canShowCallout = true
                return newView
            }
        }
        return nil
    }
}

