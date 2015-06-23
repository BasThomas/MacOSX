//
//  MainWindowController.swift
//  ToDo
//
//  Created by Bas Broek on 30/04/15.
//  Copyright (c) 2015 Bas Broek. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate
{
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var textField: NSTextField!
    
    var items = [String]()
    
    override var windowNibName: String?
    {
        return "MainWindowController"
    }
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
    }
    
    func createNewItemWithName(name: String)
    {
        self.items.append(name)
    }
    
    // MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return self.items.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?
    {
        let item = self.items[row]
        
        return item
    }
    @IBAction func textDidChange(sender: AnyObject)
    {
        let selectedRow = self.tableView.selectedRow
        
        if selectedRow == -1
        {
            return
        }
        
        self.items[selectedRow] = sender.stringValue
    }
    
    // MARK: - Action methods
    @IBAction func addItem(sender: AnyObject)
    {
        self.createNewItemWithName(self.textField.stringValue)
        
        self.tableView.reloadData()
    }
}