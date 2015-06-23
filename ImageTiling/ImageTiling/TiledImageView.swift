//
//  TiledImageView.swift
//  ImageTiling
//
//  Created by Bas Broek on 04/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

@IBDesignable class TiledImageView: NSView
{
    @IBInspectable var image: NSImage?
    let columnCount = 5
    let rowCount = 5
    
    override var intrinsicContentSize: NSSize
    {
        let furthestFrame = self.frameForImageAtLogicalX(self.columnCount - 1, y: self.rowCount - 1)
        
        return NSSize(width: furthestFrame.maxX, height: furthestFrame.maxY)
    }
    
    override func drawRect(dirtyRect: NSRect)
    {
        super.drawRect(dirtyRect)
        
        if let image = image
        {
            for x in 0..<self.columnCount
            {
                for y in 0..<self.rowCount
                {
                    let frame = self.frameForImageAtLogicalX(x, y: y)
                    image.drawInRect(frame)
                }
            }
        }
    }
    
    // MARK: - Drawing
    func frameForImageAtLogicalX(logicalX: Int, y logicalY: Int) -> CGRect
    {
        let spacing = 10
        let width = 100
        let height = 100
        let x = (spacing + width) * logicalX
        let y = (spacing + height) * logicalY
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}