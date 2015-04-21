//
//  TextFieldCell.swift
//  Yelp
//
//  Created by Nathaniel Okun on 4/19/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate{
    func textTyped(cell: TextFieldCell, text: String)
}

class TextFieldCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var delegate: TextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        println("Began")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.textTyped(self, text: textField.text)
    }
}
