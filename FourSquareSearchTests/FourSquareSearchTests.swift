//
//  FourSquareSearchTests.swift
//  FourSquareSearchTests
//
//  Created by Alper Senyurt on 2/26/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation

class FourSquareSearchTests: XCTestCase {
    
    var vc :SearchTableViewController?
    var mockLocationObject:CLLocation?
   
    class MockSearhTableController: SearchTableViewController {
        
        var showWasCalled = false
        
        override func showNoPermissionsAlert() {
            
            showWasCalled = true
            
        }
     
    }

    
    
    override func setUp() {
        super.setUp()
        self.mockLocationObject = CLLocation(latitude: 40.5, longitude: 54.5)
        let storyboard = UIStoryboard(name: "Main",
            bundle: NSBundle(forClass: self.dynamicType))
        let navigationController = storyboard.instantiateInitialViewController() as UINavigationController
        vc = navigationController.topViewController as? SearchTableViewController
        vc?.loadView()
        vc?.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        vc = nil
    }
    
    
    func testInitialObjects () {
        
        XCTAssertNotNil(vc?.foursquareApi, "foursquare api cant be nil")
        XCTAssertNotNil(vc?.locationManager, "locationManager api cant be nil")
        XCTAssertNotNil(vc?.dataSource, "dataSource api cant be nil")

    }
    
    func testFoursquareApiSearchFunction() {
       
     let expectation = expectationWithDescription("GET ")

     vc?.foursquareApi.getSearchVenue("d", location: CLLocation(latitude: 40.5, longitude: 54.5), completion: {(result:[Venue]?) in
        expectation.fulfill()

            XCTAssertNotNil(result, "result must have data")
            
        })
    
        waitForExpectationsWithTimeout(40) { (error) in
            XCTAssertNil(error, "timeout message")
        }
    }
    
   func testCompareTableViewDataAndResulOfSearchFunction () {
    
    let expectation = expectationWithDescription("GET ")
    XCTAssertNotNil(vc, "tablecontroler cant be nil")
    var cout = 0

    vc?.foursquareApi.getSearchVenue("d", location: CLLocation(latitude: 40.5, longitude: 54.5), completion: {(result:[Venue]?) in
        expectation.fulfill()

        XCTAssertNotNil(result, "result must have data")
        self.vc?.dataSource.items = result!
        self.vc?.tableView.reloadData()
        cout = result?.count ?? -1
        
    })
    waitForExpectationsWithTimeout(40) { (error) in
        XCTAssertNil(error, "timeout message")

    }
    
    XCTAssert(self.vc?.tableView.numberOfRowsInSection(0) == cout, "tableview data must equal to result of foursquare api")

    }
    
    func testdoSearchFunctionWhenNoLocation() {

        let vc = MockSearhTableController()
        vc.viewDidLoad()
        vc.currentLocation = nil
        vc.doSearch("a")
        XCTAssertTrue(vc.showWasCalled, "While user is doing search if controller has no location,permission alert must be showed ")
    }
    
    func testPerformanceMeasureSearchFunction() {
        // This is an example of a performance test case.
        self.measureBlock() {
        self.vc!.currentLocation = self.mockLocationObject
        self.vc!.doSearch("s")
        }
    }

}
