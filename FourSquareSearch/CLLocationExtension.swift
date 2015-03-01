//
//  CLLocationExtension.swift
//  FourSquareApiSearch
//
//  Created by Alper Senyurt on 2/26/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit
import CoreLocation

  extension CLLocation {


    func getLocationParameter () ->String {
    
        let ll:String = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
    
        return ll
    }

 }