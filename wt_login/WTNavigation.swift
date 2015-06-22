//
//  WTNavigation.swift
//  wt_login
//
//  Created by Margge Guiza.
//  Copyright (c) 2015 Margge Guiza. All rights reserved.
//

import Foundation
import UIKit

class WTNavigation {
    
    class func MainViewController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController") as! UIViewController
    }
    
    //self.navigationController?.presentViewController(WTNavigation.MainViewController(), animated: true, completion: nil)
}
