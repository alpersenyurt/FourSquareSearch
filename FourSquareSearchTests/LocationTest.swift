//
//  LocationTest.swift
//  FourSquareSearch
//
//  Created by Alper Senyurt on 2/27/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation

class LocationTest: XCTestCase {
    
    class MockSearhTableController: SearchTableViewController { 
        
        var showWasCalled = false
        
        override func showNoPermissionsAlert() {
            
            showWasCalled = true
            
        }
        
        override func showErrorAlert(error: NSError) {
            
            showWasCalled = true
        }
    }
   
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    
    func  testLocationPermissonCase() {
        
        class MockLocationManager:LocationManager {
            
            private override func determineLocation(#success: locationOnSucces, failure: locationOnError, permission: locationWantPermisson) {
                
                permission()
            }
            
        }
        
        let mockLocationManager = MockLocationManager()
        let vc = MockSearhTableController()
        vc.locationManager  = mockLocationManager
        vc.viewDidLoad()
        XCTAssertTrue(vc.showWasCalled, "Permission message was not called.")
    }
   
    
    func  testLocationErrorCase() {
        
        class MockLocationManager:LocationManager {
            
            private override func determineLocation(#success: locationOnSucces, failure: locationOnError, permission: locationWantPermisson) {
                
                failure(error: NSError())
            }
            
        }
        
        let mockLocationManager = MockLocationManager()
        let vc = MockSearhTableController()
        vc.locationManager  = mockLocationManager
        vc.viewDidLoad()
        XCTAssertTrue(vc.showWasCalled, "Error Message was not called.")
    }
    
    func  testLocationSuccesCase() {
        
        class MockLocationManager:LocationManager {
            
            private override func determineLocation(#success: locationOnSucces, failure: locationOnError, permission: locationWantPermisson) {
            
                success(location: CLLocation(latitude: 40.5, longitude: 54.5))
                
            }
            
        }
        
        let mockLocationManager = MockLocationManager()
        let vc = MockSearhTableController()
        vc.locationManager  = mockLocationManager
        vc.viewDidLoad()
        XCTAssertNotNil(vc.currentLocation, "When location is get succesfully current location must has a value")
    }

    
       
}
