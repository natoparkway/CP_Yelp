//
//  GeneralFilterCell.swift
//  Yelp
//
//  Created by Nathaniel Okun on 4/19/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol GeneralFilterCellDelegate{
    func settingsChanged(cell: GeneralFilterCell, isOn: Bool)
}

class GeneralFilterCell: UITableViewCell {
    
    var delegate: GeneralFilterCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var filterSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchFlipped(sender: AnyObject) {
        delegate?.settingsChanged(self, isOn: sender.isOn)
    }
}
