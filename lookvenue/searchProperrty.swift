//
//  searchProperrty.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 8/6/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class searchProperrty:UIViewController, UIScrollViewDelegate, UITextFieldDelegate,SHMultipleSelectDelegate, SBPickerSelectorDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var noneRadioButtonView: UIView!
    @IBOutlet weak var pricePerPlateRadioButtonView: UIView!
    @IBOutlet weak var priceRangeRadioButtonView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchButtonToNoneButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var noneButton: UIButton!
    @IBOutlet weak var perPlateHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var perPlateHorizontalLine: UIView!
    @IBOutlet weak var priceRangeHorizonalLine: UIView!
    @IBOutlet weak var perPlateButton: UIButton!
    @IBOutlet weak var priceRangeButton: UIButton!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var ratePerPlateLabel: UILabel!
    @IBOutlet weak var ratePerPlate: UITextField!
    @IBOutlet weak var dateOfEnquiry: UITextField!
    @IBOutlet weak var priceRange: UITextField!
    @IBOutlet weak var venueType: UITextField!
    @IBOutlet weak var city: UITextField!
   
    @IBOutlet weak var arealabelRed: UILabel!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var selectedAreaLabel: UILabel!
    var price_per_plate_status = false
    var price_range_status = false
    var currentlySelectedTextField = UITextField()
    var initialContentSizeForScrollView:CGFloat = 0.0
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //scrollView.delegate = self
    var multiselectViewCall: String!
    var cityStatus = false
    var pickerSelectValue = ""
    var perPlateMin:Int = Int()
    var perPlateMax:Int = Int()
    
    var vanueListArray : NSArray!
    var vanuesArray : NSMutableArray = NSMutableArray()
    var selectedVenueArray:NSMutableArray = NSMutableArray()
    
    var areaListArray : NSArray!
    var areaArray : NSMutableArray = NSMutableArray()
    
    var cityListArray : NSArray!
    var cityArray : NSMutableArray = NSMutableArray()
    
    var searchableAreaList : NSMutableArray = NSMutableArray()
    var resultArray: NSMutableArray! = NSMutableArray()
    var seletedAreaList:NSMutableArray = NSMutableArray()
    
    var priceListArray : NSArray!
    var priceArray : NSMutableArray = NSMutableArray()
    
    var rangeListArray : NSArray!
    var rangeArray : NSMutableArray = NSMutableArray()
    
    var searchListArray : NSArray!
    var searchArray : NSMutableArray = NSMutableArray()
    var selectedDate = ""
    var selectionCall:SHMultipleSelect = SHMultipleSelect()
    var searchDetails: SearchDetails = SearchDetails()
    var networkErrorUIView: networkErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set observer for network
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: NOTIFICATION_REACHABILITY_STATUS_CHANGED, object: nil)
        
        // setting ui for radio buuton
        
        self.searchButton.layer.cornerRadius = 5
        self.priceRangeButton.layer.cornerRadius = 10
        self.priceRangeButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.priceRangeButton.layer.borderWidth = 0.5
        
        self.perPlateButton.layer.cornerRadius = 10
        self.perPlateButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.perPlateButton.layer.borderWidth = 0.5
        
        self.noneButton.layer.cornerRadius = 10
        self.noneButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.noneButton.layer.borderWidth = 0.5
        
        self.selectedAreaLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        searchButton.backgroundColor = appDelegate.mainColor
        
        // scrollView Delegate
        
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = true
        self.scrollView.scrollEnabled = true
        
        initialContentSizeForScrollView = 0.0
        
        // Labels
        
        cityLabel.textColor = UIColor.redColor()
        arealabelRed.textColor = UIColor.redColor()
        venueLabel.textColor = UIColor.redColor()
        
        // Navigation style
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = appDelegate.mainColor
        // center image in nav bar
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "look-venue-logo.png")
        imageView.image = image
        //self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationItem.titleView = imageView
        
        // Adding Tap gesture on radio button view
        
        let pricePerPlateRadioButtonViewTapGesture = UITapGestureRecognizer(target: self, action: "perPlateButton:")
        pricePerPlateRadioButtonView.addGestureRecognizer(pricePerPlateRadioButtonViewTapGesture)
        pricePerPlateRadioButtonViewTapGesture.delegate = self
        
        let priceRangeRadioButtonViewTapGesture = UITapGestureRecognizer(target: self, action: "priceRange:")
        priceRangeRadioButtonView.addGestureRecognizer(priceRangeRadioButtonViewTapGesture)
        priceRangeRadioButtonViewTapGesture.delegate = self
        
        let noneRadioButtonViewTapGesture = UITapGestureRecognizer(target: self, action: "noneButton:")
        noneRadioButtonView.addGestureRecognizer(noneRadioButtonViewTapGesture)
        noneRadioButtonViewTapGesture.delegate = self
        
        // Checking
        
        if (appDelegate.firstTimeLogin == true) {
            let leftBarButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            // image for button
            leftBarButton.setImage(UIImage(named: "arrow-left.png"), forState: UIControlState.Normal)
            //set frame
            leftBarButton.frame = CGRectMake(0, 0,20, 20)
            leftBarButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            
            let leftMenubarButton = UIBarButtonItem(customView: leftBarButton)
            //assign button to navigationbar
            self.navigationItem.leftBarButtonItem = leftMenubarButton
        }
        else {
            let leftBarButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            //set image for button
            leftBarButton.setImage(UIImage(named: "menu-icon.png"), forState: UIControlState.Normal)
            //add function for button
            leftBarButton.addTarget(self, action: "leftSideMenuButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            //set frame
            leftBarButton.frame = CGRectMake(0, 0,20, 20)
            
            let leftMenubarButton = UIBarButtonItem(customView: leftBarButton)
            //assign button to navigationbar
            self.navigationItem.leftBarButtonItem = leftMenubarButton
        }
        
        // Opening area controller
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("openSearchController"))
        tapGesture.cancelsTouchesInView = true
        selectedAreaLabel.addGestureRecognizer(tapGesture)
        
        // Initialize Delegate
        
        dateOfEnquiry.delegate = self
        priceRange.delegate = self
        venueType.delegate = self
        city.delegate = self
        ratePerPlate.delegate = self
        
        // Checking area is already selected or not
        
        getSelectedAreaText()
        
        // initial set radio button
        
        perPlateButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        priceRangeButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        noneButton.setBackgroundImage(UIImage(named: "Dot.png"), forState: UIControlState.Normal)
        selectPriceOption()
        
        
        self.heightConstraint.constant = CGRectGetMaxY(self.searchButton.frame) + 16
        appDelegate.firstTimeLogin = false
        
        // check network status
        reachabilityStatusChanged()
    }

    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS:
            //view.backgroundColor = UIColor.redColor()
            
            dispatch_async(dispatch_get_main_queue()) {
//                let alert = UIAlertController(title: "No Internet Access", message: "Please ensure you have a connection to the internet.", preferredStyle: .Alert)
//                
//                let okAction = UIAlertAction(title: "OK", style: .Default) { action -> () in
//                    print("OK")
//                }
//                
//                alert.addAction(okAction)
//                
//                self.presentViewController(alert, animated: true, completion: nil)
                
                self.appDelegate.showNetworkErrorView()
            }
            
        default:
//            view.backgroundColor = UIColor.greenColor()
//            displayLabel.text = "Internet Access"
//            if .count == 0 {
//                callAPI()
//            } else {
//                print("No refresh required")
//            }
            
            getCities()
        }
    }
    
    // Api call for city
    
    func getCities () {
        self.contentView.hidden = true
        
        let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingProgress.labelText = "Loading"
        //loadingProgress.detailsLabelText = "Please wait"
        var methodType: String = "GET"
        var base: String = "cities/names"
        //var param: String = "Delhi/NCR"
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
                self.cityArray = []
                self.cityListArray = serviceCall.getCityNamesArray(resultData!)
                self.cityArray = self.cityListArray as! NSMutableArray
                self.getVenue()
                self.getPrice()
                self.getRange()
                
                if (NSUserDefaults.standardUserDefaults().objectForKey("remember_token") == nil || self.cityStatus == true) {
                    self.city(self.city)
                }
                
                self.contentView.hidden = false
                
            }
            
        })
    }
    
    // Api call for area
    
    func serviceCall () {
        
        //var connnection = appDelegate.checkConnection()
        //self.contentView.hidden = true
        
        let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingProgress.labelText = "Loading"
        //loadingProgress.detailsLabelText = "Please wait"
        var methodType: String = "GET"
        var base: String = "areas/get_areas_by_city_name?city_name="
        var param: String = appDelegate.selectedCity
        
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
                self.areaListArray = serviceCall.getAreaArray(resultData!)
                self.getAreasArray()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                //self.contentView.hidden = false
                
            }
            
        })
        
    }
    
    
    @IBAction func city(sender: AnyObject) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        pickerSelectValue = "city"
        let picker: SBPickerSelector = SBPickerSelector.picker()
        picker.numberOfComponents = 1
        picker.pickerData = cityArray as [AnyObject] //picker content
        picker.delegate = self
        picker.pickerType = SBPickerSelectorType.Text
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = ""
        picker.optionsToolBar.tintColor =  appDelegate.mainColor
        let point: CGPoint = view.convertPoint(sender.frame.origin, fromView: sender.superview)
        var frame: CGRect = sender.frame
        frame.origin = point
        picker.showPickerIpadFromRect(frame, inView: view)
        
        
    }
    
    func reloadView() {
        getCities()
    }
    
    func backButtonPressed() {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func cancelNumberPad() {
        ratePerPlate.resignFirstResponder()
    }
    
    func doneWithNumberPad() {
        var numberFromTheKeyboard: String = ratePerPlate.text
        ratePerPlate.resignFirstResponder()
    }
    
    // keyboard hide
    
//    func animateTextField(textField: UITextField, up: Bool, withOffset offset:CGFloat)
//    {
//        let movementDistance : Int = -Int(offset)
//        let movementDuration : Double = 0.4
//        let movement : Int = (up ? movementDistance : -movementDistance)
//        UIView.beginAnimations("animateTextField", context: nil)
//        UIView.setAnimationBeginsFromCurrentState(true)
//        UIView.setAnimationDuration(movementDuration)
//        self.view.frame = CGRectOffset(self.view.frame, 0, CGFloat(movement))
//        UIView.commitAnimations()
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        currentlySelectedTextField.resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.resignFirstResponder()
        self.currentlySelectedTextField.resignFirstResponder()
        //self.animateTextField(textField, up: true, withOffset: textField.frame.origin.y / 2)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.endEditing(true)
        self.currentlySelectedTextField.resignFirstResponder()
        //self.animateTextField(textField, up: false, withOffset: textField.frame.origin.y / 2)
    }
    
    // check area selection
    
    func getSelectedAreaText() {
        if (self.appDelegate.selectedArea.count > 0) {
            var areaName = ""
            for ( var i = 0; i < self.appDelegate.selectedArea.count; i++) {
                if (i == 0) {
                    areaName = self.appDelegate.selectedArea[i]["name"] as! NSString as String
                }
                else {
                    areaName = areaName + " \n " + (self.appDelegate.selectedArea[i]["name"] as! NSString as String)
                }
            }
            areaLabel.textColor = UIColor.blackColor()
            areaLabel.text = areaName
        }
        else {
            self.areaLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            areaLabel.text = " Please select area"
        }
    }
    
    // calling Area controller for area selection
    
    func openSearchController () {
        if (appDelegate.selectedCity == "" || areaArray.count == 0) {
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Please select city"
            city.text = ""
            areaLabel.text = ""
            validate()
            loadingProgress.hide(true, afterDelay: 1)
        }
        else {
            
            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
            var dash : searchAreaViewController = storyBoard.instantiateViewControllerWithIdentifier("searchAreaViewController") as! searchAreaViewController
            self.searchDetails.areaArray = areaArray
            dash.areaList = areaArray
            dash.selectedArea = appDelegate.selectedArea
            self.navigationController?.pushViewController(dash, animated: true)
        }
        
    }
    
    func leftSideMenuButtonPressed() {
        if (self.menuContainerViewController != nil) {
            self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in
                
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        getSelectedAreaText()
//        serviceCall()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    // venue array
    func getVanuesArray() -> Void
    {
        let newVenueListArray:NSMutableArray = vanueListArray as! NSMutableArray
        let alloprtionValue = ["name":"All"]
        newVenueListArray.insertObject(alloprtionValue, atIndex: 0)
        vanuesArray = newVenueListArray as NSMutableArray
        appDelegate.venueArrayListAppDelegate = vanuesArray
    }
    
    // Area array
    func getAreasArray() -> Void
    {
        areaArray = areaListArray as! NSMutableArray
        appDelegate.areaArrayListAppDelegate = areaArray
        appDelegate.availableAreaList = areaArray
    }
    
    // City array
    func getscityArray() -> Void
    {
        cityArray = cityListArray as! NSMutableArray
    }
    
    // Price array
    func getPriceArray() -> Void
    {
        let newPriceListArray:NSMutableArray = priceListArray as! NSMutableArray
        let alloptionValue = ["name":"All"]
        newPriceListArray.insertObject(alloptionValue, atIndex: 0)
        priceArray = newPriceListArray as NSMutableArray
        appDelegate.priceArrayListAppDelegate = priceArray
    }
    
    // Range array
    func getRangeArray() -> Void
    {
        rangeArray = rangeListArray as! NSMutableArray
        appDelegate.rangeArrayListAppDelegate = rangeArray
    }
    
    // Search venue array
    func getSearchVenueArray() -> Void
    {
        searchArray = searchListArray as! NSMutableArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func datePicker(sender: AnyObject) {
        pickerSelectValue = "date"
        let picker: SBPickerSelector = SBPickerSelector.picker()
        picker.delegate = self
        picker.pickerType = SBPickerSelectorType.Date
        picker.datePickerType = SBPickerSelectorDateType.OnlyDay
        
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
        picker.optionsToolBar.tintColor =  appDelegate.mainColor
        let point: CGPoint = view.convertPoint(sender.frame.origin, fromView: sender.superview)
        var frame: CGRect = sender.frame
        frame.origin = point
        picker.showPickerIpadFromRect(frame, inView: view)
        
    }
    
    // SBPicker Delegates
    
    func pickerSelector(selector: SBPickerSelector!, selectedValue value: String!, index idx: Int) {
        
        if(pickerSelectValue == "perPlate") {
            let max = appDelegate.rangeArrayListAppDelegate[0]["price_per_plate_max"] as! NSNumber
            let min = appDelegate.rangeArrayListAppDelegate[0]["price_per_plate_min"] as! NSNumber
            var coverdAreaString: String = value
            var coverdAreaStringArray = coverdAreaString.componentsSeparatedByString(" ")
            perPlateMin = (coverdAreaStringArray [0]).toInt()!
            perPlateMax = (coverdAreaStringArray [2]).toInt()!
            
            if ((perPlateMin >= min && perPlateMin <= perPlateMax) && (perPlateMax <= max && perPlateMax >= perPlateMin)) {
                ratePerPlate.text = value
            }
            else {
                ratePerPlate.text = ""
                let alert = UIAlertView()
                alert.title = "Warning !"
                alert.message = "Minimum value cannot be greater than equal to Max value"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
            self.ratePerPlate.resignFirstResponder()
        }
        
        if (pickerSelectValue == "city") {
            
            appDelegate.selectedCity = value
            city.text = appDelegate.selectedCity
            self.serviceCall()
            areaLabel.text = ""
            appDelegate.selectedArea = []
            getSelectedAreaText()
            self.city.resignFirstResponder()
        }
    }
    
    func pickerSelector(selector: SBPickerSelector!, cancelPicker cancel: Bool) {
        
    }
    
    func pickerSelector(selector: SBPickerSelector!, dateSelected date: NSDate!) {
        
        if(pickerSelectValue == "date") {
            
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            var dateFormatter = NSDateFormatter()
            var dateFormatter1 = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            self.dateOfEnquiry.text = dateFormatter.stringFromDate(date)
            self.selectedDate = dateFormatter1.stringFromDate(date)
            
        }
        
    }
    
    
    @IBAction func venueTypeButton(sender: AnyObject) {
        multiselectViewCall = "venue"
        //venueType.resignFirstResponder()
        if (vanuesArray.count > 0) {
            var venueTypemultipleSelect = SHMultipleSelect()
            venueTypemultipleSelect.selectedTextField = self.currentlySelectedTextField
            venueTypemultipleSelect.delegate = self
            venueTypemultipleSelect.rowsCount = self.vanuesArray.count
            venueTypemultipleSelect.show()
        }
        
    }
    
    // Api call for venue
    
    func getVenue() {
        
        multiselectViewCall = "venue"
        var methodType: String = "GET"
        var base: String = "property_types/"
        var param: String = ""
        var urlRequest: String = base
        var serviceCall : WebServiceCall = WebServiceCall()
        serviceCall.searchPropertyApiCallRequest(methodType, urlRequest: urlRequest, param:[:], completion: {(resultData, error) -> Void in
            if error != "" {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                loadingProgress.mode = MBProgressHUDMode.Text
                loadingProgress.detailsLabelText = "Record not found"
                loadingProgress.hide(true, afterDelay: 1)
                self.reloadView()
            }
            else {
                
                self.vanueListArray = serviceCall.getVanueArray(resultData!)
                if (self.vanueListArray.count > 0) {
                    self.getVanuesArray()
                }
            }
           
        })

    }
    
    // Api call for price range
    
    func getPrice () {
        
        multiselectViewCall = "price"
        var methodType: String = "GET"
        var base: String = "price_ranges"
        var param: String = ""
        var urlRequest: String = base
        
        var serviceCall : WebServiceCall = WebServiceCall()
        serviceCall.searchPropertyApiCallRequest(methodType, urlRequest: urlRequest, param:[:]) { (resultData, error) -> () in
            if error != "" {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                loadingProgress.mode = MBProgressHUDMode.Text
                loadingProgress.detailsLabelText = "Record not found"
                loadingProgress.hide(true, afterDelay: 1)
                self.reloadView()
            }
            else {
                self.priceListArray = serviceCall.getPriceArray(resultData!)
                if ( self.priceListArray.count > 0) {
                    self.getPriceArray()
                }
            }
            
        }
    }
    
    // Api call for range limit
    
    func getRange () {
        
        var methodType: String = "GET"
        var base: String = "properties/range_limit_for_property"
        var param: String = ""
        var urlRequest: String = base
        
        var serviceCall : WebServiceCall = WebServiceCall()
        serviceCall.searchPropertyApiCallRequest(methodType, urlRequest: urlRequest, param:[:]) { (resultData, error) -> () in
            if error != "" {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                loadingProgress.mode = MBProgressHUDMode.Text
                loadingProgress.detailsLabelText = "Record not found"
                loadingProgress.hide(true, afterDelay: 1)
                self.reloadView()
            }
            else {
                self.rangeListArray = serviceCall.getRangeArray(resultData!)
                if (self.rangeListArray.count > 0) {
                    self.getRangeArray()
                }
                self.contentView.hidden = false
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    
    
    @IBAction func pricePickerRange(sender: AnyObject) {
        multiselectViewCall = "price"
        if (priceArray.count > 0) {
            var priceRangemultipleSelect = SHMultipleSelect()
            priceRangemultipleSelect.selectedTextField = self.currentlySelectedTextField
            priceRangemultipleSelect.delegate = self
            priceRangemultipleSelect.rowsCount = self.priceArray.count
            priceRangemultipleSelect.show()
        }
        
        //self.priceRange.resignFirstResponder()
    }
    
    //For venue
    
    // Multiselect Delegate
    
    func multipleSelectView(multipleSelectView: SHMultipleSelect!, clickedBtnAtIndex clickedBtnIndex: Int, withSelectedIndexPaths selectedIndexPaths:[AnyObject]!) {
        if (multiselectViewCall == "venue") {
            
            if(selectedIndexPaths == nil) {
                searchDetails.venueSelected.removeAllObjects()
                self.venueType.text=""
                self.venueType.resignFirstResponder()
            }
            else {
                
                if (clickedBtnIndex == 0) {
                    
                    for (var i = 0; i < searchDetails.selectedVenueArray.count; i++){
                        
                        if(i == 0)
                        {
                            self.venueType.text = (searchDetails.selectedVenueArray[i]["name"] as! String)
                        }
                        else
                        {
                            self.venueType.text = self.venueType.text + "," + (searchDetails.selectedVenueArray[i]["name"] as! String)
                               
                        }
                       
                    }
                }
                
                else if(clickedBtnIndex == 1)
                {
                    searchDetails.venueSelected.removeAllObjects()
                    searchDetails.selectedVenueArray.removeAllObjects()
                    var indexPathsArray = selectedIndexPaths as NSArray
                    
                    for index in indexPathsArray {
                        if (index.row > 0) {
                            if(self.venueType.text == nil || self.venueType.text == "")
                            {
                                self.venueType.text = (vanuesArray[index.row]["name"] as! String)
                                searchDetails.venueSelected.addObject(vanuesArray[index.row]["id"] as! Int)
                                searchDetails.selectedVenueArray.addObject(vanuesArray[index.row])
                            }
                            else if(self.venueType.text != nil || self.venueType.text != "")
                            {
                                self.venueType.text = self.venueType.text + "," + (vanuesArray[index.row]["name"] as! String)
                                searchDetails.venueSelected.addObject(vanuesArray[index.row]["id"] as! Int)
                                searchDetails.selectedVenueArray.addObject(vanuesArray[index.row])
                            }
                                
                            else {
                                self.venueType.text=""
                            }
                        }
                       
                    }
                    
                }
                else {
                    self.venueType.text=""
                }
            }
        }
        
        
        if (multiselectViewCall == "price") {
            
            if(selectedIndexPaths == nil) {
                searchDetails.priceSelected.removeAllObjects()
                self.priceRange.text=""
                self.priceRange.resignFirstResponder()
            }
            else {
                
                if (clickedBtnIndex == 0) {
                    
                    for (var i = 0; i < searchDetails.selectedPriceArray.count; i++){
                        
                        if(i == 0)
                        {
                            self.priceRange.text = (searchDetails.selectedPriceArray[i]["name"] as! String)
                        }
                        else
                        {
                            self.priceRange.text = self.priceRange.text + "," + (searchDetails.selectedPriceArray[i]["name"] as! String)
                            
                        }
                        
                    }
                }
                    
                else if(clickedBtnIndex == 1)
                {
                    searchDetails.priceSelected.removeAllObjects()
                    searchDetails.selectedPriceArray.removeAllObjects()
                    var indexPathsArray = selectedIndexPaths as NSArray
                    
                    for index in indexPathsArray {
                        
                        if (index.row > 0) {
                            
                            if(self.priceRange.text == nil || self.priceRange.text == "" || index.row == 1)
                            {
                                self.priceRange.text = (priceArray[index.row]["name"] as! String)
                                searchDetails.priceSelected.addObject(priceArray[index.row]["id"] as! Int)
                                searchDetails.selectedPriceArray.addObject(priceArray[index.row])
                            }
                            else if(self.priceRange.text != nil || self.priceRange.text != "")
                            {
                                self.priceRange.text = self.priceRange.text + "," + (priceArray[index.row]["name"] as! String)
                                searchDetails.priceSelected.addObject(priceArray[index.row]["id"] as! Int)
                                searchDetails.selectedPriceArray.addObject(priceArray[index.row])
                                
                            }
                            else {
                                self.priceRange.text=""
                            }
                        }
                        
                    }
                }
                else {
                    self.priceRange.text=""
                }
            }
            self.priceRange.resignFirstResponder()
        }
        
        currentlySelectedTextField.resignFirstResponder()
        
    }
    
    
    func multipleSelectView(multipleSelectView: SHMultipleSelect, titleForRowAtIndexPath indexPath: NSIndexPath) -> String {
        
        var returnResponse: String!
        
        if (multiselectViewCall == "venue") {
            returnResponse = vanueListArray[indexPath.row]["name"] as! NSString as String
        }
        
        if (multiselectViewCall == "price") {
            returnResponse = priceListArray[indexPath.row]["name"] as! NSString as String
        }
        
        return returnResponse
    }
    
    func multipleSelectView(multipleSelectView: SHMultipleSelect, setSelectedForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        var canSelect: Bool = false
        
        if(multiselectViewCall == "venue") {
            
            if (searchDetails.venueSelected.count == vanuesArray.count - 1) {
                for (var i = 0; i < vanuesArray.count; i++){
                    canSelect = true
                }
            }
            else {
                for (var i = 0; i < searchDetails.venueSelected.count; i++){
                    var selectedCheck = (searchDetails.venueSelected[i] as! Int)
                    if((indexPath.item) == selectedCheck) {
                        canSelect = true
                    }
                }
            }
        }
        
        if(multiselectViewCall == "price") {
            
            if (searchDetails.priceSelected.count == priceArray.count - 1) {
                for (var i = 0; i < priceArray.count; i++){
                    canSelect = true
                }
            }
            else {
                for (var i = 0; i < searchDetails.priceSelected.count; i++){
                    var selectedCheck = (searchDetails.priceSelected[i] as! Int)
                    if((indexPath.item) == selectedCheck) {
                        canSelect = true
                    }
                }
            }
            
        }
        return canSelect
    }
    
    
    
    @IBAction func perPlateButton(sender: AnyObject) {
        perPlateButton.setBackgroundImage(UIImage(named:"Dot.png"), forState: UIControlState.Normal)
        priceRangeButton.setBackgroundImage(UIImage(named:""), forState: UIControlState.Normal)
        noneButton.setBackgroundImage(UIImage(named:""), forState: UIControlState.Normal)
        price_per_plate_status = true
        price_range_status = false
        selectPriceOption()
    }
    
    
    @IBAction func priceRange(sender: AnyObject) {
        perPlateButton.setBackgroundImage(UIImage(named:""), forState: UIControlState.Normal)
        priceRangeButton.setBackgroundImage(UIImage(named:"Dot.png"), forState: UIControlState.Normal)
        noneButton.setBackgroundImage(UIImage(named:""), forState: UIControlState.Normal)
        price_per_plate_status = false
        price_range_status = true
        selectPriceOption()
    }
    
    @IBAction func noneButton(sender: AnyObject) {
        perPlateButton.setBackgroundImage(UIImage(named:""), forState: UIControlState.Normal)
        priceRangeButton.setBackgroundImage(UIImage(named:""), forState: UIControlState.Normal)
        noneButton.setBackgroundImage(UIImage(named:"Dot.png"), forState: UIControlState.Normal)
        price_per_plate_status = false
        price_range_status = false
        selectPriceOption()
    }
    
    // Checking selection option price/ per plate / none
    
    func selectPriceOption () {
        
        if ( price_per_plate_status == true && price_range_status == false) {
            ratePerPlate.hidden = false
            priceRange.hidden = true
            ratePerPlateLabel.hidden = false
            priceRangeLabel.hidden = true
            priceRangeHorizonalLine.hidden = true
            perPlateHorizontalLine.hidden = false
            self.contentViewHeight.constant = 520
            self.perPlateHeight.constant = 8
            self.priceRange.text = ""
            //self.searchButtonToNoneButtonHeight.constant = 100;
            perPlateButton.setBackgroundImage(UIImage(named: "Dot.png"), forState: UIControlState.Normal)
            priceRangeButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            
        }
        
        if ( price_range_status == true && price_per_plate_status == false) {
            priceRange.hidden = false
            ratePerPlate.hidden = true
            ratePerPlateLabel.hidden = true
            priceRangeLabel.hidden = false
            priceRangeHorizonalLine.hidden = false
            perPlateHorizontalLine.hidden = true
            self.contentViewHeight.constant = 520
            self.perPlateHeight.constant = 74
            self.ratePerPlate.text = ""
            //self.searchButtonToNoneButtonHeight.constant = 100;
            perPlateButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            priceRangeButton.setBackgroundImage(UIImage(named: "Dot.png"), forState: UIControlState.Normal)
            
        }
        
        if ( price_range_status == false && price_per_plate_status == false) {
            priceRange.hidden = true
            ratePerPlate.hidden = true
            ratePerPlateLabel.hidden = true
            priceRangeLabel.hidden = true
            priceRangeHorizonalLine.hidden = true
            perPlateHorizontalLine.hidden = true
            self.contentViewHeight.constant = 520
            //self.searchButtonToNoneButtonHeight.constant = 60;
            self.ratePerPlate.text = ""
            self.priceRange.text = ""
            perPlateButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            priceRangeButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            
        }
    }
    
    
    @IBAction func perPlateDidBegining(sender: AnyObject) {
        //self.ratePerPlate.resignFirstResponder()
        pickerSelectValue = "perPlate"
        let picker: SBPickerSelector = SBPickerSelector.picker()
        let max = appDelegate.rangeArrayListAppDelegate[0]["price_per_plate_max"] as! NSNumber
        let min = appDelegate.rangeArrayListAppDelegate[0]["price_per_plate_min"] as! NSNumber
        var range = ("\(min)").toInt()!
        var rangeArray:[String] = []
        while range <= ("\(max)").toInt() {
            rangeArray.append(String(range))
            range = range + 100
        }
        
        picker.pickerData = [rangeArray,["-"],rangeArray] //picker content
        picker.delegate = self
        picker.pickerType = SBPickerSelectorType.Text
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
        picker.optionsToolBar.tintColor =  appDelegate.mainColor
        
        let point: CGPoint = view.convertPoint(sender.frame.origin, fromView: sender.superview)
        var frame: CGRect = sender.frame
        frame.origin = point
        picker.showPickerIpadFromRect(frame, inView: view)
        
    }
    
    @IBAction func perPlateEndEditing(sender: AnyObject) {
        self.ratePerPlate.resignFirstResponder()
    }
    
    // Api call for search venue
    
    @IBAction func searchButton(sender: AnyObject) {
        
        var connection = appDelegate.checkConnection()
        if (connection == true) {
            var area_ids:String!
            var property_type_ids:String!
            var price_range_ids:String!
            var rateFlag:Bool = true
            // Price range ids string
            let flag = validate()
            if (flag == true) {
                if((searchDetails.priceSelected).count > 0) {
                    for (var i = 0; i < (searchDetails.priceSelected).count; i++) {
                        var priceRangeId = (searchDetails.priceSelected)[i] as! NSNumber as Int
                        var priceRangeIdStrting:String = String(priceRangeId)
                        if (i == 0) {
                            price_range_ids = priceRangeIdStrting
                        }
                        else {
                            price_range_ids = price_range_ids + "," + priceRangeIdStrting
                        }
                    }
                }
                else {
                    price_range_ids = ""
                }
                
                // Property type ids string
                
                if((searchDetails.venueSelected).count > 0) {
                    for (var i = 0; i < (searchDetails.venueSelected).count; i++) {
                        var venueId = (searchDetails.venueSelected)[i] as! NSNumber as Int
                        var venueIdStrting:String = String(venueId)
                        if (i == 0) {
                            property_type_ids = venueIdStrting
                        }
                        else {
                            property_type_ids = property_type_ids + "," + venueIdStrting
                        }
                    }
                }
                else {
                    property_type_ids = ""
                }
                
                // Area ids string
                
                if((appDelegate.selectedArea).count > 0) {
                    for (var i = 0; i < (appDelegate.selectedArea).count; i++) {
                        var areaId = (appDelegate.selectedArea)[i]["id"] as! NSNumber as Int
                        var areaIdStrting:String = String(areaId)
                        if (i == 0) {
                            area_ids = areaIdStrting
                        }
                        else {
                            area_ids = area_ids + "," + areaIdStrting
                        }
                    }
                }
                else {
                    area_ids = ""
                }
                
                var methodType: String = "GET"
                var base1: String = "search.json?area_ids=\(area_ids)&property_type_ids=\(property_type_ids)"
                //println(base1)
                if(price_range_ids != "") {
                    base1 = base1 + ("&price_range_ids=\(price_range_ids)")
                }
                
                if (selectedDate != "")
                {
                    base1 = base1 + ("&date_of_enquiry=\(selectedDate)")
                }
                
                
                if (ratePerPlate.text != "") {
                    var rate:Int? = ratePerPlate.text.toInt()
                    if ( (rate >= 100) && ( rate <= 10000)) {
                        base1 = base1 + ("&price_per_plate_min=\(perPlateMin)&price_per_plate_min=\(perPlateMax)")
                        rateFlag = true
                    }
                    else {
                        rateFlag = false
                    }
                }
                
                var base: String = "search.json?area_ids=1&property_type_ids=1,2,3&price_range_ids=1,2,3,4,5,6,7&rate_per_plate=500"
                var param: String = "Delhi/NCR"
                var urlRequest: String = base1
//                println(base1)
                var serviceCall : WebServiceCall = WebServiceCall()
                var loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                loadingProgress.labelText = "Please wait"
                
                serviceCall.apiCallRequest(methodType, urlRequest: urlRequest, param:[:], completion: {(resultData : NSData?, response: NSHTTPURLResponse!) -> Void in
                    if resultData == nil {
                        let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.labelText = "Record not found"
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    }
                    else {
                        self.searchListArray = serviceCall.getSearchVenueArray(resultData!)
                        self.getSearchVenueArray()
                        if((self.searchListArray.count) > 0) {
                            self.searchDetails.cityTextfieldValue = self.city.text
                            self.searchDetails.venueTextfieldValue = self.venueType.text
                            self.searchDetails.dateTextfieldValue = self.dateOfEnquiry.text
                            self.searchDetails.priceTextfieldValue = self.priceRange.text
                            self.searchDetails.pricePerPlateTextfieldValue = self.ratePerPlate.text
                            self.searchDetails.price_per_plate_status = self.price_per_plate_status
                            self.searchDetails.price_range_status = self.price_range_status
                            self.searchDetails.areaArray = self.areaArray
                            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            var dash : venueSearchResultCollectionViewController = storyBoard.instantiateViewControllerWithIdentifier("venueSearchResult") as! venueSearchResultCollectionViewController
                            dash.searchVenueListArray = self.searchListArray
                            dash.searchDetails = self.searchDetails
                            dash.selectedDate = self.selectedDate
                            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                            self.navigationController?.pushViewController(dash, animated: true)
                        }
                        else {
                            loadingProgress.mode = MBProgressHUDMode.Text
                            loadingProgress.labelText = "Result not found"
                            loadingProgress.hide(true, afterDelay: 2)
                        }
                    }
                    
                    
                })
            }
        }
        else {
            appDelegate.showNetworkErrorView()
        }
        
    }
    
    @IBAction func venueEndEditing(sender: AnyObject) {
        self.venueType.resignFirstResponder()
    }
    
    @IBAction func dateEndEditing(sender: AnyObject) {
        self.dateOfEnquiry.resignFirstResponder()
    }
    
    @IBAction func priceRangeEndEditing(sender: AnyObject) {
        self.priceRange.resignFirstResponder()
    }
    
    @IBAction func cityEndEditing(sender: AnyObject) {
       self.city.resignFirstResponder()
        
    }
    
    
    // validation
    
    func validate() -> Bool {
        var flag:Bool = true
        
        if (city.text.isEmpty) {
            city.attributedPlaceholder = NSAttributedString(string:"Please select city", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
        }
        
        if (venueType.text.isEmpty) {
            
            venueType.attributedPlaceholder = NSAttributedString(string:"Please select venue type", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
            
        }
        
        if (areaLabel.text == "" || areaLabel.textColor == UIColor.grayColor().colorWithAlphaComponent(0.5)) {
            areaLabel.textColor = UIColor.redColor()
            areaLabel.text = "Please select area"
            areaLabel.font = UIFont(name: "Circular Air", size: 14)
            flag = false
        }
        
        return flag
    }

}


