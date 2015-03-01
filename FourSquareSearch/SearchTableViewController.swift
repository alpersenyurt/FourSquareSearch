//
//  SearchTableViewController.swift
//  FourSquareSearch
//
//  Created by Alper Senyurt on 2/28/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit

import CoreLocation

class SearchTableViewController: UITableViewController,UISearchBarDelegate  {

    lazy var locationManager:LocationManager = LocationManager()
    lazy var foursquareApi:FoursquareVenueApiTask = FoursquareVenueApiTask()
    var dataSource:ListDataSource!
    var currentLocation:CLLocation?
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    
    // I have locationManager class and this has a method which is named "determineLocation" for find current Location .This function has 3 closure for 3 case ,(succes,error,permission)
    
    //I have CLLocationExtension .This extension is used for provide  extra method to CLlocation class for getting latitude and langitude Extension is similar with Category in objective C
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableHeaderView = self.searchBar
        self.dataSource = ListDataSource(configurationListCellBlock: cellConfigure ,  cellIdentifier: "VenueCell")
        self.tableView.dataSource = self.dataSource
        self.configureTableView()

        
        self.locationManager.determineLocation(
            
            success: { [weak self] (currentLocation) -> ()  in
                
                self!.currentLocation = currentLocation
              
            }, failure: {[weak self] (error) -> () in
                
                self!.showErrorAlert(error)
                
            },permission: { [weak self] () -> () in
                
                self!.showNoPermissionsAlert()
        })
        
        
    }
    
    //this method is passed as a closure to ListDatasource and this methods works for configure my venue tableviewcell
    func cellConfigure<T,D>(tableViewCell:T,data:D) {
    
        let cell:VenueCell? =  tableViewCell as? VenueCell
        let item:Venue?   =  data as? Venue
        if let cell = cell {
        
            if let item = item {
            
                cell.configure(item)
            }
        }
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let strippedString = searchText.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        self.doSearch(strippedString)
    }

    //after enter text, this method calls foursquare api to get venues
    func doSearch(search:String)  {
    
        if self.currentLocation == nil {
            self.showNoPermissionsAlert()
            return
        }
        self.foursquareApi.requestCancelTask()
        self.foursquareApi.getSearchVenue(search, location:self.currentLocation!, completion: {[weak self](result:[Venue]?) in
            
            if let result = result {
                self!.dataSource.items = result
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self!.tableView.reloadData()
                })
                
                
            }
        })

    }

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
       
        searchBar.resignFirstResponder()
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
    }

    // this methods work for increase tableview performans 
    func configureTableView() {
       
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
