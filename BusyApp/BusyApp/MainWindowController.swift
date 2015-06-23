//
//  MainWindowController.swift
//  BusyApp
//
//  Created by Bas Broek on 29/04/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController
{
    @IBOutlet weak var secureField: NSSecureTextField!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var checkbox: NSButton!
    @IBOutlet weak var verticalSlider: NSSlider!
    @IBOutlet weak var radioMatrix: NSMatrix!
    @IBOutlet weak var sliderLabel: NSTextFieldCell!
    
    var currentSliderValue = 0.0
    
    override var windowNibName: String?
    {
        return "MainWindowController"
    }
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
    }
    
    @IBAction func checkUncheck(sender: AnyObject)
    {
        let checkbox = sender as! NSButton

        if checkbox.state == 0
        {
            checkbox.title = "Check me"
        }
        else if checkbox.state == 1
        {
            checkbox.title = "Uncheck me"
        }
    }
    
    @IBAction func revealMessage(sender: AnyObject)
    {
        self.textField.stringValue = self.secureField.stringValue
    }
    
    @IBAction func radioButtonPressed(sender: AnyObject)
    {
        let matrix = sender as! NSMatrix
        
        let selected = matrix.selectedRow
        
        if selected == 0
        {
            self.verticalSlider.numberOfTickMarks = 10
        }
        else if selected == 1
        {
            self.verticalSlider.numberOfTickMarks = 0
        }
    }
    
    @IBAction func adjustSlider(sender: AnyObject)
    {
        if self.currentSliderValue < sender.doubleValue
        {
            self.sliderLabel.title = "going up"
        }
        else if self.currentSliderValue > sender.doubleValue
        {
            self.sliderLabel.title = "going down"
        }
        else
        {
            self.sliderLabel.title = "staying"
        }
        
        self.currentSliderValue = sender.doubleValue
    }
    
    @IBAction func resetControls(sender: AnyObject)
    {
        self.checkbox.state = 1
        self.checkbox.title = "Uncheck me"
        
        self.secureField.stringValue = ""
        self.textField.stringValue = ""
        
        self.verticalSlider.doubleValue = 0.0
        
        self.radioMatrix.selectCellAtRow(0, column: 0)
        self.verticalSlider.numberOfTickMarks = 10
    }
}