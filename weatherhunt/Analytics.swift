//
//  Analytics.swift
//  weatherhunt
//
//  Created by Danny Varner on 1/2/17.
//  Copyright © 2017 Danny Varner. All rights reserved.
//

import Foundation


func sendEvent(withCategory: String, action: String, label: String?, value: NSNumber?) {
    if let tracker = GAI.sharedInstance().defaultTracker {
        let builder: NSObject = GAIDictionaryBuilder.createEvent(
            withCategory: withCategory,
            action: action,
            label: label,
            value: value).build()
        tracker.send(builder as! [NSObject : AnyObject])
    } else {
        print("Google Analytics tracker not available")
    }
}


func sendTimeEvent(withCategory: String, interval: NSNumber, name: String, label: String?) {
    if let tracker = GAI.sharedInstance().defaultTracker {
        let builder: NSObject = GAIDictionaryBuilder.createTiming(withCategory: withCategory, interval: interval, name: name, label: label).build()
        tracker.send(builder as! [NSObject : AnyObject])
    } else {
        print("Google Analytics tracker not available")
    }
}

func sendScreenName(value: String) {
    if let tracker = GAI.sharedInstance().defaultTracker {
        tracker.set(kGAIScreenName, value: value)
        if let builder = GAIDictionaryBuilder.createScreenView() {
            tracker.send(builder.build() as [NSObject : AnyObject])
        }
    }
}

func sendException(withDescription: String, isFatal: Bool) {
    
    if let tracker = GAI.sharedInstance().defaultTracker {
        let builder: NSObject = GAIDictionaryBuilder.createException(withDescription: withDescription, withFatal: NSNumber(value: isFatal)).build()
        tracker.send(builder as! [NSObject : AnyObject])
    } else {
        print("Google Analytics tracker not available")
    }
}
