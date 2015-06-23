//
//  MainWindowController.swift
//  RandomPassword
//
//  Created by Bas Broek on 28/04/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController
{
    @IBOutlet weak var textField: NSTextField!
    
    override var windowNibName: String
    {
        return "MainWindowController"
    }
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
    }
    
    @IBAction func generatePassword(sender: AnyObject)
    {
        let length = 8
        let password = generateRandomString(length)
        
        self.textField.stringValue = password
    }
}