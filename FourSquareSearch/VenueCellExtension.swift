//
//  VenueCellExtension.swift
//  FourSquareSearch
//
//  Created by Alper Senyurt on 27/02/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit


extension VenueCell {

    
// configure cell
    func configure (data:Venue) {

        self.title.text = data.name
        self.subtitle.text = "\(Int (data.distanceFromUser))m"
 
    }








}

