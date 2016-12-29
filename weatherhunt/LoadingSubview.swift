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
        self.frame = superview.frame
        self.center = superview.center
        superview.addSubview(self)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
