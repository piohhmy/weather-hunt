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
    
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet var drawerView: UIView!
    @IBOutlet weak var datePicker: DatePicker!
    @IBAction func dateChanged(_ sender: Any) {
        delegate?.dateChanged(newDate: Date(), atIndex: datePicker.selectedSegmentIndex)
        updateLabels()
    }
    var currentForecast: Forecast?
    var delegate: DatePickerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true
    
        //datePicker.adjustDatePickerSize()
        //registerForRotationEvents()
    }
    func collapsedDrawerHeight() -> CGFloat {
        return 60.0
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
            conditionLabel.text = weather.condition
            highTempLabel.text = "\(weather.tempHigh)°"
            lowTempLabel.text = "with low of \(weather.tempLow)°"
        }
        else {
            conditionLabel.text = "Not yet available"
            highTempLabel.text = ""
            lowTempLabel.text = ""
        }
    }
    
    func onNewForecast(_ forecast: Forecast) {
        datePicker.setup(with: forecast)
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
        updateLabels()
    }

    
    // Todo: test rotate
    func registerForRotationEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(datePicker.adjustDatePickerSize), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    
}
