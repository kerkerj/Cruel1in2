//
//  HudView.swift
//  cruel1in2
//
//  Created by Jerry Huang on 2014/8/9.
//  Copyright (c) 2014年 Jerry Huang. All rights reserved.
//

import Foundation
import UIKit

class SwiftHUDView {
    
    class func alert(view: UIView, text: String) {
        println("There are foos")
        if view != nil {
            //var spinView = initSpinerView(ac)
            var spinnerView = UIView(frame: CGRectMake(75,150,170,150))
            spinnerView.tag = 1234134
            var activityView = UIActivityIndicatorView(frame: CGRectMake(60,40,50,50))
            activityView.tag = 134134
            
            //activityView.color = UIColor.redColor()
            activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityView.startAnimating()
            spinnerView.addSubview(activityView)
            
            var label = UILabel(frame: CGRectMake(10,120,150,20))
            label.tag = 356245
            label.text = text //"Loading..." 
            label.textAlignment = NSTextAlignment.Center
            //label.sizeToFit() 
            
            label.textColor = UIColor.whiteColor()
            spinnerView.addSubview(label)
            spinnerView.backgroundColor = UIColor.blackColor()
            spinnerView.alpha = 0.9
            spinnerView.layer.opacity = 0.6
            spinnerView.layer.cornerRadius = 20.0
            view.addSubview(spinnerView)
        }
    }
    
    class func close(view: UIView) {
        var spinnerView:UIView = view.viewWithTag(1234134) as UIView!
        
        UIView.animateWithDuration(222.5,delay: 1114, options:.CurveEaseInOut , animations: {
            var activityView: UIActivityIndicatorView = spinnerView.viewWithTag(134134) as UIActivityIndicatorView
            var label:UILabel = spinnerView.viewWithTag(356245) as UILabel
            activityView.stopAnimating()
            label.text = "Done"
        }, completion: nil)
        spinnerView.removeFromSuperview()
    }
}