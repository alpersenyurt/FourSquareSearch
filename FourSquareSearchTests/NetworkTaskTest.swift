//
//  NetworkTaskTest.swift
//  FourSquareSearch
//
//  Created by Netas iMac on 27/02/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit
import XCTest
import CoreLocation
class NetworkTaskTest: XCTestCase {

    var fourquareApi:FoursquareVenueApiTask?
    var foursquareClient:FoursquareClient?
    var mockBaseUrl:String?
    var mockLocation:CLLocation?

    class MockURLSession : NSURLSession { // create mock nsulrsession to manipulate response and result data
        
        enum ResponseCase {
        
            case NilData
            case No200StatusCode
            case None
        }
        var request: NSURLRequest?
        var response:NSURLResponse!
        
        init(responseCase:ResponseCase) {
            
            switch(responseCase) {
            
            case .NilData,.None :
                response = NSHTTPURLResponse(URL: NSURL(), statusCode: 200, HTTPVersion: "", headerFields: nil)
            case .No200StatusCode :
                response = NSHTTPURLResponse(URL: NSURL(), statusCode: 405, HTTPVersion: "", headerFields: nil)
            default : return
                
            }
        }
        
        override func dataTaskWithRequest(request: NSURLRequest, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) -> NSURLSessionDataTask {
           
            completionHandler!(nil,response,nil)
            return  NSURLSessionDataTask()

        }
    }
    
   
    
    override func setUp() {
        super.setUp()

        self.fourquareApi = FoursquareVenueApiTask()
        self.foursquareClient = FoursquareClient(clientID:"I3YUELKQOSKL0SW1LSLWUYIBDBJ14ZAG1K0SPFPNDIY1FVRS", clientSecret: "NG2REUZGEYI00OWODNFOKBQ2LHXH5O0XIHZIWU10Q00IXJGX")
        self.mockLocation = CLLocation(latitude: 40.5, longitude: 54.5)
        self.mockBaseUrl = "https://api.foursquare.com/v2/venues/search?ll=\(self.mockLocation!.getLocationParameter())&client_id=\(self.foursquareClient!.clientID)&client_secret=\(self.foursquareClient!.secret)&v=20150815&query=sushi"

    }
    
  
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        self.fourquareApi = nil
        self.mockLocation = nil
        
    
    }

    func testFoursquareClient(){
        
        XCTAssertNotNil(self.foursquareClient?.clientID, "foursquare clientID cant be nil")
        XCTAssertNotNil(self.foursquareClient?.secret, "foursquare secret cant be nil")
        
    }
    func wrongParseJson (result:[String:AnyObject])->[Venue]?{
        
    
        return nil
    
    }
    
    func createMockRequestResourceForJsonParseTest()-> NetworkResource<[Venue]>? {
        
        return  self.fourquareApi?.networkTask.prepareRequestResource( method: RequestMethod.GET, requestParameters: [:],session: NSURLSession.sharedSession() , parse: wrongParseJson)

        
    }
    func createMockSessionResourceForTestNilData()-> NetworkResource<[Venue]>? {
       
        return  self.fourquareApi?.networkTask.prepareRequestResource( method: RequestMethod.GET, requestParameters: [:],session:MockURLSession(responseCase: NetworkTaskTest.MockURLSession.ResponseCase.NilData) , parse: wrongParseJson)
    }
    
    func createMockSessionResourceForTestFailStatusCode()-> NetworkResource<[Venue]>? {
        
        return  self.fourquareApi?.networkTask.prepareRequestResource( method: RequestMethod.GET, requestParameters: [:],session:MockURLSession(responseCase: NetworkTaskTest.MockURLSession.ResponseCase.No200StatusCode) , parse: wrongParseJson)
    }
  
    func testFailureJsonParseCase () {
  
        let URL:NSURL? = NSURL(string: self.mockBaseUrl!)?
        
        XCTAssertNotNil(URL, "url cant be nil")

        self.fourquareApi?.networkTask.apiRequest({ _ in }, baseURL: URL!, resource: self.createMockRequestResourceForJsonParseTest()!, failure: { (reason:FailureReason, data:NSData?) -> () in
       
            XCTAssert(reason == FailureReason.CouldNotParseJSON, "if parse method does not works properly it must be give CouldNotParseJSON error")

            }, completion: {([Venue]) in })
    
    }
   
    func testNilResultData () {
        
        let URL:NSURL? = NSURL(string: self.mockBaseUrl!)?
        
        XCTAssertNotNil(URL, "url cant be nil")
        
        self.fourquareApi?.networkTask.apiRequest({ _ in }, baseURL: URL!, resource: self.createMockSessionResourceForTestNilData()!, failure: { (reason:FailureReason, data:NSData?) -> () in
            
            XCTAssert(reason == FailureReason.NoData, "if url connection result data is nil , failure should be FailureReason.NoData ")
            
            }, completion: {([Venue]) in })
        
    }

    func testFailureStatusCode () {
        
        let URL:NSURL? = NSURL(string: self.mockBaseUrl!)?
        
        XCTAssertNotNil(URL, "url cant be nil")
        
        self.fourquareApi?.networkTask.apiRequest({ _ in }, baseURL: URL!, resource: self.createMockSessionResourceForTestFailStatusCode()!, failure: { (reason:FailureReason, data:NSData?) -> () in
            
            XCTAssert(reason == FailureReason.NoSuccessStatusCode(statusCode: 405), "if url connection response status code no 200  , failure should be FailureReason.NoSuccessStatusCode ")
            
            }, completion: {([Venue]) in })
        
    }

    func testCreateUrlStringFunction () {
    
       let baseUrl = self.fourquareApi?.createUrlString("https://api.foursquare.com/v2/venues", searchVenue: "suchi", userLocation: self.mockLocation!)
        XCTAssertNotNil(baseUrl, "create url function work wrongly")
    
    }
    func testGetRequest() {
        
     
        XCTAssertNotNil(self.mockBaseUrl, "baseUrl cant be nil")

        let URL:NSURL? = NSURL(string: self.mockBaseUrl!)?
        
        XCTAssertNotNil(URL, "url cant be nil")

        let expectation = expectationWithDescription("GET \(URL)")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(URL!) { (data, response, error) in
            expectation.fulfill()
            
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as? NSHTTPURLResponse {
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
               
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout(task.originalRequest.timeoutInterval) { (error) in
            task.cancel()
        }
    }

   

}
