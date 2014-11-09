//
//  ViewController.swift
//  KTQuickInfoKey
//
//  Created by Kevin Taniguchi on 11/8/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var sharedDefaults = NSUserDefaults(suiteName: "group.InfoKeyboard")
    
    @IBOutlet var twitterTextField: UITextField!
    @IBOutlet var savedEmailLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var twitterLabel: UILabel!
    var emailAddress = ""
    var twitterHandle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.sharedDefaults?.objectForKey("userEmail") != nil {
            self.emailAddress = self.sharedDefaults?.objectForKey("userEmail") as String
            self.savedEmailLabel.text = emailAddress
            self.emailTextField.text = emailAddress
        }
        
        if self.sharedDefaults?.objectForKey("twitterHandle") != nil {
            self.twitterHandle = self.sharedDefaults?.objectForKey("twitterHandle") as String
            self.twitterLabel.text = twitterHandle
            self.twitterTextField.text = twitterHandle
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
        self.savedEmailLabel.text = self.emailTextField.text
    }
    
    @IBAction func saveTwitterButtonPressed(sender: AnyObject) {
        self.sharedDefaults?.setValue(self.twitterTextField.text, forKey: "twitterHandle")
        self.sharedDefaults?.synchronize()
        self.twitterLabel.text = self.twitterTextField.text

    }
}

