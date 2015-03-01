//
//  ListDataSourceTest.swift
//  FourSquareSearch
//
//  Created by Alper Senyurt on 2/27/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation

class ListDataSourceTest: XCTestCase {

    var testItem:[Venue]!
    var vc :SearchTableViewController?
    
    override func setUp() {
        super.setUp()
        
        self.testItem = [Venue(name: "A", location: CLLocation(latitude: 40.5, longitude: 54.5), distanceFromUser: 23),Venue(name: "B", location: CLLocation(latitude: 40.5, longitude: 54.5), distanceFromUser: 23)]
        
        let storyboard = UIStoryboard(name: "Main",
            bundle: NSBundle(forClass: self.dynamicType))
        let navigationController = storyboard.instantiateInitialViewController() as UINavigationController
        vc = navigationController.topViewController as? SearchTableViewController
        vc?.loadView()

    }
    
    override func tearDown() {
        super.tearDown()
        self.testItem = nil
        self.vc = nil
    }

    func testTableViewDataSourceConfiguration() {
        
        var cell:UITableViewCell? = nil
        var data:AnyObject? = nil
        let cellConfigure = {[weak self] (blockCell:UITableViewCell,blockData:AnyObject) -> () in
            cell = blockCell
            data = blockData
        }
        let listDataSource = ListDataSource(configurationListCellBlock: cellConfigure, cellIdentifier: "VenueCell")
        listDataSource.items = self.testItem

        XCTAssertNotNil(vc?.tableView, "tableview cant be nil")
        
        let rslt = listDataSource.tableView(vc!.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        
        XCTAssertNotNil(cell as? VenueCell, "VenueCell identifier must create VenueCell")
        XCTAssertNotNil(data as? Venue, "data cant be nil")
        XCTAssertTrue(listDataSource.items?.count == 2, "test item count is 2 so datasource must has 2 items")
    }

    
   

}
