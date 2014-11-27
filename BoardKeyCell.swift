//
//  BoardKeyCell.swift
//  KTQuickInfoKey
//
//  Created by Kevin Taniguchi on 11/24/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

import UIKit

class BoardKeyCell: UITableViewCell {
    @IBOutlet var keyNameTextField: UITextField!
    @IBOutlet var keyTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    override func layoutSubviews() {
        self.keyNameTextField.layer.borderWidth = 1.0
        self.keyNameTextField.layer.borderColor = UIColor.blackColor().CGColor
        self.keyTextField.layer.borderWidth = 1.0
        self.keyTextField.layer.borderColor = UIColor.blackColor().CGColor
        self.saveButton.layer.borderWidth = 1.0
        self.saveButton.layer.borderColor = UIColor.blackColor().CGColor
    }
}
