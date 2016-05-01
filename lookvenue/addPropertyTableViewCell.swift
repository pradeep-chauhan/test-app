//
//  addPropertyTableViewCell.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 10/6/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class addPropertyTableViewCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate, SBPickerSelectorDelegate {
    
    @IBOutlet weak var ratePerPlateHeight: NSLayoutConstraint!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var venueTitle: UITextField!
    @IBOutlet weak var parkingCapacity: UITextField!
    @IBOutlet weak var coveredArea: UITextField!
    @IBOutlet weak var propertyCapacity: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var rooms: UITextField!
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var bothOptionPriceButton: UIButton!
    @IBOutlet weak var addPricePerPlateButton: UIButton!
    @IBOutlet weak var addPriceRangeButton: UIButton!
    @IBOutlet weak var ratePerPlateLabel: UILabel!
    @IBOutlet weak var selectedAreaLabel: UILabel!
    @IBOutlet weak var website: UITextField!
   
    @IBOutlet weak var ratePerPlate: UITextField!
    @IBOutlet weak var mobile: UITextField!
    
    @IBOutlet weak var addPropertyButton: UIButton!
    
    @IBOutlet weak var venueTypeView: UIView!
    @IBOutlet weak var venueTypeLabel: UILabel!
    
    @IBOutlet weak var stateTypeView: UIView!
    @IBOutlet weak var stateTypeLabel: UILabel!
    
    @IBOutlet weak var cityTypeView: UIView!
    @IBOutlet weak var cityTypeLabel: UILabel!
    
    @IBOutlet weak var pricerangeView: UIView!
    @IBOutlet weak var pricerangeLabel: UILabel!
    
//    var window: UIWindow?
    var pickerSelectValue = ""
    var multiselectViewCall: String!
    var currentlySelectedTextField = UITextField()
    
    var vanueListArray : NSArray!
    var vanuesArray : NSMutableArray = NSMutableArray()
    var venueListData : NSMutableArray = NSMutableArray()
    
    var rangeListArray : NSArray!
    var rangeArray : NSMutableArray = NSMutableArray()
    var rangeListData : NSMutableArray = NSMutableArray()
    
    var cityNamesArray: NSMutableArray = NSMutableArray()
    var stateNamesArray: NSMutableArray = NSMutableArray()
    
    var areaListArray : NSArray!
    var areaArray : NSMutableArray = NSMutableArray()
    var searchableAreaList : NSMutableArray = NSMutableArray()
    var resultArray: NSMutableArray! = NSMutableArray()
    
    var priceListArray : NSArray = NSArray()
    var priceArray : NSMutableArray = NSMutableArray()
    var priceListData : NSMutableArray = NSMutableArray()
    
    var searchListArray : NSArray!
    var searchArray : NSMutableArray = NSMutableArray()
    
    var cityListArray:NSArray = NSArray()
    var cityArray:NSMutableArray = NSMutableArray()
    
    var stateListArray:NSArray = NSArray()
    var stateArray:NSMutableArray = NSMutableArray()
    
    var priceId = ""
    var areaId =  ""
    var venueId = ""
    var cityId = ""
    var stateId = ""
    
    var selectedDate = ""
    var searchDetails: SearchDetails = SearchDetails()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let view = UIView()
    
    var picker: SBPickerSelector = SBPickerSelector.picker()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.email.delegate = self
        self.venueTitle.delegate = self
        //self.venueType.delegate = self
        self.zipcode.delegate = self
        self.email.delegate = self
        self.venueTitle.delegate = self
        self.parkingCapacity.delegate = self
        self.coveredArea.delegate = self
        self.propertyCapacity.delegate = self
        self.desc.delegate = self
        //self.venueType.delegate = self
        self.rooms.delegate = self
        self.address.delegate = self
        self.website.delegate = self
        self.mobile.delegate = self
        self.ratePerPlate.delegate = self
        
        self.selectedAreaLabel.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.selectedAreaLabel.layer.borderWidth = 0.5
        self.selectedAreaLabel.layer.cornerRadius = 5
        
        self.addPricePerPlateButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.addPricePerPlateButton.layer.borderWidth = 0.5
        self.addPricePerPlateButton.layer.cornerRadius = 10
        
        self.addPriceRangeButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.addPriceRangeButton.layer.borderWidth = 0.5
        self.addPriceRangeButton.layer.cornerRadius = 10
        
        self.bothOptionPriceButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.bothOptionPriceButton.layer.borderWidth = 0.5
        self.bothOptionPriceButton.layer.cornerRadius = 10
        
        self.venueTypeView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.venueTypeView.layer.borderWidth = 0.5
        self.venueTypeView.layer.cornerRadius = 5
        self.venueTypeView.clipsToBounds = true
        
        self.stateTypeView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.stateTypeView.layer.borderWidth = 0.5
        self.stateTypeView.layer.cornerRadius = 5
        self.stateTypeView.clipsToBounds = true
        
        self.cityTypeView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.cityTypeView.layer.borderWidth = 0.5
        self.cityTypeView.layer.cornerRadius = 5
        self.cityTypeView.clipsToBounds = true
        
        self.pricerangeView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.pricerangeView.layer.borderWidth = 0.5
        self.pricerangeView.layer.cornerRadius = 5
        self.pricerangeView.clipsToBounds = true
        
        let venueTypeViewTap = UITapGestureRecognizer(target: self, action: "venueTypePicker")
        venueTypeViewTap.delegate = self
        venueTypeView.addGestureRecognizer(venueTypeViewTap)
        
        let stateTypeViewTap = UITapGestureRecognizer(target: self, action: "stateListPicker")
        stateTypeViewTap.delegate = self
        stateTypeView.addGestureRecognizer(stateTypeViewTap)
        
        let cityTypeViewTap = UITapGestureRecognizer(target: self, action: "cityListPicker")
        cityTypeViewTap.delegate = self
        cityTypeView.addGestureRecognizer(cityTypeViewTap)
        
        let priceRangeViewTap = UITapGestureRecognizer(target: self, action: "priceListPicker")
        priceRangeViewTap.delegate = self
        pricerangeView.addGestureRecognizer(priceRangeViewTap)
        
        //self.addPropertyButton.layer.cornerRadius = 5
        //self.addPropertyButton.backgroundColor = appDelegate.mainColor
        self.venueName()
        self.priceName()
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // keyboard hide
    
    func animateTextField(textField: UITextField, up: Bool, withOffset offset:CGFloat)
    {
        let movementDistance : Int = -Int(offset)
        let movementDuration : Double = 0.4
        let movement : Int = (up ? movementDistance : -movementDistance)
        UITableViewCell.beginAnimations("animateTextField", context: nil)
        UITableViewCell.setAnimationBeginsFromCurrentState(true)
        UITableViewCell.setAnimationDuration(movementDuration)
        self.frame = CGRectOffset(self.frame, 0, CGFloat(movement))
        UITableViewCell.commitAnimations()
    }
    
    
    
    func cancelNumberPad() {
        
        self.window?.endEditing(true)
        
    }
    
    func doneWithNumberPad() {
        
        if ( currentlySelectedTextField == mobile) {
            var numberFromTheKeyboard: String = mobile.text
        }
        
        if ( currentlySelectedTextField == zipcode) {
            var numberFromTheKeyboard: String = zipcode.text
        }
        
        if ( currentlySelectedTextField == rooms) {
            var numberFromTheKeyboard: String = rooms.text
        }
        
        if ( currentlySelectedTextField == ratePerPlate) {
            var numberFromTheKeyboard: String = ratePerPlate.text
        }
        
        if ( currentlySelectedTextField == coveredArea) {
            var numberFromTheKeyboard: String = coveredArea.text
        }
        
        if ( currentlySelectedTextField == parkingCapacity) {
            var numberFromTheKeyboard: String = parkingCapacity.text
        }
        
        if ( currentlySelectedTextField == propertyCapacity) {
            var numberFromTheKeyboard: String = propertyCapacity.text
        }
        
        self.window!.endEditing(true)
    }
    
    // textField Delegates
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //self.currentlySelectedTextField.resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.window!.endEditing(true)
    }
    
    @IBAction func areaSelect(sender: AnyObject) {
        
    }
    
    
//    @IBAction func capacity(sender: AnyObject) {
//        currentlySelectedTextField = email
//        pickerSelectValue = "capacity"
//        let picker: SBPickerSelector = SBPickerSelector.picker()
//        picker.numberOfComponents = 3
//        picker.pickerData = [["100","500","800","1000","1200","1500","2000","2500","2500"],["-"],["500","800","1000","1200","1500","2000","2500","3000","5000"]] //picker content
//        picker.delegate = self
//        picker.pickerType = SBPickerSelectorType.Text
//        picker.doneButtonTitle = "Done"
//        picker.cancelButtonTitle = "Cancel"
//        picker.optionsToolBar.tintColor =  appDelegate.mainColor
//        
//        let point: CGPoint = window!.convertPoint(sender.frame.origin, fromView: sender.superview)
//        var frame: CGRect = sender.frame
//        frame.origin = point
//        picker.showPickerIpadFromRect(frame, inView: self)
////        self.propertyCapacity.resignFirstResponder()
//        
//    }
    
    func venueName () {
        venueListData = []
        for ( var i = 0; i < appDelegate.venueArrayListAppDelegate.count; i++ ) {
            venueListData.addObject(appDelegate.venueArrayListAppDelegate[i]["name"] as! NSString as String)
        }
    }
    
    func getVenueId (name:String) -> String {
        var flag = false
        for ( var i = 0; i < appDelegate.venueArrayListAppDelegate.count; i++ ) {
            if ( appDelegate.venueArrayListAppDelegate[i]["name"] as! NSString as String == name) {
                venueId = (appDelegate.venueArrayListAppDelegate[i]["id"] as! NSNumber).stringValue
                flag = true
            }
        }
        if (flag == false) {
            venueId = ""
        }
        return venueId
    }
    
    func stateName () {
        stateNamesArray = []
        for ( var i = 0; i < stateArray.count; i++ ) {
            stateNamesArray.addObject(stateArray[i]["name"] as! NSString as String)
        }
    }
    
    func getStateId (name:String) -> String {
        var flag = false
        for ( var i = 0; i < stateArray.count; i++ ) {
            if ( stateArray[i]["name"] as! NSString as String == name) {
                stateId = (stateArray[i]["id"] as! NSNumber).stringValue
                flag = true
            }
        }
        if (flag == false) {
            stateId = ""
        }
        return stateId
    }
    
    func cityName () {
        cityNamesArray = []
        for ( var i = 0; i < cityArray.count; i++ ) {
            cityNamesArray.addObject(cityArray[i]["name"] as! NSString as String)
        }
    }
    
    func getCityId (name:String) -> String {
        var flag = false
        for ( var i = 0; i < cityArray.count; i++ ) {
            if ( cityArray[i]["name"] as! NSString as String == name) {
                cityId = (cityArray[i]["id"] as! NSNumber).stringValue
                flag = true
            }
        }
        if (flag == false) {
            cityId = ""
        }
        return cityId
    }
    
    
    func priceName () {
        priceListData = []
        for ( var i = 0; i < appDelegate.priceArrayListAppDelegate.count; i++ ) {
            priceListData.addObject(appDelegate.priceArrayListAppDelegate[i]["name"] as! NSString as String)
        }
    }
    
    func getPriceId (name:String) -> String {
        var flag = false
        for ( var i = 0; i < appDelegate.priceArrayListAppDelegate.count; i++ ) {
            
            if ( appDelegate.priceArrayListAppDelegate[i]["name"] as! NSString as String == name) {
                priceId = (appDelegate.priceArrayListAppDelegate[i]["id"] as! NSNumber).stringValue
                flag = true
            }
        }
        
        if (flag == false) {
            priceId = ""
        }
        return priceId
    }
    
    
    func venueTypePicker() {
        
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        let loadingProgress = MBProgressHUD.showHUDAddedTo(self.window, animated: true)
        loadingProgress.labelText = "Loading"
        //loadingProgress.detailsLabelText = "Please wait"
        var methodType: String = "GET"
        var base: String = "property_types/"
        var param: String = ""
        var urlRequest: String = base
        
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
                
                if (self.stateTypeLabel.text!.isEmpty) {
                    loadingProgress.mode = MBProgressHUDMode.Text
                    loadingProgress.detailsLabelText = "Please select state"
                    loadingProgress.hide(true, afterDelay: 1)
                }
                else {
                    self.vanueListArray = serviceCall.getVanueArray(resultData!)
                    self.getVanuesArray()
                    
                    self.pickerSelectValue = "venueType"
                    //let picker: SBPickerSelector = SBPickerSelector.picker()
                    self.picker.numberOfComponents = 1
                    self.picker.pickerData = self.venueListData as [AnyObject] //picker content
                    self.picker.delegate = self
                    self.picker.pickerType = SBPickerSelectorType.Text
                    self.picker.doneButtonTitle = "Done"
                    self.picker.cancelButtonTitle = "Cancel"
                    self.picker.optionsToolBar.tintColor =  self.appDelegate.mainColor
                    
                    let point: CGPoint = self.window!.convertPoint(self.frame.origin, fromView: self.superview)
                    var frame: CGRect = self.frame
                    frame.origin = point
                    self.picker.showPickerIpadFromRect(frame, inView: self)
                    MBProgressHUD.hideAllHUDsForView(self.window, animated: true)
                    //        self.priceRange.resignFirstResponder()
                    
                }
                
            }
            
        })
    }
    
    func pickerSelector(selector: SBPickerSelector!, selectedValue value: String!, index idx: Int) {
        
        if(pickerSelectValue == "priceList") {
            pricerangeLabel.text = value
            getPriceId(pricerangeLabel.text!)
            pricerangeLabel.textColor = UIColor.blackColor()
        }
        if(pickerSelectValue == "venueType") {
            venueTypeLabel.text = value
            getVenueId(venueTypeLabel.text!)
            venueTypeLabel.textColor = UIColor.blackColor()
        }
        if(pickerSelectValue == "cityList") {
            cityTypeLabel.text = value
            selectedAreaLabel.text = " Please select area"
            self.selectedAreaLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            getCityId(cityTypeLabel.text!)
            cityTypeLabel.textColor = UIColor.blackColor()
        }
        if(pickerSelectValue == "stateList") {
            stateTypeLabel.text = value
            cityTypeLabel.text = "Please select city"
            selectedAreaLabel.text = " Please select area"
            self.selectedAreaLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            self.cityTypeLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            getStateId(stateTypeLabel.text!)
            stateTypeLabel.textColor = UIColor.blackColor()
        }
    }
    
    func priceListPicker() {
        
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        let loadingProgress = MBProgressHUD.showHUDAddedTo(self.window, animated: true)
        loadingProgress.labelText = "Loading"
        //loadingProgress.detailsLabelText = "Please wait"
        var methodType: String = "GET"
        var base: String = "price_ranges"
        var param: String = ""
        var urlRequest: String = base
        
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
                
                if (self.stateTypeLabel.text!.isEmpty) {
                    loadingProgress.mode = MBProgressHUDMode.Text
                    loadingProgress.detailsLabelText = "Please select state"
                    loadingProgress.hide(true, afterDelay: 1)
                }
                else {
                    self.priceListArray = serviceCall.getPriceArray(resultData!)
                    self.getPriceArray()
                    
                    self.pickerSelectValue = "priceList"
                    //let picker: SBPickerSelector = SBPickerSelector.picker()
                    self.picker.numberOfComponents = 1
                    self.picker.pickerData = self.priceListData as [AnyObject] //picker content
                    self.picker.delegate = self
                    self.picker.pickerType = SBPickerSelectorType.Text
                    self.picker.doneButtonTitle = "Done"
                    self.picker.cancelButtonTitle = "Cancel"
                    self.picker.optionsToolBar.tintColor =  self.appDelegate.mainColor
                    
                    let point: CGPoint = self.window!.convertPoint(self.frame.origin, fromView: self.superview)
                    var frame: CGRect = self.frame
                    frame.origin = point
                    self.picker.showPickerIpadFromRect(frame, inView: self)
                    MBProgressHUD.hideAllHUDsForView(self.window, animated: true)
                    //        self.priceRange.resignFirstResponder()
                    
                }
                
            }
            
        })

    }
    
    func cityListPicker() {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        if (stateTypeLabel.text == "" || stateTypeLabel.textColor == UIColor.grayColor().colorWithAlphaComponent(0.5)) {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.window, animated: false)
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Please select state"
            loadingProgress.hide(true, afterDelay: 1)
        }
        else {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.window, animated: true)
            loadingProgress.labelText = "Loading"
            //loadingProgress.detailsLabelText = "Please wait"
            var methodType: String = "GET"
            var base: String = "cities/get_cities_by_states_name?state_name=\(stateTypeLabel.text!)"
            var param: String = ""
            var urlRequest: String = base
            
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
                    
                    if (self.stateTypeLabel.text!.isEmpty) {
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.detailsLabelText = "Please select state"
                        loadingProgress.hide(true, afterDelay: 1)
                    }
                    else {
                        self.cityListArray = serviceCall.getCityArray(resultData!)
                        self.getCityArray()
                        
                        self.pickerSelectValue = "cityList"
                        //let picker: SBPickerSelector = SBPickerSelector.picker()
                        self.picker.numberOfComponents = 1
                        self.picker.pickerData = self.cityNamesArray as [AnyObject] //picker content
                        self.picker.delegate = self
                        self.picker.pickerType = SBPickerSelectorType.Text
                        self.picker.doneButtonTitle = "Done"
                        self.picker.cancelButtonTitle = "Cancel"
                        self.picker.optionsToolBar.tintColor =  self.appDelegate.mainColor
                        
                        let point: CGPoint = self.window!.convertPoint(self.frame.origin, fromView: self.superview)
                        var frame: CGRect = self.frame
                        frame.origin = point
                        self.picker.showPickerIpadFromRect(frame, inView: self)
                        MBProgressHUD.hideAllHUDsForView(self.window, animated: true)
                        //self.contentView.hidden = false
                        
                    }
                    
                }
                
            })
        }
        
    }
    
    func getCityArray() {
        cityArray = cityListArray as! NSMutableArray
        cityName()
    }
    
    func getVanuesArray() -> Void
    {
        appDelegate.venueArrayListAppDelegate = []
        vanuesArray = vanueListArray as! NSMutableArray
        appDelegate.venueArrayListAppDelegate = vanuesArray
        venueName()
    }
    
    func getPriceArray() -> Void
    {
        appDelegate.priceArrayListAppDelegate = []
        priceArray = priceListArray as! NSMutableArray
        appDelegate.priceArrayListAppDelegate = priceArray
        priceName()
    }
    
    func getRangeArray() -> Void
    {
        rangeArray = rangeListArray as! NSMutableArray
        appDelegate.rangeArrayListAppDelegate = rangeArray
    }
    
    func getStateArray() {
        stateArray = stateListArray as! NSMutableArray
        stateName()
    }
    
    func stateListPicker() {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        let loadingProgress = MBProgressHUD.showHUDAddedTo(self.window, animated: true)
        loadingProgress.labelText = "Loading"
        //loadingProgress.detailsLabelText = "Please wait"
        var methodType: String = "GET"
        var base: String = "states/get_states_by_country_name?country_name="
        var param: String = "India"
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
                
                self.stateListArray = serviceCall.getStateArray(resultData!)
                self.getStateArray()
                self.pickerSelectValue = "stateList"
                //let picker: SBPickerSelector = SBPickerSelector.picker()
                self.picker.numberOfComponents = 1
                self.picker.pickerData = self.stateNamesArray as [AnyObject] //picker content
                self.picker.delegate = self
                self.picker.pickerType = SBPickerSelectorType.Text
                self.picker.doneButtonTitle = "Done"
                self.picker.cancelButtonTitle = ""
                self.picker.optionsToolBar.tintColor =  self.appDelegate.mainColor
                
                let point: CGPoint = self.window!.convertPoint(self.frame.origin, fromView: self.superview)
                var frame: CGRect = self.frame
                frame.origin = point
                self.picker.showPickerIpadFromRect(frame, inView: self)
                MBProgressHUD.hideAllHUDsForView(self.window, animated: true)
                
            }
            
        })
    }
    
    
    // validation 
    
    
}
