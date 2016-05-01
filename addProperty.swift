
//  addProperty.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 8/6/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class addProperty: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //    var propertyInfoSegmentVC : propertyInfoSegmentViewController = propertyInfoSegmentViewController()
    @IBOutlet weak var addPropertyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var addPropertyListArray:NSArray = NSArray()
    var propertyArray : NSMutableArray = NSMutableArray()
    var selectedPropertyDetailsArray : NSMutableArray = NSMutableArray()
    var editPropertyArray : NSMutableArray = NSMutableArray()
    var newEditPropertyListArray:NSArray = NSArray()
    var LoginDetails: loginDetails = loginDetails()
    var propertyInfo: NSDictionary = NSDictionary()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var propertyId:Int = 0
    var propertyName = ""
    var priceRangeId = ""
    var venueTypeId = ""
    var areaId = ""
    var stateId = ""
    var cityId = ""
    var price_per_plate_status:Bool = false
    var price_range_status:Bool = true
    
    var areaListArray:NSArray = NSArray()
    var areaArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerNib( a, forCellReuseIdentifier: "ScrollTableViewCell")
        self.tableView.registerNib(UINib(nibName: "AddPropertyTableViewCell", bundle: nil), forCellReuseIdentifier: "addPropertyTableViewCell")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //println("total edit: \(editPropertyArray.count)")
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        self.addPropertyButton.backgroundColor = appDelegate.mainColor
        
        // Set property title first letter to capital
        
        if ( editPropertyArray.count > 0) {
            propertyName = editPropertyArray[0]["name"] as! NSString as String
            let trimmedString = propertyName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            var propertyNameStringArray = trimmedString.componentsSeparatedByString(" ")
            var propertyListName = ""
            for ( var i = 0; i < propertyNameStringArray.count; i++) {
                propertyNameStringArray[i].replaceRange(propertyNameStringArray[i].startIndex...propertyNameStringArray[i].startIndex, with: String(propertyNameStringArray[i][propertyNameStringArray[i].startIndex]).capitalizedString)
                propertyListName = propertyListName + " " + propertyNameStringArray[i]
            }
            self.navigationItem.title = propertyListName
            self.addPropertyButton.titleLabel?.text = "Update"
        }
        
        // Assign IDs for selected property
        
        if (editPropertyArray.count > 0) {
            priceRangeId = (editPropertyArray[0]["price_range_id"] as! NSNumber).stringValue
            venueTypeId = (editPropertyArray[0]["property_type_id"] as! NSNumber).stringValue
            areaId = (editPropertyArray[0]["area_id"] as! NSNumber).stringValue
            stateId = (editPropertyArray[0]["state_id"] as! NSNumber).stringValue
            cityId = (editPropertyArray[0]["city_id"] as! NSNumber).stringValue
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Checking seleted area
        
        if ( appDelegate.addEditPropertySelectedArea.count > 0 ) {
            displaySeletedArea()
        }
        
        //self.tableView.reloadData()
    }
    
    // Display selected area
    
    func displaySeletedArea () {
        
        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! addPropertyTableViewCell
        
        if (appDelegate.addEditPropertySelectedArea.count > 0) {
            propertyName = appDelegate.addEditPropertySelectedArea[0]["name"] as! NSString as String
            cell.selectedAreaLabel.text = "  \(propertyName)"
            cell.areaId = (appDelegate.addEditPropertySelectedArea[0]["id"] as! NSNumber).stringValue
            cell.selectedAreaLabel.textColor = UIColor.blackColor()
        }
        else {
            cell.selectedAreaLabel.text = " Please select area"
            cell.areaId = ""
            cell.selectedAreaLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        }
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 1400
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("addPropertyTableViewCell") as! addPropertyTableViewCell
        
        //println(editPropertyArray[0])
        if(editPropertyArray.count > 0) {
            propertyId = editPropertyArray[0]["id"] as! NSInteger as Int
            
            cell.stateTypeLabel.textColor = UIColor.blackColor()
            cell.cityTypeLabel.textColor = UIColor.blackColor()
            cell.selectedAreaLabel.textColor = UIColor.blackColor()
            cell.pricerangeLabel.textColor = UIColor.blackColor()
            
            if let email = editPropertyArray[0]["email"] as? NSString {
                cell.email.text = editPropertyArray[0]["email"] as! NSString as String
            }
            else {
                cell.email.text = ""
            }
            
            
            if let name = editPropertyArray[0]["name"] as? NSString {
                cell.venueTitle.text = editPropertyArray[0]["name"] as! NSString as String
            }
            else {
                cell.venueTitle.text = ""
            }
            
            
            if let address = editPropertyArray[0]["address_line_1"] as? NSString {
                cell.address.text = editPropertyArray[0]["address_line_1"] as! NSString as String
            }
            else {
                cell.address.text = ""
            }
            
            if let capacity = editPropertyArray[0]["capacity"] as? NSNumber {
                cell.propertyCapacity.text = (editPropertyArray[0]["capacity"] as! NSNumber).stringValue
            } else {
                cell.propertyCapacity.text = ""
            }
            
            if let city = editPropertyArray[0]["city"] as? NSString {
                cell.cityTypeLabel.text = editPropertyArray[0]["city"] as! NSString as String
            }
            else {
                cell.cityTypeLabel.text = ""
            }
            
            
            if let selectedArea = editPropertyArray[0]["area"] as? NSString {
                let areaString = editPropertyArray[0]["area"] as! NSString as String
                cell.selectedAreaLabel.text = "  \(areaString)"
                cell.areaId = (editPropertyArray[0]["area_id"] as! NSNumber).stringValue
            }
            else {
                cell.selectedAreaLabel.text = ""
                cell.areaId = ""
                
            }
            
            if let covered_area = editPropertyArray[0]["covered_area"] as? NSNumber {
                let area = (editPropertyArray[0]["covered_area"] as! NSNumber).stringValue
                cell.coveredArea.text = " \(area)"
            } else {
                cell.coveredArea.text = ""
            }
            
            if let desc = editPropertyArray[0]["description"] as? NSString {
                cell.desc.text = editPropertyArray[0]["description"] as! NSString as String
            }
            else {
                cell.desc.text = ""
            }
            
            if let mobile = editPropertyArray[0]["mobile_number"] as? NSString {
                cell.mobile.text = editPropertyArray[0]["mobile_number"] as! NSString as String
            }
            else {
                cell.mobile.text = ""
            }
            
            if let capacity = editPropertyArray[0]["capacity"] as? NSNumber {
                cell.parkingCapacity.text = (editPropertyArray[0]["parking"] as? NSNumber)!.stringValue
            }
            else {
                cell.parkingCapacity.text = ""
            }
            
            if let parking = editPropertyArray[0]["parking"] as? NSNumber {
                cell.parkingCapacity.text = (editPropertyArray[0]["parking"] as! NSNumber).stringValue
            }
            else {
                cell.parkingCapacity.text = ""
            }
            
            if (editPropertyArray[0]["price_range_status"] as! Int == 1) {
                if let priceRange = editPropertyArray[0]["price_range"] as? NSString {
                    cell.pricerangeLabel.text = editPropertyArray[0]["price_range"] as! NSString as String
                    cell.priceId = (editPropertyArray[0]["price_range_id"] as! NSNumber).stringValue
                    price_range_status = true
                }
                else {
                    cell.pricerangeLabel.text = ""
                    cell.priceId = ""
                    price_range_status = false
                }
            }
            else {
                cell.pricerangeLabel.text = ""
                price_range_status = false
            }
            
            
            if let propertyType = editPropertyArray[0]["property_type"] as? NSString {
                cell.venueTypeLabel.text = editPropertyArray[0]["property_type"] as! NSString as String
                cell.venueId = (editPropertyArray[0]["property_type_id"] as! NSNumber).stringValue
            }
            else {
                cell.venueTypeLabel.text = ""
                cell.venueId = ""
            }
            
            if let rooms = editPropertyArray[0]["rooms"] as? NSNumber {
                cell.rooms.text = (editPropertyArray[0]["rooms"] as! NSNumber).stringValue
            }
            else {
                cell.rooms.text = ""
            }
            
            if let website = editPropertyArray[0]["website"] as? NSString {
                cell.website.text = (editPropertyArray[0]["website"] as! NSString as String)
            }
            else {
                cell.website.text = ""
            }
            
            if let zipcode = editPropertyArray[0]["zipcode"] as? NSString {
                cell.zipcode.text = (editPropertyArray[0]["zipcode"] as! NSString as String)
            }
            else {
                cell.zipcode.text = ""
            }
            
            if let state = editPropertyArray[0]["state"] as? NSString {
                cell.stateTypeLabel.text = editPropertyArray[0]["state"] as! NSString as String
            }
            else {
                cell.stateTypeLabel.text = ""
            }
            
            if (editPropertyArray[0]["price_per_plate_status"] as! Int == 1) {
                if let price_per_plate = editPropertyArray[0]["price_per_plate"] as? NSString {
                    cell.ratePerPlate.text = editPropertyArray[0]["price_per_plate"] as! NSString as! String
                    price_per_plate_status = true
                    
                }
                else {
                    cell.ratePerPlate.text = ""
                    price_per_plate_status = false
                }
            }
            else {
                cell.ratePerPlate.text = ""
                price_per_plate_status = false
            }
            
        }
        else {
            
            cell.stateTypeLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            cell.cityTypeLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            cell.selectedAreaLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            cell.pricerangeLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            cell.venueTypeLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            
            cell.email.text = NSUserDefaults.standardUserDefaults().objectForKey("email") as! NSString as String
            cell.venueTitle.text = cell.venueTitle.text
            cell.address.text = cell.address.text
            cell.propertyCapacity.text = cell.propertyCapacity.text
            cell.cityTypeLabel.text = " Please select city"
            cell.coveredArea.text = cell.coveredArea.text
            cell.desc.text = cell.desc.text
            cell.mobile.text = cell.mobile.text
            cell.parkingCapacity.text = cell.parkingCapacity.text
            cell.pricerangeLabel.text = " Please select price range"
            cell.venueTypeLabel.text = " Please select venue"
            cell.rooms.text = cell.rooms.text
            cell.website.text = cell.website.text
            cell.zipcode.text = cell.zipcode.text
            cell.stateTypeLabel.text = " Please select state"
            cell.ratePerPlate.text = cell.ratePerPlate.text
            cell.addPriceRangeButton.setBackgroundImage(UIImage(named: "black-dot.png"), forState: UIControlState.Normal)
            //            selectPriceOption()
            
            if (appDelegate.addEditPropertySelectedArea.count > 0) {
                cell.selectedAreaLabel.text = "  \(propertyName)"
                cell.areaId = (appDelegate.addEditPropertySelectedArea[0]["id"] as! NSNumber).stringValue
            }
            else {
                cell.selectedAreaLabel.text = " Please select area"
                cell.areaId = ""
            }
            cell.pricerangeLabel.hidden = false
            cell.ratePerPlate.hidden = true
            cell.ratePerPlateLabel.hidden = true
            cell.priceRangeLabel.hidden = false
        }
        
        if ( price_per_plate_status == true && price_range_status == false) {
            cell.ratePerPlate.hidden = false
            cell.pricerangeView.hidden = true
            cell.ratePerPlateLabel.hidden = false
            cell.priceRangeLabel.hidden = true
            cell.addPricePerPlateButton.setBackgroundImage(UIImage(named: "black-dot.png"), forState: UIControlState.Normal)
            cell.addPriceRangeButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            cell.bothOptionPriceButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            //cell.saveButtonHeight.constant = 115
            cell.ratePerPlateHeight.constant = 8
        }
        
        // selecting redio button option
        
        if ( price_range_status == true && price_per_plate_status == false) {
            cell.pricerangeView.hidden = false
            cell.ratePerPlate.hidden = true
            cell.ratePerPlateLabel.hidden = true
            cell.priceRangeLabel.hidden = false
            cell.addPriceRangeButton.setBackgroundImage(UIImage(named: "black-dot.png"), forState: UIControlState.Normal)
            cell.bothOptionPriceButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            cell.addPricePerPlateButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            //cell.saveButtonHeight.constant = 75
            cell.ratePerPlateHeight.constant = 75
        }
        
        if (price_per_plate_status == true && price_range_status == true) {
            cell.pricerangeView.hidden = false
            cell.ratePerPlate.hidden = false
            cell.ratePerPlateLabel.hidden = false
            cell.priceRangeLabel.hidden = false
            cell.bothOptionPriceButton.setBackgroundImage(UIImage(named: "black-dot.png"), forState: UIControlState.Normal)
            cell.addPriceRangeButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            cell.addPricePerPlateButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            //cell.saveButtonHeight.constant = 115
            cell.ratePerPlateHeight.constant = 75
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("openSearchController"))
        tapGesture.cancelsTouchesInView = true
        cell.selectedAreaLabel.addGestureRecognizer(tapGesture)
        
        cell.addPricePerPlateButton.addTarget(self, action: "tapGestureOption1", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addPriceRangeButton.addTarget(self, action: "tapGestureOption2", forControlEvents: UIControlEvents.TouchUpInside)
        cell.bothOptionPriceButton.addTarget(self, action: "tapGestureOption3", forControlEvents: UIControlEvents.TouchUpInside)
//        cell.addPropertyButton.addTarget(self, action: "savePropertyInfo", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell
    }
    
    func selectPriceOption () {
        
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! addPropertyTableViewCell
        
        if ( price_per_plate_status == true && price_range_status == false) {
            cell.ratePerPlate.hidden = false
            cell.pricerangeView.hidden = true
            cell.ratePerPlateLabel.hidden = false
            cell.priceRangeLabel.hidden = true
            //cell.saveButtonHeight.constant = 115
            cell.ratePerPlateHeight.constant = 8
            
        }
        
        if ( price_range_status == true && price_per_plate_status == false) {
            cell.pricerangeView.hidden = false
            cell.ratePerPlate.hidden = true
            cell.ratePerPlateLabel.hidden = true
            cell.priceRangeLabel.hidden = false
            //cell.saveButtonHeight.constant = 65
            cell.ratePerPlateHeight.constant = 75
            
        }
        
        if (price_per_plate_status == true && price_range_status == true) {
            cell.pricerangeView.hidden = false
            cell.ratePerPlate.hidden = false
            cell.ratePerPlateLabel.hidden = false
            cell.priceRangeLabel.hidden = false
            //cell.saveButtonHeight.constant = 115
            cell.ratePerPlateHeight.constant = 75
            
        }
        //tableView.reloadData()
    }
    
    // select rate per plate
    
    func tapGestureOption1() {
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! addPropertyTableViewCell
        cell.addPricePerPlateButton.setBackgroundImage(UIImage(named: "black-dot.png"), forState: UIControlState.Normal)
        cell.addPriceRangeButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        cell.bothOptionPriceButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        cell.ratePerPlateLabel.hidden = false
        cell.priceRangeLabel.hidden = true
        price_range_status = false
        price_per_plate_status = true
        
        if (editPropertyArray.count > 0) {
            if let price_per_plate = editPropertyArray[0]["price_per_plate"] as? NSString {
                cell.ratePerPlate.text = editPropertyArray[0]["price_per_plate"] as! NSString as! String
                
            } else {
                cell.ratePerPlate.text = ""
            }
        }
        else {
            cell.ratePerPlate.text = ""
        }
        selectPriceOption()
    }
    
    // select price range
    
    func tapGestureOption2() {
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! addPropertyTableViewCell
        cell.addPricePerPlateButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        cell.addPriceRangeButton.setBackgroundImage(UIImage(named: "black-dot.png"), forState: UIControlState.Normal)
        cell.bothOptionPriceButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        cell.ratePerPlateLabel.hidden = true
        cell.priceRangeLabel.hidden = false
        price_range_status = true
        price_per_plate_status = false
        if (editPropertyArray.count > 0) {
            if let price_per_plate = editPropertyArray[0]["price_range"] as? NSString {
                cell.pricerangeLabel.text = editPropertyArray[0]["price_range"] as! NSString as? String
            }
            else {
                cell.pricerangeLabel.text = ""
                cell.pricerangeLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            }
        }
        else {
            cell.pricerangeLabel.text = " Please select price range"
            cell.pricerangeLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        }
        selectPriceOption()
        
    }
    
    // select none option
    
    func tapGestureOption3() {
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! addPropertyTableViewCell
        cell.addPricePerPlateButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        cell.addPriceRangeButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        cell.bothOptionPriceButton.setBackgroundImage(UIImage(named: "black-dot.png"), forState: UIControlState.Normal)
        cell.ratePerPlateLabel.hidden = true
        cell.priceRangeLabel.hidden = true
        price_range_status = true
        price_per_plate_status = true
        
        if (editPropertyArray.count > 0) {
            if let price_per_plate = editPropertyArray[0]["price_range"] as? NSString {
                cell.pricerangeLabel.text = editPropertyArray[0]["price_range"] as! NSString as? String
            }
            else {
                cell.pricerangeLabel.text = " Please select price range"
                cell.pricerangeLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
                
            }
            
            if let price_per_plate = editPropertyArray[0]["price_per_plate"] as? NSString {
                cell.ratePerPlate.text = editPropertyArray[0]["price_per_plate"] as! NSString as! String
                
            } else {
                cell.ratePerPlate.text = ""
            }
            
        }
        else {
            cell.pricerangeLabel.text = " Please select price range"
            cell.pricerangeLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            cell.ratePerPlate.text = ""
        }
        selectPriceOption()
    }
    
    // calling area view controller
    
    func openSearchController() {
        
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! addPropertyTableViewCell
        
        if (cell.cityTypeLabel.text == "" || cell.cityTypeLabel.textColor == UIColor.grayColor().colorWithAlphaComponent(0.5)) {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Please select city"
            loadingProgress.hide(true, afterDelay: 1)
        }
        else {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingProgress.labelText = "Loading"
            //loadingProgress.detailsLabelText = "Please wait"
            var methodType: String = "GET"
            var base: String = "areas/get_areas_by_city_name?city_name="
            var param: String = cell.cityTypeLabel.text!
            var urlRequest: String = base + param
            var serviceCall : WebServiceCall = WebServiceCall()
            
            serviceCall.searchPropertyApiCallRequest(methodType, urlRequest: urlRequest, param:[:], completion: {(resultData, error) -> Void in
                if error != "" {
                    //MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    loadingProgress.mode = MBProgressHUDMode.Text
                    loadingProgress.detailsLabelText = "Record not found"
                    loadingProgress.hide(true, afterDelay: 1)
                    //self.appDelegate.showNetworkErrorView()
                    
                }
                else {
                    
                    if (cell.cityTypeLabel.text!.isEmpty) {
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.detailsLabelText = "Please select city"
                        loadingProgress.hide(true, afterDelay: 1)
                    }
                    else {
                        self.areaListArray = serviceCall.getAreaArray(resultData!)
                        self.getAreasArray()
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        //self.contentView.hidden = false
                        
                        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        var dash : addPropertyAreaViewController = storyBoard.instantiateViewControllerWithIdentifier("addPropertyAreaViewController") as! addPropertyAreaViewController
                        dash.selectedCity = cell.cityTypeLabel.text!
                        dash.areaList = self.areaArray
                        self.navigationController?.pushViewController(dash, animated: true)
                    }
                    
                }
                
            })
        }
        
        
    }
    
    func getAreasArray () {
        areaArray = areaListArray as! NSMutableArray
    }
    
    @IBAction func savePropertyInfo(sender : AnyObject) {
        var propertySegment = self.parentViewController as! propertyInfoSegmentViewController
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! addPropertyTableViewCell
        var method = "PUT"
        var baseString: String = "properties/\(propertyId)"
        
        var flag = validate()
        
        if (flag == true) {
            
            var addPropertydetails = [:]
            var ratePerPlate = ""
            if (self.price_per_plate_status == false ) {
                ratePerPlate = "0"
            
            } else  {
                
               ratePerPlate  = cell.ratePerPlate.text
            }
            
            var website = ""
            
            if (cell.website.text.isEmpty) {
               website = cell.website.text
            }
            else {
                website = "http://\(cell.website.text)"
            }
            
            if (editPropertyArray.count > 0) {
                addPropertydetails = [
                    "email":cell.email.text,
                    "name":cell.venueTitle.text,
                    "address_line_1":cell.address.text,
                    "capacity":cell.propertyCapacity.text,
                    "area_id":cell.areaId,
                    "covered_area":cell.coveredArea.text,
                    "description":cell.desc.text,
                    "mobile_number":cell.mobile.text,
                    "parking":cell.parkingCapacity.text,
                    "price_range_id":cell.priceId,
                    "property_type_id":cell.venueId,
                    "rooms":cell.rooms.text,
                    "website":"\(cell.website.text)",
                    "zipcode":cell.zipcode.text,
                    "price_per_plate": ratePerPlate,
                    "price_per_plate_status": self.price_per_plate_status,
                    "price_range_status":self.price_range_status,
                    
                ]
                
                var property = [
                    "property":addPropertydetails
                ]
                
                var connection = appDelegate.checkConnection()
                if (connection == true) {
                    
                    propertySegment.changeSegmentStatus(true)
                    var methodType: String = method
                    var base: String = baseString
                    //            var param :NSDictionary= [:]
                    var urlRequest: String = base
                    var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String
                    var serviceCall : WebServiceCall = WebServiceCall()
                    
                    let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    
                    serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param: property, authentication: authentication, completion: { (resultData, response) -> Void in
                        if resultData == nil {
                            loadingProgress.labelText = "Data Not Found"
                            loadingProgress.hide(true, afterDelay: 2)
                        }
                        else {
                            if (response.statusCode == 200 || response.statusCode == 201) {
                                
                                if (self.editPropertyArray.count > 0) {
                                    self.appDelegate.addPropertyMode = false
                                }
                                
                                self.editPropertyArray = []
                                self.newEditPropertyListArray = serviceCall.getEditPropertyArray(resultData!)
                                //println(self.newEditPropertyListArray)
                                self.editPropertyArray = self.newEditPropertyListArray as! NSMutableArray
                                dashData.sharedInstance.selectedPropertyDetailsArray = self.editPropertyArray
                                loadingProgress.mode = MBProgressHUDMode.Text
                                loadingProgress.detailsLabelText = "Save Successfully"
                                self.propertyName = self.editPropertyArray[0]["name"] as! NSString as String
                                //self.navigationItem.title = self.propertyName
                                self.navigationController?.navigationBar.topItem?.title = self.propertyName
                                self.propertyId = self.editPropertyArray[0]["id"] as! NSNumber as Int
                                propertySegment.changeSegmentStatus(false)
                                self.tableView.reloadData()
//                                var propertySegment = self.parentViewController as! propertyInfoSegmentViewController
//                                propertySegment.segmentControl.selectedSegmentIndex = 1
//                                propertySegment.segmentCall(1);
                                NSNotificationCenter.defaultCenter().postNotificationName("updatePropertyList", object: nil)
                                loadingProgress.hide(true, afterDelay: 2)
                                self.navigationController?.popViewControllerAnimated(true)
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let dash:DashBoardViewController = storyBoard.instantiateViewControllerWithIdentifier("DashboardView") as! DashBoardViewController
                                
                                dash.navigationController?.navigationBar.topItem?.title = self.propertyName
                                //dash.selectedPropertyDetailsArray = self.editPropertyArray
                                self.navigationController?.popToViewController(dash, animated: true)
                                
                                
                            }
                            else {
                                
                                if (response.statusCode == 422) {
                                    self.newEditPropertyListArray = serviceCall.addPropertyDetails(resultData!)
                                    loadingProgress.mode = MBProgressHUDMode.Text
                                    var errorMsg: NSArray = self.newEditPropertyListArray.valueForKey("error") as! NSArray
                                    
                                    var msg = errorMsg as NSArray
                                    //println(msg[0]["website"])
                                    loadingProgress.detailsLabelText = "\(msg[0] as! NSDictionary)"
                                    loadingProgress.hide(true, afterDelay:2)
                                }
                                else {
                                    loadingProgress.mode = MBProgressHUDMode.Text
                                    loadingProgress.detailsLabelText = "Not Saved"
                                }
                                
                            }
                        }
                        
                        
                        loadingProgress.hide(true, afterDelay: 2.0)
                    })
                }
                else {
                    appDelegate.showNetworkErrorView()
                }
                
                
            }
            else {
                
                if (editPropertyArray.count == 0) {
                    priceRangeId = cell.priceId
                    areaId = (appDelegate.addEditPropertySelectedArea[0]["id"] as! NSNumber).stringValue
                    cityId = cell.cityId
                    stateId = cell.stateId
                    venueTypeId = cell.venueId
                    method = "POST"
                    baseString = "properties"
                    
                }
                
                addPropertydetails = [
                    "email":cell.email.text,
                    "name":cell.venueTitle.text,
                    "address_line_1":cell.address.text,
                    "capacity":cell.propertyCapacity.text,
                    "area_id":cell.areaId,
                    "covered_area":cell.coveredArea.text,
                    "description":cell.desc.text,
                    "mobile_number":cell.mobile.text,
                    "parking":cell.parkingCapacity.text,
                    "price_range_id":cell.priceId,
                    "property_type_id":cell.venueId,
                    "rooms":cell.rooms.text,
                    "website":website,
                    "zipcode":cell.zipcode.text,
                    "price_per_plate":ratePerPlate,
                    "price_per_plate_status": self.price_per_plate_status,
                    "price_range_status":self.price_range_status,
                    "state_id":stateId,
                    "city_id":cityId
                    
                ]
                
                
                var property = [
                    "property":addPropertydetails
                ]
                
                var connection = appDelegate.checkConnection()
                
                if (connection == true) {
                    var methodType: String = method
                    var base: String = baseString
                    //            var param :NSDictionary= [:]
                    var urlRequest: String = base
                    var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String
                    var serviceCall : WebServiceCall = WebServiceCall()
                    
                    let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    
                    serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param: property, authentication: authentication, completion: { (resultData, response) -> Void in
                        
                        if resultData == nil {
                            loadingProgress.mode = MBProgressHUDMode.Text
                            loadingProgress.detailsLabelText = "Data Not Found"
                            loadingProgress.hide(true, afterDelay: 2.0)
                        }
                        else {
                            if (response.statusCode == 200 || response.statusCode == 201) {
                                
                                self.editPropertyArray = []
                                self.newEditPropertyListArray = serviceCall.addPropertyDetails(resultData!)
                                
                                self.editPropertyArray = self.newEditPropertyListArray as! NSMutableArray
                                loadingProgress.mode = MBProgressHUDMode.Text
                                loadingProgress.detailsLabelText = "Save Successfully"
                                self.navigationItem.title = self.editPropertyArray[0]["name"] as! NSString as String
                                self.propertyId = self.editPropertyArray[0]["id"] as! NSNumber as Int
                                if (self.editPropertyArray.count > 0) {
                                    self.appDelegate.addPropertyMode = false
                                }
                                self.tableView.reloadData()
                                //println(self.editPropertyArray)
                                NSNotificationCenter.defaultCenter().postNotificationName("updatePropertyList", object: nil)
                                var property = self.parentViewController as! propertyInfoSegmentViewController
                                self.appDelegate.addNewPropertyArray = self.editPropertyArray
                                property.segmentControl.selectedSegmentIndex = 1
                                property.segmentCall(1);
                            }
                            else if (response.statusCode == 422) {
                                self.newEditPropertyListArray = serviceCall.addPropertyDetails(resultData!)
                                loadingProgress.mode = MBProgressHUDMode.Text
                                var errorMsg: NSArray = self.newEditPropertyListArray.valueForKey("error") as! NSArray
                            
                                var msg = errorMsg as NSArray
                                //println(msg[0]["website"])
                                loadingProgress.detailsLabelText = "\(msg[0] as! NSDictionary)"
                                loadingProgress.hide(true, afterDelay:2)
                            }
                            else {
                                loadingProgress.mode = MBProgressHUDMode.Text
                                loadingProgress.detailsLabelText = "Not Saved"
                            }
                        }
                        
                        loadingProgress.hide(true, afterDelay: 2.0)
                    })
                }
                else {
                    appDelegate.showNetworkErrorView()
                }
                
                
            }
            
        }
        
        
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func validate() -> Bool {
        var flag:Bool = true
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! addPropertyTableViewCell
        if (cell.email.text.isEmpty) {
            cell.email.attributedPlaceholder = NSAttributedString(string:"Please enter email", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
        }
        
        if (cell.venueTitle.text.isEmpty) {
            
            cell.venueTitle.attributedPlaceholder = NSAttributedString(string:"Please select venue title", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
            
        }
        
        if (cell.desc.text.isEmpty) {
            
            cell.desc.attributedPlaceholder = NSAttributedString(string:"Please enter description", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
        }
        
        if (cell.address.text.isEmpty) {
            
            cell.address.attributedPlaceholder = NSAttributedString(string:"Please enter address", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
            
        }
        
        if (cell.venueTypeLabel.text == "") {
            cell.venueTypeLabel.text = "Please select venue"
            cell.venueTypeLabel.textColor = UIColor.redColor()
            cell.venueTypeLabel.font = UIFont(name: "Arial", size: 14)
            flag = false
        }
        
        if (cell.stateTypeLabel.text == "") {
            cell.stateTypeLabel.text = "Please select state"
            cell.stateTypeLabel.textColor = UIColor.redColor()
            cell.stateTypeLabel.font = UIFont(name: "Arial", size: 14)
            flag = false
        }
        
        if (cell.cityTypeLabel.text == "") {
            cell.cityTypeLabel.text = "Please select city"
            cell.cityTypeLabel.textColor = UIColor.redColor()
            cell.cityTypeLabel.font = UIFont(name: "Arial", size: 14)
            flag = false
        }
        
        if (cell.pricerangeLabel.text == "") {
            cell.pricerangeLabel.text = "Please select price range"
            cell.pricerangeLabel.textColor = UIColor.redColor()
            cell.pricerangeLabel.font = UIFont(name: "Arial", size: 14)
            flag = false
        }
        
        if (cell.selectedAreaLabel.text == "") {
            
            cell.selectedAreaLabel.text = " Please select area"
            cell.selectedAreaLabel.textColor = UIColor.redColor()
            cell.selectedAreaLabel.font = UIFont(name: "Arial", size: 14)
            flag = false
            
        }
        
        if (cell.zipcode.text.isEmpty) {
            
            cell.zipcode.attributedPlaceholder = NSAttributedString(string:"Please enter zipcode", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
            
        }
        
        if (cell.propertyCapacity.text.isEmpty) {
            
            cell.propertyCapacity.attributedPlaceholder = NSAttributedString(string:"Please select property capacity", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
            
        }
        
        if (cell.parkingCapacity.text.isEmpty) {
            
            cell.parkingCapacity.attributedPlaceholder = NSAttributedString(string:"Please select parking capacity", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
            
        }
        
        return flag
    }
    
}
