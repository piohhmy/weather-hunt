//
//  ViewController.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/2/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import UIKit
import MapKit
import Pulley

extension Date {
    func shortDayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self)
    }
    
    func shortDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: self)
    }
}

protocol ForecastDelegate {
    func onNewForecast(_ forecast: Forecast)
    func onSelectForecast(_ forecast: Forecast)
}

class ViewController: UIViewController, MGLMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, DatePickerDelegate {
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var forecastDelegate: ForecastDelegate?
    
    
    let badNetworkMsg = "Oops. No Network"
    let locationManager = CLLocationManager()
    var dateIndex: Int = 0

    
    @IBAction func touchRecognizer(_ sender: Any) {}

    @IBAction func clearMap(_ sender: Any) {
        if let annotations = mapView.annotations {
            let weatherAnnotations = annotations.flatMap { an in an as? WeatherAnnotation }
            mapView.removeAnnotations(weatherAnnotations)
            Analytics.sendEvent(category: "Map", action: "Clear", label: nil, value: nil)
            closeDrawer()
        }
    }
    
    func closeDrawer() {
        if let drawer = self.parent as? PulleyViewController{
            drawer.setDrawerPosition(position: .closed, animated: true)
        }
    }
    
    var loadingSubview : LoadingSubview!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isRotateEnabled = false

        self.setupUserLocation()
        self.setupTapRecognizer()
        self.loadingSubview = LoadingSubview(superview: self.view)
        //let portland = CLLocationCoordinate2D(latitude: 45.5, longitude: -122.6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Analytics.sendScreenName(value: "Map")
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadingSubview.updateSize()
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            self.loadingSubview.updateSize()
        }
    }

    
    func setupUserLocation() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            showUserLocation()
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func showUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
            mapView.showsUserLocation = true
        }
    }
    
    func dateChanged(newDate date: Date, atIndex index:Int) {
        Analytics.sendEvent(category: "Map", action: "Change Date", label: nil, value: nil)
        self.dateIndex = index
        if let annotations = mapView.annotations {
            let oldAnnotations = annotations.flatMap { $0 as? WeatherAnnotation }
            oldAnnotations.forEach {
                $0.switchTo(day: dateIndex)
                if let weatherView = mapView.view(for: $0) as? WeatherAnnotationView {
                    weatherView.update(with: $0)
                }
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        showUserLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            print("Users Location at \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
            mapView.setCenter(currentLocation.coordinate, zoomLevel: 7, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Could not get user location: \(error.localizedDescription)")
    }
        
    func setupTapRecognizer() {
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.handleTap))
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.delegate = self
        mapView.addGestureRecognizer(singleTapRecognizer)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action:nil)
        doubleTapRecognizer.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTapRecognizer)
        
        singleTapRecognizer.require(toFail: doubleTapRecognizer)
    }
    
    
    func onReceiveForecast(err: String?, forecast: Forecast?) {
        defer {
            DispatchQueue.main.async {
                self.loadingSubview.stopAnimating()
            }
        }
        if let forecast = forecast {
            let annotation = WeatherAnnotation(from: forecast, on: self.dateIndex)
            
            DispatchQueue.main.async {
                self.forecastDelegate?.onNewForecast(forecast)
                self.headerLabel.text = "Tap For Weather"
                self.mapView.addAnnotation(annotation)
            }
        }
        else if let err = err {
            var msg: String
            if(!Reachability.isConnectedToNetwork()) {
                msg = badNetworkMsg
            }
            else {
                print(err)
                msg = "Oops. Weather not available"
                Analytics.sendEvent(category: "Map", action: "Display", label: msg, value: nil)
            }
            DispatchQueue.main.async {
                self.headerLabel.text = msg
            }
        }
    }
    
      
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            Analytics.sendEvent(category: "Map", action: "Tap", label: "New Forecast", value: nil)
            let location = sender.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
            self.loadingSubview.startAnimating()
            getWeatherFor(coord: coordinate, completion: self.onReceiveForecast)
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        if let annotations = mapView.annotations {
            let weatherAnnotations = annotations.flatMap({$0 as? WeatherAnnotation})
            for targetAn: WeatherAnnotation in weatherAnnotations  {
                for otherAn: WeatherAnnotation in weatherAnnotations {
                    if targetAn.isOverlapping(other: otherAn, on: mapView){
                        mapView.removeAnnotation(otherAn)
                    }
                }
            }

        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let weatherView = touch.view as? WeatherAnnotationView {
            Analytics.sendEvent(category: "Map", action: "Tap", label: "Existing Forecast", value: nil)
            print("Ignore tap on existing annotation")
            self.forecastDelegate?.onSelectForecast(weatherView.weatherAnnotation!.forecast)
            return false
        }
        return true
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
    
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        if let weatherAnnotation = annotation as? WeatherAnnotation {
            let annotationIdentifier = "weather-annotation"
            // TODO: Test reusable annotation views
            if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? WeatherAnnotationView {
                existingView.update(with: weatherAnnotation)
                return existingView
            } else {
                let newView = WeatherAnnotationView.init(annotation: weatherAnnotation, reuseIdentifier: annotationIdentifier)
                return newView
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, didAdd views: [MGLAnnotationView]) {
        if let annotation = views[0].annotation {
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        
    }
}

