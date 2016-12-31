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


class ViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var datePicker: UISegmentedControl!
    @IBOutlet weak var  mapView: MKMapView!
    @IBAction func dateChanged(_ sender: Any) {
        for an in mapView.annotations {
            if let an = an as? WeatherAnnotation {
                an.switchTo(day: datePicker.selectedSegmentIndex)
                if let view = mapView.view(for: an) {
                    update(annoationView: view, with: an)
                }
            }
        }
    }
    @IBAction func touchRecognizer(_ sender: Any) {}

    @IBAction func clearMap(_ sender: Any) {
        let weatherAnnotations = mapView.annotations.flatMap { an in an as? WeatherAnnotation }
        mapView.removeAnnotations(weatherAnnotations)
    }
    var loadingSubview : LoadingSubview!

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true
        mapView.delegate = self
        mapView.isRotateEnabled = false
        self.setupTapRecognizer()
        self.loadingSubview = LoadingSubview(superview: self.view)
        //let portland = CLLocationCoordinate2D(latitude: 45.5, longitude: -122.6)
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
                datePicker.setWidth(self.view.bounds.size.width/CGFloat(forecast.availableDays), forSegmentAt: day)
            }
        }
        
        // Labels don't seem to get proper bounding frame with multiline strings in SegmentedControl, set manually
        for segment in self.datePicker.subviews {
            for subview in segment.subviews {
                if let titleLabel = subview as? UILabel {
                    titleLabel.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(97), height: CGFloat(50))
                }
            }
        }
        
        datePicker.isHidden = false
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
                self.setupDatePicker(for: forecast)
                self.mapView.addAnnotation(annotation)
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
    
    func update(annoationView view: MKAnnotationView, with annotation: WeatherAnnotation) {
        view.annotation = annotation
        if(annotation.isViewable) {
            view.image = annotation.image
            view.isHidden = false
        }
        else {
            print("annotation not available for \(annotation.coordinate)")
            view.isHidden = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let weatherAnnotation = annotation as? WeatherAnnotation {
            let annotationIdentifier = "weather-annotation"
            if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
                update(annoationView: existingView, with: weatherAnnotation)
                return existingView
            } else {
                let newView = MKAnnotationView.init(annotation: weatherAnnotation, reuseIdentifier: annotationIdentifier)
                newView.canShowCallout = true
                update(annoationView: newView, with: weatherAnnotation)
                return newView
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let weatherAns = views.flatMap { view in view.annotation as? WeatherAnnotation }
        if(weatherAns.count > 0) {
            mapView.selectAnnotation(weatherAns[0], animated: true)
        }
    }
}

