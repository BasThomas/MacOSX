//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Bas Broek on 29/04/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate
{
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    let preferenceManager = PreferenceManager()
    let speechSynth = NSSpeechSynthesizer()
    
    let voices = NSSpeechSynthesizer.availableVoices() as! [String]
    
    var isStarted = false
    {
        didSet
        {
            self.updateButtons()
            self.updateTextField()
        }
    }
    
    override var windowNibName: String
    {
        return "MainWindowController"
    }
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
        
        self.updateButtons()
        self.speechSynth.delegate = self
        
        let defaultVoice = self.preferenceManager.activeVoice!
        if let defaultRow = find(self.voices, defaultVoice)
        {
            let indices = NSIndexSet(index: defaultRow)
            self.tableView.selectRowIndexes(indices, byExtendingSelection: false)
            self.tableView.scrollRowToVisible(defaultRow)
        }
        
        self.textField.stringValue = self.preferenceManager.activeText!
    }
    
    func updateButtons()
    {
        if self.isStarted
        {
            self.speakButton.enabled = false
            self.stopButton.enabled = true
        }
        else
        {
            self.speakButton.enabled = true
            self.stopButton.enabled = false
        }
    }
    
    func updateTextField()
    {
        if self.isStarted
        {
            self.textField.enabled = false
        }
        else
        {
            self.textField.enabled = true
            self.textField.becomeFirstResponder()
        }
    }
    
    func voiceNameForIdentifier(identifier: String) -> String?
    {
        if let attributes = NSSpeechSynthesizer.attributesForVoice(identifier)
        {
            return attributes[NSVoiceName] as? String
        }
        
        return nil
    }
    
    // MARK: - NSSpeechSynthesizerDelegate
    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool)
    {
        self.isStarted = false
        
        self.textField.attributedStringValue = NSMutableAttributedString(string: self.textField.stringValue)
        
        self.updateTextField()
    }
    
    func speechSynthesizer(sender: NSSpeechSynthesizer, willSpeakWord characterRange: NSRange, ofString string: String)
    {
        let range = characterRange
        let theString = self.textField.stringValue
        let attributedString = NSMutableAttributedString(string: theString)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: NSColor.greenColor(), range: characterRange)
        
        self.textField.attributedStringValue = attributedString
        
    }
    // MARK: - NSWindowDelegate
    func windowShouldClose(sender: AnyObject) -> Bool
    {
        return !self.isStarted
    }
    
    // MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return self.voices.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?
    {
        let voice = self.voices[row]
        let voiceName = self.voiceNameForIdentifier(voice)
        
        return voiceName
    }
    
    // MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(notification: NSNotification)
    {
        let row = self.tableView.selectedRow
        
        if row == -1
        {
            self.speechSynth.setVoice(nil)
            
            return
        }
        
        let voice = self.voices[row]
        self.speechSynth.setVoice(voice)
        
        self.preferenceManager.activeVoice = voice
    }
    
    // MARK: - NSTextFieldDelegate
    override func controlTextDidChange(obj: NSNotification)
    {
        self.preferenceManager.activeText = self.textField.stringValue
    }
    
    // MARK: - Action methods
    @IBAction func speakIt(sender: AnyObject)
    {
        let string = self.textField.stringValue
        if string.isEmpty
        {
            println("string from \(self.textField) is empty.")
        }
        else
        {
            self.speechSynth.startSpeakingString(string)
            self.isStarted = true
        }
    }
    
    @IBAction func stopIt(sender: AnyObject)
    {
        self.speechSynth.stopSpeaking()
    }
}