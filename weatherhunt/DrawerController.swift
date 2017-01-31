//
//  DrawerController.swift
//  weatherhunt
//
//  Created by Danny Varner on 1/8/17.
//  Copyright © 2017 Danny Varner. All rights reserved.
//

import Foundation
import Pulley


protocol DatePickerDelegate {
    func dateChanged(newDate date:Date, atIndex index:Int)
}

class DrawerController: UIViewController, ForecastDelegate, PulleyDrawerViewControllerDelegate {    
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet var drawerView: UIView!
    @IBOutlet weak var datePicker: UISegmentedControl!
    @IBAction func dateChanged(_ sender: Any) {
        delegate?.dateChanged(newDate: Date(), atIndex: datePicker.selectedSegmentIndex)
        updateLabels()
    }
    var currentForecast: Forecast?
    var delegate: DatePickerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 2
        
    }
    func collapsedDrawerHeight() -> CGFloat {
        return 66.0
    }
    func partialRevealDrawerHeight() -> CGFloat{
        return 200.0
    }
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [
            PulleyPosition.collapsed,
            PulleyPosition.partiallyRevealed,
            PulleyPosition.closed]
    }

    func updateLabels() {
        if let weather = try? currentForecast!.on(day: datePicker.selectedSegmentIndex) {
            conditionLabel.text = (weather.condition != nil) ? "\(weather.condition!)" : "Conditions Unknown"
            highTempLabel.text =  (weather.tempHigh != nil) ? "\(weather.tempHigh!)°" : "n/a"
            lowTempLabel.text =  (weather.tempLow != nil) ? "\(weather.tempLow!)°" : "n/a"
            conditionImage.image = weather.imageLarge
            conditionImage.isHidden = false

        }
        else {
            conditionLabel.text = "weather not found"
            highTempLabel.text = "Sorry,"
            lowTempLabel.text = ""
            conditionImage.isHidden = true
        }
    }
    
    func onNewForecast(_ forecast: Forecast) {
        self.setupDatePicker(with: forecast)
        if let drawer = self.parent as? PulleyViewController
        {
            if drawer.drawerPosition != .partiallyRevealed {
             drawer.setDrawerPosition(position: .partiallyRevealed, animated: true)
            }
            currentForecast = forecast
            updateLabels()
        }

    }
    
    internal func onSelectForecast(_ forecast: Forecast) {
        currentForecast = forecast
        if let drawer = self.parent as? PulleyViewController
        {
            if drawer.drawerPosition != .partiallyRevealed {
                drawer.setDrawerPosition(position: .partiallyRevealed, animated: true)
            }
        }
        updateLabels()
    }
    
    func onDeselectForecast() {
        if let drawer = self.parent as? PulleyViewController
        {
            if drawer.drawerPosition == .partiallyRevealed {
                drawer.setDrawerPosition(position: .collapsed, animated: true)
            }
        }
        conditionLabel.text = ""
        highTempLabel.text = ""
        lowTempLabel.text = ""
        conditionImage.isHidden = true


    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            self.adjustDatePickerSize()
        }
    }
    
    func setupDatePicker(with forecast: Forecast) {
        
        for day in 0...6 {
            if let weather = try? forecast.on(day: day) {
                if datePicker.numberOfSegments <= day {
                    datePicker.insertSegment(withTitle: "", at: day, animated: false)
                    
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
            datePicker.setWidth(datePicker.bounds.size.width/CGFloat(segments), forSegmentAt: day)
        }
        
        // Labels don't seem to get proper bounding frame with multiline strings in SegmentedControl, set manually
        for segment in datePicker.subviews {
            for subview in segment.subviews {
                if let titleLabel = subview as? UILabel {
                    titleLabel.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(97), height: CGFloat(50))
                }
            }
        }
    }


    
}
