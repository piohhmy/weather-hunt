//
//  WeatherAnnotationView.swift
//  weatherhunt
//
//  Created by Danny Varner on 1/7/17.
//  Copyright © 2017 Danny Varner. All rights reserved.
//

import Foundation

class WeatherAnnotationView: MGLAnnotationView {
    var weatherAnnotation: WeatherAnnotation?
    var iconSubview: UIImageView?

    init(annotation:WeatherAnnotation, reuseIdentifier:String) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.weatherAnnotation = annotation
        let maxAlpha: CGFloat = 0.25
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        backgroundColor = UIColor.gray.withAlphaComponent(maxAlpha)
        layer.borderWidth = 2
        layer.cornerRadius = frame.width / 2
        layer.borderColor = UIColor.white.cgColor
        
        //layer.borderColor = UIColor.white.withAlphaComponent(maxAlpha).cgColor


        iconSubview = UIImageView.init()
        iconSubview?.contentMode = UIViewContentMode.scaleAspectFit
        iconSubview?.frame = CGRect(x: 0, y: 0, width: 24, height: 20)
        iconSubview?.center = self.convert(self.center, from: iconSubview)

        self.addSubview(iconSubview!)

        update(with: annotation)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func update(with newAnnotation: WeatherAnnotation) {
       
        if(newAnnotation.isViewable) {
            self.isHidden = false
            if (iconSubview?.image != newAnnotation.image) {
                iconSubview?.image = newAnnotation.image
                animateChangedIcon()

            }
        }
        else {
            print("annotation not available for \(newAnnotation.coordinate)")
            self.isHidden = true
        }
        weatherAnnotation = newAnnotation

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        NSLog("Selected!")
        super.setSelected(selected, animated: animated)

        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? 5 : 2
        layer.add(animation, forKey: "borderWidth")
        
        animateSelectedIcon()
    }
    
    func animateSelectedIcon() {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0),
                       initialSpringVelocity: CGFloat(0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: { self.iconSubview?.transform = self.isSelected ? CGAffineTransform(scaleX: 1.0, y: 1.0) : CGAffineTransform(scaleX: 0.8, y: 0.8) },
                       completion: { (finished: Bool) in }
        )
    }
    
    func animateChangedIcon() {
        iconSubview?.transform = self.isSelected ? CGAffineTransform(scaleX: 1.2, y: 1.2) : CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.animate(withDuration: 1.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.30),
                           initialSpringVelocity: CGFloat(8.0),
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: { self.iconSubview?.transform = self.isSelected ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.8, y: 0.8)},
                           completion: { (finished: Bool) in }
            )
    }
        
}
