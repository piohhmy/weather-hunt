//
//  ViewController.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/2/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import UIKit
import MapKit

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


class ViewController: UIViewController, MGLMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var datePicker: UISegmentedControl!
    @IBAction func dateChanged(_ sender: Any) {
        Analytics.sendEvent(category: "Map", action: "Change Date", label: nil, value: nil)
        if let annotations = mapView.annotations {
            let oldAnnotations = annotations.flatMap { $0 as? WeatherAnnotation }
            let newAnnotations = oldAnnotations.map { $0.switchTo(day: datePicker.selectedSegmentIndex) }
            mapView.removeAnnotations(oldAnnotations)
            mapView.addAnnotations(newAnnotations)
        }
    }
    let badNetworkMsg = "Oops. No Network"
    let locationManager = CLLocationManager()

    
    @IBAction func touchRecognizer(_ sender: Any) {}

    @IBAction func clearMap(_ sender: Any) {
        if let annotations = mapView.annotations {
            let weatherAnnotations = annotations.flatMap { an in an as? WeatherAnnotation }
            mapView.removeAnnotations(weatherAnnotations)
            Analytics.sendEvent(category: "Map", action: "Clear", label: nil, value: nil)
        }
        
       
    }
    var loadingSubview : LoadingSubview!

    override func viewDidLoad() {
        super.viewDidLoad()
        if (!Reachability.isConnectedToNetwork()) {
            headerLabel.text = badNetworkMsg
            Analytics.sendEvent(category: "Map", action: "Display", label: badNetworkMsg, value: nil)
        }
        registerForRotationEvents()

        datePicker.isHidden = true
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
        adjustDatePickerSize()
        self.loadingSubview.updateSize()
        super.viewDidAppear(animated)
        
    }
    
    func registerForRotationEvents() {
         NotificationCenter.default.addObserver(self, selector: #selector(ViewController.adjustDatePickerSize), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
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
    
    
    func setupDatePicker(for forecast: Forecast) {
        datePicker.isHidden = false
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 2
        
        for day in 0...6 {
            if let weather = try? forecast.on(day: day) {
                if datePicker.numberOfSegments <= day {
                    datePicker.insertSegment(withTitle: "", at: day, animated: true)
                }
                datePicker.setTitle("\(weather.date.shortDayOfTheWeek()!)\n\(weather.date.shortDate()!)", forSegmentAt: day)
            }
        }
        
        adjustDatePickerSize()
        datePicker.isHidden = false
    }
    
    func adjustDatePickerSize() {
        let segments = datePicker.numberOfSegments
        for day in 0...segments-1 {
            datePicker.setWidth(self.view.bounds.size.width/CGFloat(segments), forSegmentAt: day)
        }
        
        // Labels don't seem to get proper bounding frame with multiline strings in SegmentedControl, set manually
        for segment in self.datePicker.subviews {
            for subview in segment.subviews {
                if let titleLabel = subview as? UILabel {
                    titleLabel.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(97), height: CGFloat(50))
                }
            }
        }
    }
    
    func onReceiveForecast(err: String?, forecast: Forecast?) {
        defer {
            DispatchQueue.main.async {
                self.loadingSubview.stopAnimating()
            }
        }
        if let forecast = forecast {
            let annotation = WeatherAnnotation(from: forecast, on: datePicker.selectedSegmentIndex)
            
            DispatchQueue.main.async {
                self.headerLabel.text = "Tap For Weather"
                self.setupDatePicker(for: forecast)
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
        if (touch.view as? MGLAnnotationView) != nil {
            Analytics.sendEvent(category: "Map", action: "Tap", label: "Existing Forecast", value: nil)
            print("Ignore tap on existing annotation")
            return false
        }
        else {
            let p = touch.location(in: mapView)
            if let annotations = mapView.annotations {
                for annotation: MGLAnnotation in annotations {
                    if let weatherAnnotation = annotation as? WeatherAnnotation {
                        if weatherAnnotation.isOverlapping(with: p, on: mapView) {
                            print("Ignore tap nearby existing annotation")
                            Analytics.sendEvent(category: "Map", action: "Tap", label: "Existing Forecast", value: nil)
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        if let weatherAnnotation = annotation as? WeatherAnnotation {
            let annotationIdentifier = "weather-annotation"
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
        let weatherAns = views.flatMap { view in view.annotation as? WeatherAnnotation }
        if(weatherAns.count > 0) {
            mapView.selectAnnotation(weatherAns[0], animated: true)
        }
    }
}

