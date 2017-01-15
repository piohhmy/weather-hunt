//
//  DatePicker.swift
//  weatherhunt
//
//  Created by Danny Varner on 1/8/17.
//  Copyright © 2017 Danny Varner. All rights reserved.
//

import Foundation


class DatePicker: UISegmentedControl {
    func setup(with forecast: Forecast) {
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 2
        
        for day in 0...6 {
            if let weather = try? forecast.on(day: day) {
                if self.numberOfSegments <= day {
                    self.insertSegment(withTitle: "", at: day, animated: false)
                    
                }
                self.setTitle("\(weather.date.shortDayOfTheWeek()!)\n\(weather.date.shortDate()!)", forSegmentAt: day)
            }
        }
        
        adjustDatePickerSize()
        self.isHidden = false
    }
    
    func adjustDatePickerSize() {
        let segments = self.numberOfSegments
        for day in 0...segments-1 {
            
            self.setWidth(self.bounds.size.width/CGFloat(segments), forSegmentAt: day)
        }
        
        // Labels don't seem to get proper bounding frame with multiline strings in SegmentedControl, set manually
        //let font = UIFont(name: "HelveticaNeue-Thin", size: 14)

        //self.setTitleTextAttributes([NSFontAttributeName: font!], for: .normal)

        for segment in self.subviews {
            for subview in segment.subviews {
                if let titleLabel = subview as? UILabel {
                    titleLabel.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(97), height: CGFloat(50))
                }
            }
        }
    }
    
}
