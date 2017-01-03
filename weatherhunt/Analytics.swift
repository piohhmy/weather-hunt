//
//  Analytics.swift
//  weatherhunt
//
//  Created by Danny Varner on 1/2/17.
//  Copyright © 2017 Danny Varner. All rights reserved.
//

import Foundation


class Analytics {
    static var tracker : GAITracker? = nil
    
    static func setup() {
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        if let gai = GAI.sharedInstance() {
            gai.trackUncaughtExceptions = true 
            //gai.logger.logLevel = GAILogLevel.verbose  // remove before app release
        }
        
        self.tracker = GAI.sharedInstance().defaultTracker
    }
    
    static func sendEvent(category: String, action: String, label: String?, value: NSNumber?) {
        _send(event: GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: value))
    }
    
    static func sendTimeEvent(category: String, interval: NSNumber, name: String, label: String?) {
        _send(event: GAIDictionaryBuilder.createTiming(withCategory: category, interval: interval, name: name, label: label))
    }
    
    static func sendScreenName(value: String) {
        _send(event: GAIDictionaryBuilder.createScreenView())
        if let tracker = tracker {
            tracker.set(kGAIScreenName, value: value)
        }
    }
    
    static func sendException(description: String, isFatal: Bool) {
        let withFatal = NSNumber(value: isFatal)
        _send(event: GAIDictionaryBuilder.createException(withDescription: description, withFatal: withFatal))
    }
    
    private static func _send(event: GAIDictionaryBuilder) {
        if let tracker = tracker {
            tracker.send(event.build() as [NSObject : AnyObject])
        }
    }
}
