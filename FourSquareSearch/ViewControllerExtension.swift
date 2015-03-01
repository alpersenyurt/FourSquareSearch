//
//  ViewControllerExtension.swift
//  FourSquareSearch
//
//  Created by Alper Senyurt on 2/27/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit

extension UIViewController {

// show alert to get permissson
    func showNoPermissionsAlert() {
       
        let alertController = UIAlertController(title: "No permission", message: "In order to find venues, App needs your location", preferredStyle: .Alert)
        let openSettings = UIAlertAction(title: "Open settings", style: .Default, handler: {
            (action) -> Void in
            let URL = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(URL!)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(openSettings)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
  // show error message
    func showErrorAlert(error: NSError) {
      
        let alertController = UIAlertController(title: "Error", message:error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

}