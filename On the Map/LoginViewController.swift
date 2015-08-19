//
//  LoginViewController.swift
//  On the Map
//
//  Created by Enrico Montana on 8/14/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.debugTextLabel.text = ""
        self.configureUI()
    }

/* Login to the app */
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        if usernameTextField.text.isEmpty {
            self.debugTextLabel.text = "Please enter a username"
        } else if passwordTextField.text.isEmpty {
            self.debugTextLabel.text = "Please enter a password"
        } else {
            ActivityProgress.shared.showProgressView(view)
            UdacityClient.sharedInstance().login(usernameTextField.text, password: passwordTextField.text, hostViewController: self) { (success, errorString) in
                if success {
                    dispatch_async(dispatch_get_main_queue(),{
                    self.completeLogin()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(),{
                    self.displayError(errorString)
                    })
                }
            }
        }
    }
    
    
/* Set up the Login UI to be a bit prettier */
    
    func configureUI() {
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 0.470, green: 0.592, blue: 0.933, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.216, green: 0.369, blue: 0.792, alpha: 1.0).CGColor
        var backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        /* Configure debug text label */
        debugTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 12)
        debugTextLabel.textColor = UIColor.whiteColor()
        
        }
  
 /* If login successful, continue onward function */
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            ActivityProgress.shared.hideProgressView()
            self.debugTextLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarControllerForView") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

/* If login unsuccessful, display a relevant message for what wen wrong */    
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            ActivityProgress.shared.hideProgressView()
            if let errorString = errorString {
                self.debugTextLabel.text = errorString
            }
            var alert = UIAlertView(title: nil, message: errorString, delegate: self, cancelButtonTitle: "Try again")
            alert.show()
            return

        })
    }

    
}


