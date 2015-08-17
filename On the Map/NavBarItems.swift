//
//  NavBarItems.swift
//  On the Map
//
//  Created by Enrico Montana on 8/16/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func addNavBarMenuItems()
    {
        
        let buttonRefresh: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonRefresh.frame = CGRectMake(0, 0, 40, 40)
        buttonRefresh.setImage(UIImage(named:"refreshIcon"), forState: UIControlState.Normal)
        buttonRefresh.addTarget(self, action: "refreshClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var buttonRefreshRight: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        
        let buttonAddLocation: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonAddLocation.frame = CGRectMake(0, 0, 40, 40)
        buttonAddLocation.setImage(UIImage(named:"addIcon"), forState: UIControlState.Normal)
        buttonAddLocation.addTarget(self, action: "addLocationClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var buttonAddLocationRight: UIBarButtonItem = UIBarButtonItem(customView: buttonAddLocation)
        
        let buttonLogout: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonLogout.frame = CGRectMake(0, 0, 75, 40)
        buttonLogout.setTitleColor(UIColor.blueColor(), forState: .Normal)
        buttonLogout.setTitle("Logout", forState: .Normal)
        buttonLogout.addTarget(self, action: "logout:", forControlEvents: UIControlEvents.TouchUpInside)
        var buttonLogoutLeft: UIBarButtonItem = UIBarButtonItem(customView: buttonLogout)
        
        self.navigationItem.setRightBarButtonItems([buttonRefreshRight, buttonAddLocationRight], animated: true)
        self.navigationItem.setLeftBarButtonItems([buttonLogoutLeft], animated: true)
        
    }

}
