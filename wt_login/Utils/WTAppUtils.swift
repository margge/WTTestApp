//
//  WTAppUtils.swift
//  wt_login
//
//  Created by Margge Guiza on 6/23/15.
//  Copyright (c) 2015 Margge Guiza. All rights reserved.
//

import UIKit

class WTAppUtils: NSObject {
    
    class func showErrorMessage(alertTitle: String, alertMessage: String, viewController: UIViewController){
        var alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}
