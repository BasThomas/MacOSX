//
//  Document.swift
//  CarLot
//
//  Created by Bas Broek on 03/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

class Document: NSPersistentDocument
{
    override init()
    {
        super.init()
    }

    override func windowControllerDidLoadNib(aController: NSWindowController)
    {
        super.windowControllerDidLoadNib(aController)
    }

    override class func autosavesInPlace() -> Bool
    {
        return true
    }

    override var windowNibName: String?
    {
        return "Document"
    }
}