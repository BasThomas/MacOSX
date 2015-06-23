//
//  MainWindowController.swift
//  Dice
//
//  Created by Bas Broek on 04/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController
{
    var configurationWindowController: ConfigurationWindowController?
    
    override var windowNibName: String?
    {
        return "MainWindowController"
    }
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func showDieConfiguration(sender: AnyObject?)
    {
        if let window = self.window, let dieView = self.window?.firstResponder as? DieView
        {
            let windowController = ConfigurationWindowController()
            windowController.configuration = DieConfiguration(color: dieView.color, rolls: dieView.numberOfTimesToRoll)
            
            window.beginSheet(windowController.window!, completionHandler:
            { (response) -> Void in
                if response == NSModalResponseOK
                {
                    let configuration = self.configurationWindowController!.configuration
                    
                    dieView.color = configuration.color
                    dieView.numberOfTimesToRoll = configuration.rolls
                }
                
                self.configurationWindowController = nil
            })
            
            self.configurationWindowController = windowController
        }
    }
}