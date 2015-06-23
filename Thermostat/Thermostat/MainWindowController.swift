//
//  MainWindowController.swift
//  Thermostat
//
//  Created by Bas Broek on 30/04/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController
{
    dynamic var temperature = 68
    dynamic var isOn = true
    
    override var windowNibName: String?
    {
        return "MainWindowController"
    }
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
    }
    
    @IBAction func setWarmer(sender: AnyObject)
    {
        self.temperature++
    }
    
    @IBAction func setCooler(sender: AnyObject)
    {
        self.temperature--
    }
}