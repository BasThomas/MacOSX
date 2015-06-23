//
//  MainWindowController.swift
//  RGBWell
//
//  Created by Bas Broek on 29/04/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController
{
    @IBOutlet weak var rSlider: NSSlider!
    @IBOutlet weak var gSlider: NSSlider!
    @IBOutlet weak var bSlider: NSSlider!
    @IBOutlet weak var colorWell: NSColorWell!
    
    var r = 0.0
    var g = 0.0
    var b = 0.0
    let a = 1.0
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.rSlider.doubleValue = self.r
        self.gSlider.doubleValue = self.g
        self.bSlider.doubleValue = self.b
        
        self.updateColor()
    }
    
    override var windowNibName: String?
    {
        return "MainWindowController"
    }
    
    func updateColor()
    {
        let newColor = NSColor(calibratedRed: CGFloat(self.r),
                                       green: CGFloat(self.g),
                                        blue: CGFloat(self.b),
                                       alpha: CGFloat(self.a))
        
        self.colorWell.color = newColor
    }
    
    @IBAction func adjustRed(sender: AnyObject)
    {
        self.r = sender.doubleValue
        
        self.updateColor()
    }
    
    @IBAction func adjustGreen(sender: AnyObject)
    {
        self.g = sender.doubleValue
        
        self.updateColor()
    }
    
    @IBAction func adjustBlue(sender: AnyObject)
    {
        self.b = sender.doubleValue
        
        self.updateColor()
    }
}