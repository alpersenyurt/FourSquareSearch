//
//  NetworkResource.swift
//  FourSquareSearch
//
//  Created by Alper Senyurt on 2/26/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import Foundation

struct NetworkResource<A> {
    
    let method : RequestMethod // enum which defines request methods
    let requestBody: NSData?
    let session:NSURLSession
    let headers : [String:String]
    let parse: NSData -> A?
}
