//
//  ListPropertyTableViewCell.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 3/21/16.
//  Copyright (c) 2016 Pradeep Chauhan. All rights reserved.
//

import UIKit

class ListPropertyTableViewCell: UITableViewCell {

    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var propertyName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
