//
//  GeneratePassword.swift
//  RandomPassword
//
//  Created by Bas Broek on 29/04/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Foundation

private let characters = Array("0123456789abcdefghijklmnopqrstuvwxyz" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

func generateRandomString(length: Int) -> String
{
    var string = ""
    
    for index  in 0..<length
    {
        string.append(generateRandomCharacter())
    }
    
    return string
}

func generateRandomCharacter() -> Character
{
    let index = Int(arc4random_uniform(UInt32(characters.count)))
    
    let character = characters[index]
    
    return character
}