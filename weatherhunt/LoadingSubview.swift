//
//  LoadingSubview.swift
//  weatherhunt
//
//  Created by Danny Varner on 12/28/16.
//  Copyright © 2016 Danny Varner. All rights reserved.
//

import Foundation
import UIKit

class LoadingSubview : UIActivityIndicatorView {
    init(superview: UIView) {
        super.init(activityIndicatorStyle: .whiteLarge)
        self.layer.backgroundColor = UIColor(white: CGFloat(0.0), alpha: CGFloat(0.30)).cgColor
        self.hidesWhenStopped = true
        self.isUserInteractionEnabled = false
        superview.addSubview(self)
        self.updateSize()

        registerForRotationEvents()
    }
    
    func registerForRotationEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateSize), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func updateSize() {
        if let superview = self.superview {
            self.frame = superview.frame
            self.center = superview.center
        }
    }
    
    override func startAnimating() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        super.startAnimating()
    }
    
    override func stopAnimating() {
        UIApplication.shared.endIgnoringInteractionEvents()

        super.stopAnimating()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
