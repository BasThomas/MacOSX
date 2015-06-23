//
//  PreferenceManager.swift
//  SpeakLine
//
//  Created by Bas Broek on 03/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

private let activeVoiceKey = "activeVoice"
private let activeTextKey = "activeText"

class PreferenceManager
{
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var activeVoice: String?
    {
        set(newActiveVoice)
        {
            self.userDefaults.setObject(newActiveVoice, forKey: activeVoiceKey)
        }
        get
        {
            return self.userDefaults.objectForKey(activeVoiceKey) as? String
        }
    }
    
    var activeText: String?
    {
        set(newActiveText)
        {
            self.userDefaults.setObject(newActiveText, forKey: activeTextKey)
        }
        get
        {
            return self.userDefaults.objectForKey(activeTextKey) as? String
        }
    }
    
    init()
    {
        self.registerDefaultPreferences()
    }
    
    func registerDefaultPreferences()
    {
        let defaults = [
            activeVoiceKey: NSSpeechSynthesizer.defaultVoice(),
            activeTextKey: "Able was I ere I saw Elba"]
        
        self.userDefaults.registerDefaults(defaults)
    }
}