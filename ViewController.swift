//
//  ViewController.swift
//  KTQuickInfoKey
//
//  Created by Kevin Taniguchi on 11/8/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var sharedDefaults = NSUserDefaults(suiteName: "group.InfoKeyboard")
    
    @IBOutlet var twitterTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    var emailAddress = ""
    var twitterHandle = ""
    
    @IBOutlet var twitterSaveButton: UIButton!
    @IBOutlet var emailSaveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.sharedDefaults?.objectForKey("userEmail") != nil {
            self.emailAddress = self.sharedDefaults?.objectForKey("userEmail") as String
            self.emailTextField.text = emailAddress
        }
        
        if self.sharedDefaults?.objectForKey("twitterHandle") != nil {
            self.twitterHandle = self.sharedDefaults?.objectForKey("twitterHandle") as String
            self.twitterTextField.text = twitterHandle
        }
        
        self.setSaveButtonImage()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.emailTextField {
            self.emailSaveButton.backgroundColor = UIColor.clearColor()
        }
        
        if textField == self.twitterTextField {
            self.twitterSaveButton.backgroundColor = UIColor.clearColor()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if emailTextField.isFirstResponder() {
            emailTextField.resignFirstResponder()
        }
        if twitterTextField.isFirstResponder() {
            twitterTextField.resignFirstResponder()
        }
    }
    
    @IBAction func saveEmailButtonPressed(sender: AnyObject) {
        self.sharedDefaults?.setValue(self.emailTextField.text, forKey: "userEmail")
        self.sharedDefaults?.synchronize()
        self.setSaveButtonImage()
    }
    
    @IBAction func saveTwitterButtonPressed(sender: AnyObject) {
        self.sharedDefaults?.setValue(self.twitterTextField.text, forKey: "twitterHandle")
        self.sharedDefaults?.synchronize()
        self.setSaveButtonImage()
    }
    
    func setSaveButtonImage () {
        if (!self.twitterTextField.text.isEmpty) {
            self.twitterSaveButton.backgroundColor = UIColor.greenColor()
        }
        else {
            self.twitterSaveButton.backgroundColor = UIColor.clearColor()
        }
        
        if (!self.emailTextField.text.isEmpty) {
            self.emailSaveButton.backgroundColor = UIColor.greenColor()
        }
        else {
            self.emailSaveButton.backgroundColor = UIColor.clearColor()
        }
    }
}

