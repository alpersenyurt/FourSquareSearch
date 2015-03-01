//
//  NetworkTask.swift
//  FourSquareSearch
//
//  Created by Alper Senyurt on 2/26/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import Foundation

public enum RequestMethod: String {
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}

 enum FailureReason {
    case CouldNotParseJSON
    case NoData
    case NoSuccessStatusCode(statusCode: Int)
    case Other(NSError)
    
    
}
func ==(lhs: FailureReason, rhs: FailureReason) -> Bool {
    switch (lhs, rhs) {
    case (.CouldNotParseJSON,.CouldNotParseJSON), (.NoData,.NoData),(.NoSuccessStatusCode,.NoSuccessStatusCode),(.Other,.Other):
        return true
    default:
        return false
    }
}

class  NetworkTask {
 
  private var         task               : NSURLSessionDataTask? = nil

  typealias JSONDictionary = [String:AnyObject] //create new type which is named JSONDictionary

 
  //apiRequest is a generic.And this method works for connection foursqarWebervice and get result
  //has a parameter request closure,basurl,resource object,failure closure and complation handler
 func apiRequest<A>(modifyRequest: NSMutableURLRequest -> (), baseURL: NSURL, resource: NetworkResource<A>, failure: (FailureReason, NSData?) -> (), completion: A -> ()) {
  
    let session = resource.session
    let request = NSMutableURLRequest(URL: baseURL)
    request.HTTPMethod = resource.method.rawValue
    request.HTTPBody = resource.requestBody
    modifyRequest(request)
   
    for (key,value) in resource.headers {
        request.setValue(value, forHTTPHeaderField: key)
    }
    
    self.task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
        if let httpResponse = response as? NSHTTPURLResponse { //inside block unwrap optional type
            if httpResponse.statusCode == 200 {
                if let responseData = data {
                    if let result = resource.parse(responseData) {
                        completion(result)
                    } else {
                        failure(FailureReason.CouldNotParseJSON, data)
                    }
                } else {
                    failure(FailureReason.NoData, data)
                }
            } else {
                failure(FailureReason.NoSuccessStatusCode(statusCode: httpResponse.statusCode), data)
            }
        } else {
            failure(FailureReason.Other(error), data)
        }
    }
    self.task?.resume()
}


 //cancel the task
 func cancel () {
    
    self.task?.cancel()
    
 }

 // decode json
 func decodeJSON(data: NSData) -> JSONDictionary? {
    
    return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? JSONDictionary
 }

 //encode json
 func encodeJSON(dict: JSONDictionary) -> NSData? {
 
    return dict.count > 0 ? NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: nil) : nil
 }
 

//this method returns  resource for request for example header,http method,httpbody,parse, parse is a closure
 func prepareRequestResource<A>(#method: RequestMethod, requestParameters: JSONDictionary, session:NSURLSession, parse: JSONDictionary -> A?) -> NetworkResource<A> {
    
    let jsonParser = { parse (self.decodeJSON($0)!)} // json parser is  generic closure
    let jsonBody = encodeJSON(requestParameters)
    let headers = ["Content-Type": "application/json"]
    return NetworkResource(method: method, requestBody: jsonBody,session : session, headers: headers, parse: jsonParser)
    
    }
}
 