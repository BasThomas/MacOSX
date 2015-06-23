//
//  Document.swift
//  RaiseMan
//
//  Created by Bas Broek on 01/05/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa
import RaiseKit

private var KVOContext = 0

class Document: NSDocument, NSWindowDelegate
{
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var arrayController: NSArrayController!
    
    var employees = [Employee]()
    {
        willSet
        {
            for employee in self.employees
            {
                self.stopObservingEmployee(employee)
            }
        }
        didSet
        {
            for employee in self.employees
            {
                self.startObservingEmployee(employee)
            }
        }
    }
    
    override init()
    {
        super.init()
    }

    override func windowControllerDidLoadNib(aController: NSWindowController)
    {
        super.windowControllerDidLoadNib(aController)
    }

    override class func autosavesInPlace() -> Bool
    {
        return true
    }

    override var windowNibName: String?
    {
        return "Document"
    }

    override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData?
    {
        self.tableView.window?.endEditingFor(nil)
        
        return NSKeyedArchiver.archivedDataWithRootObject(self.employees)
    }

    override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool
    {
        self.employees = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Employee]
        
        return true
    }
    
    // MARK: Accessors
    func insertObject(employee: Employee, inEmployeesAtIndex: Int)
    {
        let undo = self.undoManager!
        undo.prepareWithInvocationTarget(self).removeObjectFromEmployeesAtIndex(employees.count)
        
        if !undo.undoing
        {
            undo.setActionName("Add Person")
        }
        
        self.employees.append(employee)
    }
    
    func removeObjectFromEmployeesAtIndex(index: Int)
    {
        let employee = self.employees[index]
        
        let undo = self.undoManager!
        undo.prepareWithInvocationTarget(self).insertObject(employee, inEmployeesAtIndex: index)
        
        if !undo.undoing
        {
            undo.setActionName("Remove Person")
        }
        
        self.employees.removeAtIndex(index)
    }
    
    // MARK: - Actions
    @IBAction func addEmployee(sender: NSButton)
    {
        let windowController = self.windowControllers[0] as! NSWindowController
        let window = windowController.window!
        
        let endedEditing = window.makeFirstResponder(window)
        
        if !endedEditing
        {
            return
        }
        
        let undo = self.undoManager!
        
        if undo.groupingLevel > 0
        {
            undo.endUndoGrouping()
            undo.beginUndoGrouping()
        }
        
        let employee = self.arrayController.newObject() as! Employee
        self.arrayController.addObject(employee)
        self.arrayController.rearrangeObjects()
        
        let sortedEmployees = self.arrayController.arrangedObjects as! [Employee]
        
        let row = find(sortedEmployees, employee)!
        
        self.tableView.editColumn(0, row: row, withEvent: nil, select: true)
    }
    
    // MARK: - Key Value Observing
    func startObservingEmployee(employee: Employee)
    {
        employee.addObserver(self, forKeyPath: "name", options: .Old, context: &KVOContext)
        employee.addObserver(self, forKeyPath: "raise", options: .Old, context: &KVOContext)
    }
    
    func stopObservingEmployee(employee: Employee)
    {
        employee.removeObserver(self, forKeyPath: "name", context: &KVOContext)
        employee.removeObserver(self, forKeyPath: "raise", context: &KVOContext)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
    {
        if context != &KVOContext
        {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            
            return
        }
        
        var oldValue: AnyObject? = change[NSKeyValueChangeOldKey]
        if oldValue is NSNull
        {
            oldValue = nil
        }
        
        let undo = self.undoManager!
        undo.prepareWithInvocationTarget(object).setValue(oldValue, forKeyPath: keyPath)
    }
    
    // MARK: - NSWindowDelegate
    func windowWillClose(notification: NSNotification)
    {
        self.employees = []
    }
    
    // MARK: - Actions
    @IBAction func removeEmployees(sender: NSButton)
    {
        let selectedPeople = self.arrayController.selectedObjects as! [Employee]
        let isOne = selectedPeople.count == 1
        
        let alert = NSAlert()
        alert.messageText = isOne ? "Do you really want to remove \"\(selectedPeople[0].name!)\"?" : "Do you really want to remove these people?"
        alert.informativeText = isOne ? "\(selectedPeople[0].name!) will be removed" : "\(selectedPeople.count) people will be removed."
        alert.addButtonWithTitle("Remove")
        alert.addButtonWithTitle("Cancel")
        
        let window = sender.window!
        
        alert.beginSheetModalForWindow(window, completionHandler:
        { (response) -> Void in
            switch(response)
            {
                case NSAlertFirstButtonReturn:
                    self.arrayController.remove(nil)
                default:
                    break
            }
        })
    }
}