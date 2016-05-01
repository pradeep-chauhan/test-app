//
//  SearchDetails.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 9/26/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class SearchDetails: NSObject {
    var priceSelected:NSMutableArray = NSMutableArray()
    var venueSelected:NSMutableArray = NSMutableArray()
    var selectedAreaArray:NSMutableArray = NSMutableArray()
    var cityTextfieldValue:String = String()
    var areaTextfieldValue:String = String()
    var venueTextfieldValue:String = String()
    var dateTextfieldValue:String = String()
    var priceTextfieldValue:String = String()
    var pricePerPlateTextfieldValue:String = String()
    var coveredAreaTextfieldValue:String = String()
    var capacityTextfieldValue:String = String()
    var capacityMin:Int = Int()
    var capacityMax:Int = Int()
    var coveredAreaMin:Int = Int()
    var coveredAreaMax:Int = Int()
    var price_per_plate_status:Bool = Bool()
    var price_range_status:Bool = Bool()
    var areaArray:NSMutableArray = NSMutableArray()
    var selectedPriceArray:NSMutableArray = NSMutableArray()
    var selectedVenueArray:NSMutableArray = NSMutableArray()
}
