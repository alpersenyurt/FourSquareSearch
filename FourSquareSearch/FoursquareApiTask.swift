//
//  FoursquareApiTask.swift
//  FourSquareSearch
//
//  Created by Alper Senyurt on 2/26/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit
import CoreLocation

protocol FoursquareApiTask {

    typealias Data  // run time dynamic variable  type of Data will be determined by class which comform this protocol
    
    var foursquareClient:FoursquareClient {get set}
    var userLocation:CLLocation? {get set}
    var networkTask:NetworkTask {get set}
 
   func defaultFailureHandler(failureReason: FailureReason, data: NSData?)
   func parseJson (result:[String:AnyObject])-> Data?
   func createRequestResource()-> NetworkResource<Data>
   func request(userLocation:CLLocation, completionHandler: Data? -> ())
   func requestCancelTask()
}