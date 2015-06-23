//
//  AppDelegate.swift
//  Dice
//
//  Created by Bas Broek on 04/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    var mainWindowController: MainWindowController?
    
    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        let mainWindowController = MainWindowController()
        
        mainWindowController.showWindow(self)
        
        self.mainWindowController = mainWindowController
    }

    func applicationWillTerminate(aNotification: NSNotification)
    {
        
    }
}