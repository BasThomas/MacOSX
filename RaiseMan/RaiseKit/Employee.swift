//
//  Employee.swift
//  RaiseMan
//
//  Created by Bas Broek on 01/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Foundation

public class Employee: NSObject, NSCoding
{
    public var name: String? = "New Employee"
    public var raise: Float = 0.05
    
    override public init()
    {
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder)
    {
        self.name = aDecoder.decodeObjectForKey("name") as! String?
        self.raise = aDecoder.decodeFloatForKey("raise")
        
        super.init()
    }
    
    // MARK: - NSCoding
    public func encodeWithCoder(aCoder: NSCoder)
    {
        if let name = self.name
        {
            aCoder.encodeObject(name, forKey: "name")
        }
        
        aCoder.encodeFloat(self.raise, forKey: "raise")
    }
    
    public func validateRaise(raiseNumberPointer: AutoreleasingUnsafeMutablePointer<NSNumber?>, error outError: NSErrorPointer) -> Bool
    {
        let raiseNumber = raiseNumberPointer.memory
        if raiseNumber == nil
        {
            let domain = "UserInputValidationErrorDomain"
            let code = 0
            let userInfo = [NSLocalizedDescriptionKey: "An employee's raise must be a number."]
            
            outError.memory = NSError(domain: domain, code: code, userInfo: userInfo)
            
            return false
        }
        
        return true
    }
}