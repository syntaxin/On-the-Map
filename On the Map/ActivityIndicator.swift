//
//  ActivityIndicator.swift
//  On the Map
//
//  Created by Enrico Montana on 8/19/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import UIKit

public class ActivityProgress {
    
    var containerView = UIView()
    var progressView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    public class var shared: ActivityProgress {
        struct Static {
            static let instance: ActivityProgress = ActivityProgress()
        }
        return Static.instance
    }
    
    public func showProgressView(view: UIView) {
        containerView.frame = view.frame
        containerView.center = view.center
        containerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.50)
        
        progressView.frame = CGRectMake(0, 0, 80, 80)
        progressView.center = view.center
        progressView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = CGPointMake(progressView.bounds.width / 2, progressView.bounds.height / 2)
        
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        view.addSubview(containerView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideProgressView() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}