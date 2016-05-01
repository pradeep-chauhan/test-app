//
//  calendarUserDetailsTableViewCell.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 2/26/16.
//  Copyright (c) 2016 Pradeep Chauhan. All rights reserved.
//

import UIKit

class calendarUserDetailsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var customerMobileNo: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var bookingDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
