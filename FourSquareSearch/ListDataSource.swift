//
//  ListDataSource.swift
//  FourSquareSearch
//
//  Created by Alper Senyurt  on 28/02/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit

class ListDataSource: NSObject,UITableViewDataSource{
    
    
    typealias listCellConfiguretionBlock = (cell:UITableViewCell ,data:AnyObject) ->()
    
    var items:[AnyObject]?
    let configureCellBlock:listCellConfiguretionBlock
    let cellIdentifier:String
    
    init(configurationListCellBlock:listCellConfiguretionBlock,cellIdentifier:String) {
        
        self.configureCellBlock = configurationListCellBlock
        self.cellIdentifier = cellIdentifier

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    

        return self.items?.count ?? 0 // optional if items is nil then return 0

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let ccell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell
        let data: AnyObject? = self.itemForIndexpath(indexPath)
        if let data: AnyObject = data {  //unwrap Optional type
            
            self.configureCellBlock(cell: ccell,data: data)

            return ccell

        }
        return ccell
    }
    
    func itemForIndexpath(indexpath:NSIndexPath) -> AnyObject? {
        
        return self.items?[indexpath.row]
    }
   
}
