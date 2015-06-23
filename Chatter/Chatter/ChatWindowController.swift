//
//  ChatWindowController.swift
//  Chatter
//
//  Created by Bas Broek on 03/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

private let ChatWindowControllerDidSendMessageNotification = "nl.basbroek.chatter.ChatWindowControllerDidSendMessageNotification"
private let ChatWindowControllerMessageKey = "nl.basbroek.chatter.ChatWindowControllerMessageKey"

class ChatWindowController: NSWindowController
{
    dynamic var log = NSAttributedString(string: "")
    dynamic var message: String?
    
    @IBOutlet var textView: NSTextView!
    
    // MARK: - Lifecycle
    
    override var windowNibName: String?
    {
        return "ChatWindowController"
    }
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
        
        let notificiationCenter = NSNotificationCenter.defaultCenter()
        
        notificiationCenter.addObserver(self, selector: Selector("receiveDidSendMessageNotification:"), name: ChatWindowControllerDidSendMessageNotification, object: nil)
    }
    
    deinit
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notifications
    func receiveDidSendMessageNotification(note: NSNotification)
    {
        let mutableLog = self.log.mutableCopy() as! NSMutableAttributedString
        
        if self.log.length > 0
        {
            mutableLog.appendAttributedString(NSAttributedString(string: "\n"))
        }
        
        let userInfo = note.userInfo! as! [String: String]
        let message = userInfo[ChatWindowControllerMessageKey]!
        
        let logLine = NSAttributedString(string: message)
        mutableLog.appendAttributedString(logLine)
        
        self.log = mutableLog.copy() as! NSAttributedString
        
        self.textView.scrollRangeToVisible(NSRange(location: self.log.length, length: 0))
    }
    
    // MARK: - Actions
    @IBAction func send(sender: AnyObject)
    {
        sender.window?.endEditingFor(nil)
        if let message = self.message
        {
            let userInfo = [ChatWindowControllerMessageKey: message]
            let notificationCenter = NSNotificationCenter.defaultCenter()
            
            notificationCenter.postNotificationName(ChatWindowControllerDidSendMessageNotification, object: self, userInfo: userInfo)
        }
        
        self.message = ""
    }
}