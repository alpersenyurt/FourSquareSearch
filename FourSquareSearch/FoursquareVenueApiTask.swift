//
//  FoursquareApiTask.swift
//  FourSquareSearch
//
//  Created by Alper Senyurt on 2/27/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit
import CoreLocation

class FoursquareVenueApiTask: NSObject,FoursquareApiTask {
    
    var foursquareClient:FoursquareClient
    var userLocation:CLLocation?
    var networkTask:NetworkTask
    private var search:String?
    
    override init() {
        
        foursquareClient =  FoursquareClient(clientID: "I3YUELKQOSKL0SW1LSLWUYIBDBJ14ZAG1K0SPFPNDIY1FVRS", clientSecret: "NG2REUZGEYI00OWODNFOKBQ2LHXH5O0XIHZIWU10Q00IXJGX")
        networkTask = NetworkTask()

    }
    

 // this method works for parse json
   func parseJson (result:[String:AnyObject])->[Venue]?{
        
        var venues:[Venue] = []
        let response: NSDictionary = result["response"] as NSDictionary
        let allVenues: [NSDictionary] = response["venues"] as [NSDictionary]
        for venue:NSDictionary in allVenues {
            var venueName:String = venue["name"] as String
            var location:NSDictionary = venue["location"] as NSDictionary
            var venueLocation:CLLocation = CLLocation(latitude: location["lat"] as Double, longitude: location["lng"] as Double)
            venues.append(Venue(name: venueName, location: venueLocation, distanceFromUser: venueLocation.distanceFromLocation(userLocation)))
        }
        return venues
    }
    
    // this method calls prepareRequestResource method,Parameters of this method are ,request method type ,header parameters,session obje,and parse method as a closue
    func createRequestResource()-> NetworkResource<[Venue]> {
        
        return self.networkTask.prepareRequestResource( method: RequestMethod.GET, requestParameters: [:], session : NSURLSession.sharedSession(),parse: parseJson)
        
    }
    

    //this method calls apiRequest method, Parameters of this method are, base url,createRequestResource method as a closure,failure method as a closure and complation handler
    func request(userLocation:CLLocation, completionHandler: [Venue]? -> ()) {
      
        self.userLocation = userLocation
        let baseUrlString = "https://api.foursquare.com/v2/venues"
        let param = self.createUrlString(baseUrlString, searchVenue: self.search!, userLocation: self.userLocation!)
        let baseURL = NSURL(string: param)?
        if let baseUrl = baseURL {
       
            self.networkTask.apiRequest({ _ in }, baseURL: baseUrl, resource: createRequestResource(), failure: defaultFailureHandler, completion: completionHandler)
        } else {
        
            completionHandler(nil)
        }
    }
    
    //reques is called from this method
    func  getSearchVenue(search:String,location:CLLocation, completion: [Venue]? -> ()) {
        self.search = search
        self.search = self.search ?? ""
        self.request(location, completionHandler: completion)
    }
   
    // this method create url string
    func createUrlString (baseUrlString:String,searchVenue:String,userLocation:CLLocation)->String{
       
        let client = "client_id=\(self.foursquareClient.clientID)&client_secret=\(self.foursquareClient.secret)&"
        let query = "query=\(searchVenue)"
        let ll = "/search?ll=\(userLocation.getLocationParameter())&"
        let version = "v=20150226&"
        let param = "\(baseUrlString)\(ll)\(client)\(version)\(query)"
        return param
    }
    
    //when we have error while we try get result venues from foursquare web service, This method will work
    func defaultFailureHandler(failureReason: FailureReason, data: NSData?) {
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        println("Failure: \(failureReason) \(string)")
    }
    
    func requestCancelTask(){ // cancel task
        
        self.networkTask.cancel()
        
    }
}