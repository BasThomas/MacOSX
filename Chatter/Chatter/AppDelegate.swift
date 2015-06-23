//
//  AppDelegate.swift
//  Chatter
//
//  Created by Bas Broek on 03/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    var windowControllers = [ChatWindowController]()
    
    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        self.addWindowController()
    }

    func applicationWillTerminate(aNotification: NSNotification)
    {
        
    }
    
    func applicationDidResignActive(notification: NSNotification)
    {
        NSBeep()
    }
    
    // MARK: - Actions
    @IBAction func displayNewWindow(sender: NSMenuItem)
    {
        self.addWindowController()
    }
    
    // MARK: - Helpers
    func addWindowController()
    {
        let windowController = ChatWindowController()
        windowController.showWindow(self)
        self.windowControllers.append(windowController)
    }
}