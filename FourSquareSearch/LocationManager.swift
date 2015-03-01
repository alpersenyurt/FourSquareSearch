//
//  LocationManager.swift
//  FourSquareApiSearch
//
//  Created by Alper Senyurt on 2/26/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit
import CoreLocation


typealias locationOnSucces       = (location:CLLocation)->()
typealias locationOnError        = (error:NSError)->()
typealias locationWantPermisson  = ()->()

class LocationManager:NSObject,CLLocationManagerDelegate {
    
    lazy var locationManager    = CLLocationManager()
    var locationStatus:NSString = "No Started"
    var onSucces:locationOnSucces?
    var onError:locationOnError?
    var locationPermission:locationWantPermisson?

    override init() {
        
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 100.0;
      
    }
    

    func determineLocation(#success:locationOnSucces,failure:locationOnError,permission:locationWantPermisson) {
    
        self.onSucces = success
        self.onError = failure
        self.locationPermission = permission
        let status = self.getLocationStatus()
        self.startLocationUpdate(status)
    }
    
    // check location authorizationStatus and request authorization or startupdatinglocation
    func startLocationUpdate (status:CLAuthorizationStatus) {

        if status == .NotDetermined {
            if CLLocationManager.locationServicesEnabled() {
              if self.locationManager.respondsToSelector("requestWhenInUseAuthorization") {
                   locationManager.requestWhenInUseAuthorization()
                }
            }
        } else if status == .AuthorizedWhenInUse || status == .Authorized {
            locationManager.startUpdatingLocation()
        } else {
            self.locationPermission?()
        }

    
    }
    
    //get locationStatus
    func getLocationStatus () -> CLAuthorizationStatus {
    
    
        return  CLLocationManager.authorizationStatus()
        
    }
    
    //if error is occured execure self.onError closure
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        if error.code != 0 {
            
            self.onError?(error: error)
        }
    }
    
    //if we have no authorizationStatus, execute locationPermisson closure if we havevalid authorization startUpdatingLocation
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
       
        if status == .Denied || status == .Restricted  {
        
          self.locationPermission?()

        } else {
        
            self.locationManager.startUpdatingLocation()
        }
        
    }
   
    // when we get location execute self.onSucces closure
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        self.onSucces?(location: locations.first as CLLocation)
        locationManager.stopUpdatingLocation()
    }
    

    deinit{
    
        self.onError = nil
        self.onSucces = nil
        self.locationPermission = nil
    }

}