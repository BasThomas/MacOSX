//
//  MainWindowController.swift
//  Aspect
//
//  Created by Bas Broek on 29/04/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate
{
    override var windowNibName: String?
    {
        return "MainWindowController"
    }
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
    }
    
    // MARK: - NSWindowDelegate
    func windowWillResize(sender: NSWindow, toSize frameSize: NSSize) -> NSSize
    {
        let newSize = NSSize(width: frameSize.width, height: frameSize.width * 2)
        
        return newSize
    }
}
