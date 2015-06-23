//
//  NSString+Drawing.swift
//  Dice
//
//  Created by Bas Broek on 16/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

extension NSString
{
    func drawCenteredInRect(rect: NSRect, attributes: [NSObject: AnyObject]!)
    {
        let stringSize = self.sizeWithAttributes(attributes)
        let point = NSPoint(x: rect.origin.x + (rect.width - stringSize.width) / 2.0, y: rect.origin.y + (rect.height - stringSize.height) / 2.0)
        
        self.drawAtPoint(point, withAttributes: attributes)
    }
}