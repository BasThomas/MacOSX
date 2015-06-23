//
//  DieView.swift
//  Dice
//
//  Created by Bas Broek on 04/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

@IBDesignable class DieView: NSView, NSDraggingSource
{
    override var intrinsicContentSize: NSSize
    {
        return NSSize(width: 20, height: 20)
    }
    
    var intValue: Int? = 1
    {
        didSet
        {
//            if self.intValue > 6
//            {
//                self.randomize()
//            }
            
            self.needsDisplay = true
        }
    }
    
    var pressed: Bool = false
    {
        didSet
        {
            self.needsDisplay = true
        }
    }
    
    var mouseDownEvent: NSEvent?
    
    var highlightForDragging: Bool = false
    {
        didSet
        {
            self.needsDisplay = true
        }
    }
    
    var color = NSColor.whiteColor()
    {
        didSet
        {
            self.needsDisplay = true
        }
    }
    
    var numberOfTimesToRoll = 10
    
    var rollsRemaining = 0
    
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
        self.commonInit()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit()
    {
        self.registerForDraggedTypes([NSPasteboardTypeString])
    }
    
    override func drawRect(dirtyRect: NSRect)
    {
        let backgroundColor = NSColor.lightGrayColor()
        backgroundColor.set()
        NSBezierPath.fillRect(self.bounds)
        
        if self.highlightForDragging
        {
            let gradient = NSGradient(startingColor: self.color, endingColor: backgroundColor)
            gradient.drawInRect(self.bounds, relativeCenterPosition: NSZeroPoint)
        }
        else
        {
            self.drawDieWithSize(self.bounds.size)
        }
    }
    
    func metricsForSize(size: CGSize) -> (edgeLength: CGFloat, dieFrame: CGRect)
    {
        let edgeLength = min(size.width, size.height)
        let padding = edgeLength / 10.0
        let drawingBounds = CGRect(x: 0, y: 0, width: edgeLength, height: edgeLength)
        var dieFrame = drawingBounds.rectByInsetting(dx: padding, dy: padding)
        
        if self.pressed
        {
            dieFrame = dieFrame.rectByOffsetting(dx: 0, dy: -edgeLength / 40)
        }
        
        return (edgeLength, dieFrame)
    }
    
    func drawDieWithSize(size: CGSize)
    {
        if let intValue = self.intValue
        {
            let (edgeLength, dieFrame) = self.metricsForSize(size)
            let cornerRadius: CGFloat = edgeLength / 5.0
            let dotRadius = edgeLength / 12.0
            let dotFrame = dieFrame.rectByInsetting(dx: dotRadius * 2, dy: dotRadius * 2)
            
            NSGraphicsContext.saveGraphicsState()
            
            let shadow = NSShadow()
            shadow.offset = NSSize(width: 0, height: -1)
            shadow.blurRadius = (self.pressed ? edgeLength / 100 : edgeLength / 20)
            shadow.set()
            
            self.color.set()
            NSBezierPath(roundedRect: dieFrame, xRadius: cornerRadius, yRadius: cornerRadius).fill()
            
            NSGraphicsContext.restoreGraphicsState()
            
            NSColor.blackColor().set()
            
            func drawDot(u: CGFloat, v: CGFloat)
            {
                let dotOrigin = CGPoint(x: dotFrame.minX + dotFrame.height * u, y: dotFrame.minY + dotFrame.height * v)
                let dotRect = CGRect(origin: dotOrigin, size: CGSizeZero).rectByInsetting(dx: -dotRadius, dy: -dotRadius)
                
                NSBezierPath(ovalInRect: dotRect).fill()
            }
            
            if find(1...6, intValue) != nil
            {
                if find([1, 3, 5], intValue) != nil
                {
                    drawDot(0.5, 0.5) // Center dot
                }
                
                if find(2...6, intValue) != nil
                {
                    drawDot(0, 1) // Upper left
                    drawDot(1, 0) // Lower right
                }
                
                if find(4...6, intValue) != nil
                {
                    drawDot(1, 1) // Upper right
                    drawDot(0, 0) // Lower left
                }
                
                if intValue == 6
                {
                    drawDot(0, 0.5) // Mid left/right
                    drawDot(1, 0.5)
                }
            }
            else
            {
                var paraStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
                paraStyle.alignment = .CenterTextAlignment
                let font = NSFont.systemFontOfSize(edgeLength * 0.5)
//                let attrs: [NSObject: AnyObject]! =
//                [
//                    NSForegroundColorAttributeName: .blackColor(),
//                    NSFontAttributeName: font,
//                    NSParagraphStyleAttributeName: paraStyle
//                ]
                
                let string = "\(self.intValue)" as NSString
//                string.drawCenteredInRect(dieFrame, attributes: attrs)
            }
        }
    }
    
    func randomize()
    {
        self.intValue = Int(arc4random_uniform(5)) + 1
    }
    
    // MARK: - Mouse Events
    override func mouseDown(theEvent: NSEvent)
    {
        self.mouseDownEvent = theEvent
        
        let dieFrame = self.metricsForSize(bounds.size).dieFrame
        let pointInView = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        
        self.pressed = dieFrame.contains(pointInView)
    }
    
    override func mouseDragged(theEvent: NSEvent)
    {
        let downPoint = self.mouseDownEvent!.locationInWindow
        let dragPoint = theEvent.locationInWindow
        
        let distanceDragged = hypot(downPoint.x - dragPoint.x, downPoint.y - dragPoint.y)
        
        if distanceDragged < 3
        {
            return
        }
        
        self.pressed = false
        
        if let intValue = self.intValue
        {
            let imageSize = self.bounds.size
            let image = NSImage(size: imageSize, flipped: false, drawingHandler:
            { (imageBounds) -> Bool in
                self.drawDieWithSize(imageBounds.size)
                
                return true
            })
            
            let draggingFrameOrigin = self.convertPoint(downPoint, fromView: nil)
            let draggingFrame = NSRect(origin: draggingFrameOrigin, size: imageSize).rectByOffsetting(dx: -imageSize.width / 2, dy: -imageSize.height / 2)
            
            let item = NSDraggingItem(pasteboardWriter: "\(intValue)")
            item.draggingFrame = draggingFrame
            item.imageComponentsProvider =
            {
                let component = NSDraggingImageComponent(key: NSDraggingImageComponentIconKey)
                
                component.contents = image
                component.frame = NSRect(origin: NSPoint(), size: imageSize)
                
                return [component]
            }
            
            self.beginDraggingSessionWithItems([item], event: self.mouseDownEvent!, source: self)
        }
    }
    
    override func mouseUp(theEvent: NSEvent)
    {
        if theEvent.clickCount == 2
        {
            self.roll()
        }
        
        self.pressed = false
    }
    
    // MARK: - First Responder
    override var acceptsFirstResponder: Bool
    {
        return true
    }
    
    override func becomeFirstResponder() -> Bool
    {
        return true
    }
    
    override func resignFirstResponder() -> Bool
    {
        return true
    }
    
    override func drawFocusRingMask()
    {
        NSBezierPath.fillRect(self.bounds)
    }
    
    override var focusRingMaskBounds: NSRect
    {
        return self.bounds
    }
    
    // MARK: - Keyboard Events
    override func keyDown(theEvent: NSEvent)
    {
        self.interpretKeyEvents([theEvent])
    }
    
    override func insertText(insertString: AnyObject)
    {
        let text = insertString as! String
        
        if let number = text.toInt()
        {
            self.intValue = number
        }
    }
    
    override func insertTab(sender: AnyObject?)
    {
        self.window?.selectNextKeyView(sender)
    }
    
    override func insertBacktab(sender: AnyObject?)
    {
        self.window?.selectPreviousKeyView(sender)
    }
    
    @IBAction func savePDF(sender: AnyObject!)
    {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["pdf"]
        savePanel.beginSheetModalForWindow(window!, completionHandler:
        {
            [unowned savePanel] (result) in
                if result == NSModalResponseOK
                {
                    let data = self.dataWithPDFInsideRect(self.bounds)
                    var error: NSError?
                    let ok = data.writeToURL(savePanel.URL!, options: .DataWritingAtomic, error: &error)
                    
                    if !ok
                    {
                        let alert = NSAlert(error: error!)
                        alert.runModal()
                    }
            }
        })
    }
    
    // MARK: - Pasteboard
    func writeToPasteboard(pasteboard: NSPasteboard)
    {
        if let intValue = self.intValue
        {
            pasteboard.clearContents()
            pasteboard.writeObjects(["\(intValue)"])
        }
    }
    
    func readFromPasteboard(pasteboard: NSPasteboard) -> Bool
    {
        let objects = pasteboard.readObjectsForClasses([NSString.self], options: nil) as! [String]
        
        if let str = objects.first
        {
            self.intValue = str.toInt()
            
            return true
        }
        
        return false
    }
    
    // MARK: - Drag Source
    func draggingSession(session: NSDraggingSession, sourceOperationMaskForDraggingContext context: NSDraggingContext) -> NSDragOperation
    {
        return .Copy | .Delete
    }
    
    func draggingSession(session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, operation: NSDragOperation)
    {
        if operation == .Delete
        {
            self.intValue = nil
        }
    }
    
    // MARK: - Drag Destination
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation
    {
        if sender.draggingSource() === self
        {
            return .None
        }
        
        self.highlightForDragging = true
        
        return sender.draggingSourceOperationMask()
    }
    
    override func draggingExited(sender: NSDraggingInfo?)
    {
        self.highlightForDragging = false
    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool
    {
        return true
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool
    {
        let ok = self.readFromPasteboard(sender.draggingPasteboard())
        
        return ok
    }
    
    override func concludeDragOperation(sender: NSDraggingInfo?)
    {
        self.highlightForDragging = false
    }
    
    // MARK: - NSTimer Implementation
    func roll()
    {
        self.rollsRemaining = self.numberOfTimesToRoll
        NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: Selector("rollTick:"), userInfo: nil, repeats: true)
        
        self.window?.makeFirstResponder(nil)
    }
    
    func rollTick(sender: NSTimer)
    {
        let lastIntValue = self.intValue
        
        while self.intValue == lastIntValue
        {
            self.randomize()
        }
        
        self.rollsRemaining--
        
        if self.rollsRemaining == 0
        {
            sender.invalidate()
            window?.makeFirstResponder(self)
        }
    }
    
    // MARK: - Pasteboard Actions
    @IBAction func cut(sender: AnyObject?)
    {
        self.writeToPasteboard(NSPasteboard.generalPasteboard())
        self.intValue = nil
    }
    
    @IBAction func copy(sender: AnyObject?)
    {
        self.writeToPasteboard(NSPasteboard.generalPasteboard())
    }
    
    @IBAction func paste(sender: AnyObject?)
    {
        self.readFromPasteboard(NSPasteboard.generalPasteboard())
    }
}

// MARK: - NSShadow extension
extension NSShadow
{
    var offset: NSSize
    {
        get
        {
            return self.shadowOffset
        }
        set
        {
            self.shadowOffset = newValue
        }
    }
    
    var blurRadius: CGFloat
    {
        get
        {
            return self.shadowBlurRadius
        }
        set
        {
            self.shadowBlurRadius = newValue
        }
    }
    
    var color: NSColor?
    {
        get
        {
            return self.shadowColor
        }
        set
        {
            self.shadowColor = newValue
        }
    }
}