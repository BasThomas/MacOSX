//
//  CarArrayController.swift
//  CarLot
//
//  Created by Bas Broek on 03/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

class CarArrayController: NSArrayController
{
    override func newObject() -> AnyObject
    {
        let newObj = super.newObject() as! NSObject
        let now = NSDate()
        newObj.setValue(now, forKeyPath: "datePurchased")
        
        return newObj
    }
}
