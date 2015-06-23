//
//  ConfigurationWindowController.swift
//  Dice
//
//  Created by Bas Broek on 17/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

struct DieConfiguration
{
    let color: NSColor
    let rolls: Int
    
    init(color: NSColor, rolls: Int)
    {
        self.color = color
        self.rolls = max(rolls, 1)
    }
}

class ConfigurationWindowController: NSWindowController
{
    var configuration: DieConfiguration
    {
        set
        {
            self.color = newValue.color
            self.rolls = newValue.rolls
        }
        get
        {
            return DieConfiguration(color: self.color, rolls: self.rolls)
        }
    }
    
    private dynamic var color = NSColor.whiteColor()
    private dynamic var rolls = 10
    
    override var windowNibName: String
    {
        return "ConfigurationWindowController"
    }
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
    }
    
    func dismissWithModalResponse(response: NSModalResponse)
    {
        self.window!.sheetParent!.endSheet(window!, returnCode: response)
    }
    
    @IBAction func okayButtonClicked(button: NSButton)
    {
        self.window?.endEditingFor(nil)
        self.dismissWithModalResponse(NSModalResponseOK)
    }
    
    @IBAction func cancelButtonClicked(button: NSButton)
    {
        self.dismissWithModalResponse(NSModalResponseCancel)
    }
}