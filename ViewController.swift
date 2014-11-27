//
//  ViewController.swift
//  KTQuickInfoKey
//
//  Created by Kevin Taniguchi on 11/8/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var sharedDefaults = NSUserDefaults(suiteName: "group.InfoKeyboard")
    var count = 0
    var selectedRow = 0
    var keyArray = [[String:String]]()
    var respondingTextField : UITextField?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getSelectedRow:", name: UITextFieldTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextFieldTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addNewField")
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if self.sharedDefaults?.objectForKey("quickKeyDictionary") != nil {
            self.keyArray = self.sharedDefaults?.objectForKey("quickKeyDictionary") as [[String:String]]
            count = self.keyArray.count
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            count--
            if let dict = self.keyArray[indexPath.row] as [String:String]? {
                self.keyArray.removeAtIndex(indexPath.row)
                self.sharedDefaults?.setValue(self.keyArray, forKey: "quickKeyDictionary")
                self.sharedDefaults?.synchronize()
            }

            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let sourceCell = self.tableView.cellForRowAtIndexPath(sourceIndexPath) as BoardKeyCell
        let destinationCell = self.tableView.cellForRowAtIndexPath(destinationIndexPath) as BoardKeyCell
        sourceCell.tag = destinationIndexPath.row
        destinationCell.tag = sourceIndexPath.row

        let sourceDictionary = [sourceCell.keyNameTextField.text:sourceCell.keyTextField.text] as [String:String]
        let destDictionary = [destinationCell.keyNameTextField.text:destinationCell.keyTextField.text] as  [String:String]
        self.keyArray[destinationIndexPath.row] = sourceDictionary
        self.keyArray[sourceIndexPath.row] = destDictionary
        
        self.sharedDefaults?.setValue(self.keyArray, forKey: "quickKeyDictionary")
        self.sharedDefaults?.synchronize()
}
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        self.tableView.editing = !self.tableView.editing
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as BoardKeyCell
        if !cell.keyTextField.text.isEmpty && !cell.keyNameTextField.text.isEmpty {
            
            let keyDictionary = [cell.keyNameTextField.text:cell.keyTextField.text] as [String:String]
            
            if (sender.tag + 1) > self.keyArray.count {
                self.keyArray.append(keyDictionary)
            }
            else {
                self.keyArray[sender.tag] = keyDictionary
            }
        }
        
        cell.saveButton.backgroundColor = UIColor.lightGrayColor()
        self.sharedDefaults?.setValue(self.keyArray, forKey: "quickKeyDictionary")
        self.sharedDefaults?.synchronize()
    }
    
    func addNewField () {
        count++
        self.keyArray.append(["":""])
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KeyCell") as BoardKeyCell
        cell.tag = indexPath.row
        cell.keyTextField.tag = indexPath.row
        cell.keyNameTextField.tag = indexPath.row
        cell.saveButton.tag = indexPath.row
        if self.keyArray.count > indexPath.row {
            let keyDictionary = self.keyArray[indexPath.row] as [String:String]
            cell.keyNameTextField.text = keyDictionary.keys.array[0]
            cell.keyTextField.text = keyDictionary.values.array[0]
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func getSelectedRow (notification: NSNotification) {
        let textField = notification.object as UITextField
        self.selectedRow = textField.tag
    }
    
    func textChanged (notification : NSNotification) {
        let textField = notification.object as UITextField
        if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: textField.tag, inSection: 0)) as? BoardKeyCell {
            cell.saveButton.backgroundColor = UIColor.redColor()
        }
    }
    
    func keyBoardShown (notification: NSNotification) {
        let info = notification.userInfo as [String:AnyObject]
        let kbSize = info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
        let height =  kbSize?.height
        let insets = UIEdgeInsetsMake(0, 0, 130 + height!, 0)
        self.tableView.contentInset = insets
        
        var frame = self.view.frame
        frame.size.height -= 130 + height!
        
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectedRow, inSection: 0)) as BoardKeyCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectedRow, inSection: 0)) as? BoardKeyCell {
            if cell.keyTextField.isFirstResponder() && cell.keyTextField.text.utf16Count > 0 {
                cell.keyTextField.resignFirstResponder()
            }
            else if cell.keyNameTextField.isFirstResponder() && cell.keyNameTextField.text.utf16Count > 0 {
                cell.keyNameTextField.resignFirstResponder()
            }
        }
    }
}

