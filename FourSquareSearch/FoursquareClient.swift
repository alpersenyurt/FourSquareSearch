//
//  FoursquareClient.swift
//  FoursquareVenues
//
//  Created by Alper Senyurt on 2/26/15.
//  Copyright (c) 2015 XD. All rights reserved.
//

import UIKit


 struct FoursquareClient {
    
    let clientID : String
    let secret : String
    
     init(clientID: String, clientSecret: String) {
        self.clientID = clientID
        self.secret = clientSecret
    }

}

