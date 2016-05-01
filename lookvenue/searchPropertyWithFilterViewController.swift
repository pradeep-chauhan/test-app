//
//  searchPropertyWithFilterViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 9/21/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class searchPropertyWithFilterViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, SHMultipleSelectDelegate, SBPickerSelectorDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var capacityToNoneHeight: NSLayoutConstraint!
    @IBOutlet weak var capacityHeight: NSLayoutConstraint!
    @IBOutlet weak var noneRadioButtonView: UIView!
    @IBOutlet weak var pricePerPlateRadioButtonView: UIView!
    @IBOutlet weak var priceRangeRadioButtonView: UIView!
    
    @IBOutlet weak var perPlateHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var perPlateHorizontalLine: UIView!
    @IBOutlet weak var priceRangeHorizonalLine: UIView!
    @IBOutlet weak var perPlateButton: UIButton!
    @IBOutlet weak var priceRangeButton: UIButton!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var ratePerPlateLabel: UILabel!
    @IBOutlet weak var noneButton: UIButton!
    @IBOutlet weak var ratePerPlate: UITextField!
    @IBOutlet weak var viewSet: UIView!
    @IBOutlet weak var applyFilter: UILabel!
    @IBOutlet weak var innerViewOnScrollView: UIView!
    @IBOutlet weak var dateOfEnquiry: UITextField!
    @IBOutlet weak var priceRange: UITextField!
    @IBOutlet weak var venueType: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var capacity: UITextField!
    @IBOutlet weak var coverdArea: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    //@IBOutlet weak var tokanView: KSTokenField!
    @IBOutlet weak var selectedAreaLabel: UILabel!
    
    @IBOutlet weak var pageView: UIView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedDate:String = String()
    var initialContentSizeForScrollView:CGFloat = 0.0
    //scrollView.delegate = self
    var currentlySelectedTextField = UITextField()
    var pickerSelectValue = ""
    var multiselectViewCall: String!
    
    var vanueListArray : NSArray!
    var vanuesArray : NSMutableArray = NSMutableArray()
    
    var areaListArray : NSArray!
    var areaArray : NSMutableArray = NSMutableArray()
    var resultArray : NSMutableArray! = NSMutableArray()
    
    var priceListArray : NSArray!
    var priceArray : NSMutableArray = NSMutableArray()
    
    var searchListArray : NSArray!
    var searchArray : NSMutableArray = NSMutableArray()
    
    var searchDetails: SearchDetails = SearchDetails()
    var areaSelected: [Int] = []
    var rateFlag = true
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    var selectedLocationsArray = NSMutableArray()
    var coverdAreaMin:Int = Int()
    var coverdAreaMax:Int = Int()
    var capacityMin:Int = Int()
    var capacityMax:Int = Int()
    var perPlateMin:Int = Int()
    var perPlateMax:Int = Int()
    var price_per_plate_status = false
    var price_range_status = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.textColor = UIColor.redColor()
        areaLabel.textColor = UIColor.redColor()
        venueLabel.textColor = UIColor.redColor()
//        self.selectedAreaLabel.delegate=self
        self.dateOfEnquiry.delegate=self
        self.priceRange.delegate=self
        self.venueType.delegate=self
        self.city.delegate=self
        self.coverdArea.delegate = self
        self.capacity.delegate = self
        //self.city.enabled = false
        
        self.priceRangeButton.layer.cornerRadius = 10
        self.priceRangeButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.priceRangeButton.layer.borderWidth = 0.5
        
        self.perPlateButton.layer.cornerRadius = 10
        self.perPlateButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.perPlateButton.layer.borderWidth = 0.5
        
        self.noneButton.layer.cornerRadius = 10
        self.noneButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.noneButton.layer.borderWidth = 0.5
        
        let pricePerPlateRadioButtonViewTapGesture = UITapGestureRecognizer(target: self, action: "perPlateButton:")
        pricePerPlateRadioButtonView.addGestureRecognizer(pricePerPlateRadioButtonViewTapGesture)
        pricePerPlateRadioButtonViewTapGesture.delegate = self
        
        let priceRangeRadioButtonViewTapGesture = UITapGestureRecognizer(target: self, action: "priceRange:")
        priceRangeRadioButtonView.addGestureRecognizer(priceRangeRadioButtonViewTapGesture)
        priceRangeRadioButtonViewTapGesture.delegate = self
        
        let noneRadioButtonViewTapGesture = UITapGestureRecognizer(target: self, action: "noneButton:")
        noneRadioButtonView.addGestureRecognizer(noneRadioButtonViewTapGesture)
        noneRadioButtonViewTapGesture.delegate = self
        
        self.applyFilterButton.backgroundColor = appDelegate.mainColor
        self.navigationItem.title = "Apply Filter"
        self.applyFilterButton.layer.cornerRadius = 5
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = true
        self.scrollView.scrollEnabled = true
        let leftBarButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        // image for button
        leftBarButton.setImage(UIImage(named: "arrow-left.png"), forState: UIControlState.Normal)
        //set frame
        leftBarButton.frame = CGRectMake(0, 0,20, 20)
        leftBarButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        let leftMenubarButton = UIBarButtonItem(customView: leftBarButton)
        self.selectedAreaLabel.text = ""
        areaArray = self.searchDetails.areaArray
        initialContentSizeForScrollView = 0.0
        
        city.text = searchDetails.cityTextfieldValue
        venueType.text = searchDetails.venueTextfieldValue
        dateOfEnquiry.text = searchDetails.dateTextfieldValue
        priceRange.text = searchDetails.priceTextfieldValue
        ratePerPlate.text = searchDetails.pricePerPlateTextfieldValue
        coverdArea.text = searchDetails.coveredAreaTextfieldValue
        capacity.text = searchDetails.capacityTextfieldValue 
        capacityMin = searchDetails.capacityMin
        capacityMax = searchDetails.capacityMax
        coverdAreaMin = searchDetails.coveredAreaMin
        coverdAreaMax = searchDetails.coveredAreaMax
        
        self.innerViewOnScrollView.sizeToFit()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("openSearchController"))
        tapGesture.cancelsTouchesInView = true
        selectedAreaLabel.addGestureRecognizer(tapGesture)
        
        price_range_status = searchDetails.price_range_status
        price_per_plate_status = searchDetails.price_per_plate_status
        
        selectPriceOption()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        getSelectedAreaText()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if (appDelegate.scrollStatusOnFirstTime == true) {
            var bottomOffset: CGPoint = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
        }
        
    }
    
    // venue array declare
    func getVanuesArray() -> Void
    {
        vanuesArray = vanueListArray as! NSMutableArray
        
    }
    
    func getAreasArray() -> Void
    {
        appDelegate.areaArrayListAppDelegate = []
        appDelegate.availableAreaList = []
        areaArray = areaListArray as! NSMutableArray
        appDelegate.areaArrayListAppDelegate = areaArray
        appDelegate.availableAreaList = areaArray
        
        //println(areaArray)
    }
    
    func getPriceArray() -> Void
    {
        priceArray = priceListArray as! NSMutableArray
    }
    
    func getSearchVenueArray() -> Void
    {
        searchArray = searchListArray as! NSMutableArray
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func datePicker(sender: AnyObject) {
        appDelegate.scrollStatusOnFirstTime == false
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
    
    @IBAction func city(sender: AnyObject) {
        
        pickerSelectValue = "city"
        let picker: SBPickerSelector = SBPickerSelector.picker()
        picker.numberOfComponents = 1
        picker.pickerData = appDelegate.cityArrayListNamesAppDelegate as [AnyObject] //picker content
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
    
    // calling search area view controller
    
    func openSearchController () {
        
        if (appDelegate.selectedCity == "") {
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Please select city"
            loadingProgress.hide(true, afterDelay: 1)
        }
        else {
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
            var dash : searchAreaViewController = storyBoard.instantiateViewControllerWithIdentifier("searchAreaViewController") as! searchAreaViewController
            //                    self.searchDetails.areaArray = self.areaArray
            //                    dash.areaList = self.areaArray
            self.navigationController?.pushViewController(dash, animated: true)
            
        }
        
    }
    
    // Api call for area
    
    func fetchAreaDetails () {
        
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
                self.appDelegate.scrollStatusOnFirstTime == false
                
                
            }
            
        })
        
    }
    
    @IBAction func perPlateButton(sender: AnyObject) {
        appDelegate.scrollStatusOnFirstTime == false
        perPlateButton.setBackgroundImage(UIImage(named: "Dot.png"), forState: UIControlState.Normal)
        priceRangeButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        price_per_plate_status = true
        price_range_status = false
        selectPriceOption()
    }
    
    
    @IBAction func priceRange(sender: AnyObject) {
        appDelegate.scrollStatusOnFirstTime == false
        perPlateButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        priceRangeButton.setBackgroundImage(UIImage(named: "Dot.png"), forState: UIControlState.Normal)
        price_per_plate_status = false
        price_range_status = true
        selectPriceOption()
    }
    
    @IBAction func noneButton(sender: AnyObject) {
        appDelegate.scrollStatusOnFirstTime == false
        perPlateButton.setBackgroundImage(UIImage(named:""), forState: UIControlState.Normal)
        priceRangeButton.setBackgroundImage(UIImage(named:""), forState: UIControlState.Normal)
        noneButton.setBackgroundImage(UIImage(named:"Dot.png"), forState: UIControlState.Normal)
        price_per_plate_status = false
        price_range_status = false
        selectPriceOption()
    }
    
    // selecting option for price / rate per plate / none
    
    func selectPriceOption () {
        appDelegate.scrollStatusOnFirstTime == false
        if ( price_per_plate_status == true && price_range_status == false) {
            ratePerPlate.hidden = false
            priceRange.hidden = true
            ratePerPlateLabel.hidden = false
            priceRangeLabel.hidden = true
            priceRangeHorizonalLine.hidden = true
            perPlateHorizontalLine.hidden = false
            self.contentViewHeight.constant = 730
            self.perPlateHeight.constant = 8
            self.capacityToNoneHeight.constant = 76
            //self.capacityToNoneHeight.priority = 250
            self.priceRange.text = ""
            //self.searchButtonToNoneButtonHeight.constant = 100;
            perPlateButton.setBackgroundImage(UIImage(named: "Dot.png"), forState: UIControlState.Normal)
            priceRangeButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            noneButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            
        }
        
        if ( price_range_status == true && price_per_plate_status == false) {
            priceRange.hidden = false
            ratePerPlate.hidden = true
            ratePerPlateLabel.hidden = true
            priceRangeLabel.hidden = false
            priceRangeHorizonalLine.hidden = false
            perPlateHorizontalLine.hidden = true
            self.contentViewHeight.constant = 730
            self.perPlateHeight.constant = 76
            self.capacityHeight.constant = 8
            self.capacityToNoneHeight.constant = 76
            //self.capacityToNoneHeight.priority = 250
            self.ratePerPlate.text = ""
            //self.searchButtonToNoneButtonHeight.constant = 100;
            perPlateButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            priceRangeButton.setBackgroundImage(UIImage(named: "Dot.png"), forState: UIControlState.Normal)
            noneButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            
        }
        
        if ( price_range_status == false && price_per_plate_status == false) {
            priceRange.hidden = true
            ratePerPlate.hidden = true
            ratePerPlateLabel.hidden = true
            priceRangeLabel.hidden = true
            priceRangeHorizonalLine.hidden = true
            perPlateHorizontalLine.hidden = true
            self.contentViewHeight.constant = 720
            self.capacityToNoneHeight.constant = 10
            //self.capacityToNoneHeight.priority = 1000
            //self.searchButtonToNoneButtonHeight.constant = 60;
            self.ratePerPlate.text = ""
            self.priceRange.text = ""
            perPlateButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            priceRangeButton.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
            noneButton.setBackgroundImage(UIImage(named: "Dot.png"), forState: UIControlState.Normal)
            
        }
    }
    
    @IBAction func venueTypeButton(sender: AnyObject) {
        appDelegate.scrollStatusOnFirstTime == false
        multiselectViewCall = "venue"
        var venueTypemultipleSelect = SHMultipleSelect()
        venueTypemultipleSelect.selectedTextField = self.currentlySelectedTextField
        venueTypemultipleSelect.delegate = self
        venueTypemultipleSelect.rowsCount = self.appDelegate.venueArrayListAppDelegate.count
        venueTypemultipleSelect.show()
        self.venueType.resignFirstResponder()
    }
    
    @IBAction func pricePickerRange(sender: AnyObject) {
        appDelegate.scrollStatusOnFirstTime == false
        multiselectViewCall = "price"
        var priceRangemultipleSelect = SHMultipleSelect()
        priceRangemultipleSelect.selectedTextField = self.currentlySelectedTextField
        priceRangemultipleSelect.delegate = self
        priceRangemultipleSelect.rowsCount = self.appDelegate.priceArrayListAppDelegate.count
        priceRangemultipleSelect.show()
        self.priceRange.resignFirstResponder()
        
    }
    
    @IBAction func capacity(sender: AnyObject) {
        appDelegate.scrollStatusOnFirstTime == false
        pickerSelectValue = "capacity"
        let picker: SBPickerSelector = SBPickerSelector.picker()
        let max = appDelegate.rangeArrayListAppDelegate[0]["capacity_max"] as! NSNumber
        let min = appDelegate.rangeArrayListAppDelegate[0]["capacity_min"] as! NSNumber
        var capacity = ("\(min)").toInt()!
        var capacityArray:[String] = []
        while capacity <= ("\(max)").toInt() {
            capacityArray.append(String(capacity))
            capacity = capacity + 200
        }
        picker.pickerData = [capacityArray,["-"],capacityArray] //picker content
        picker.delegate = self
        picker.pickerType = SBPickerSelectorType.Text
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
        picker.optionsToolBar.tintColor =  appDelegate.mainColor
        
        let point: CGPoint = view.convertPoint(sender.frame.origin, fromView: sender.superview)
        var frame: CGRect = sender.frame
        frame.origin = point
        picker.showPickerIpadFromRect(frame, inView: view)
//        self.capacity.resignFirstResponder()
        
    }
    //For venue
    @IBAction func coveredArea(sender: AnyObject) {
        appDelegate.scrollStatusOnFirstTime == false
        pickerSelectValue = "coveredArea"
        let picker: SBPickerSelector = SBPickerSelector.picker()
        let max = appDelegate.rangeArrayListAppDelegate[0]["covered_area_max"] as! NSNumber
        let min = appDelegate.rangeArrayListAppDelegate[0]["covered_area_min"] as! NSNumber
        var coveredArea = ("\(min)").toInt()!
        var coverdAreaArray:[String] = []
        while coveredArea <= ("\(max)").toInt() {
            coverdAreaArray.append(String(coveredArea))
            coveredArea = coveredArea + 100
        }
        picker.pickerData = [coverdAreaArray,["-"],coverdAreaArray] //picker content
        picker.delegate = self
        picker.pickerType = SBPickerSelectorType.Text
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
        picker.optionsToolBar.tintColor =  appDelegate.mainColor
        let point: CGPoint = view.convertPoint(sender.frame.origin, fromView: sender.superview)
        var frame: CGRect = sender.frame
        frame.origin = point
        picker.showPickerIpadFromRect(frame, inView: view)
//        self.coverdArea.resignFirstResponder()
    }
    
    @IBAction func pricePerPlate(sender: AnyObject) {
        appDelegate.scrollStatusOnFirstTime == false
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
    
    // Multiselect
    
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
                    var indexPathsArray = selectedIndexPaths as NSArray
                    
                    for index in indexPathsArray {
                        if (index.row > 0) {
                            if(self.venueType.text == nil || self.venueType.text == "")
                            {
                                self.venueType.text = (appDelegate.venueArrayListAppDelegate[index.row]["name"] as! String)
                                searchDetails.venueSelected.addObject(appDelegate.venueArrayListAppDelegate[index.row]["id"] as! Int)
                                
                            }
                            else if(self.venueType.text != nil || self.venueType.text != "")
                            {
                                self.venueType.text = self.venueType.text + "," + (appDelegate.venueArrayListAppDelegate[index.row]["name"] as! String)
                                searchDetails.venueSelected.addObject(appDelegate.venueArrayListAppDelegate[index.row]["id"] as! Int)
                                searchDetails.selectedVenueArray.addObject(appDelegate.venueArrayListAppDelegate[index.row])
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
                    var indexPathsArray = selectedIndexPaths as NSArray
                    
                    for index in indexPathsArray {
                        
                        if (index.row > 0) {
                            
                            if(self.priceRange.text == nil || self.priceRange.text == "" || index.row == 1)
                            {
                                self.priceRange.text = (appDelegate.priceArrayListAppDelegate[index.row]["name"] as! String)
                                searchDetails.priceSelected.addObject(appDelegate.priceArrayListAppDelegate[index.row]["id"] as! Int)
                                
                            }
                            else if(self.priceRange.text != nil || self.priceRange.text != "")
                            {
                                self.priceRange.text = self.priceRange.text + "," + (appDelegate.priceArrayListAppDelegate[index.row]["name"] as! String)
                                searchDetails.priceSelected.addObject(appDelegate.priceArrayListAppDelegate[index.row]["id"] as! Int)
                                searchDetails.selectedPriceArray.addObject(appDelegate.priceArrayListAppDelegate[index.row])
                                
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
            returnResponse = appDelegate.venueArrayListAppDelegate[indexPath.row]["name"] as! NSString as String
        }
        
        if (multiselectViewCall == "price") {
            returnResponse = appDelegate.priceArrayListAppDelegate[indexPath.row]["name"] as! NSString as String
        }
        
        return returnResponse
    }
    
    func multipleSelectView(multipleSelectView: SHMultipleSelect, setSelectedForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        var canSelect: Bool = false
        
        if(multiselectViewCall == "venue") {
            
            if (searchDetails.selectedVenueArray.count == appDelegate.venueArrayListAppDelegate.count - 1) {
                for (var i = 0; i < appDelegate.venueArrayListAppDelegate.count; i++){
                    canSelect = true
                }
            }
            else {
                for (var i = 0; i < searchDetails.selectedVenueArray.count; i++){
                    var selectedCheck = (searchDetails.selectedVenueArray[i] as! Int)
                    if((indexPath.item) == selectedCheck) {
                        canSelect = true
                    }
                }
            }
        }
        
        if(multiselectViewCall == "price") {
            
            if (searchDetails.selectedPriceArray.count == appDelegate.priceArrayListAppDelegate.count - 1) {
                for (var i = 0; i < appDelegate.priceArrayListAppDelegate.count; i++){
                    canSelect = true
                }
            }
            else {
                for (var i = 0; i < searchDetails.selectedPriceArray.count; i++){
                    var selectedCheck = (searchDetails.selectedPriceArray[i] as! Int)
                    if((indexPath.item) == selectedCheck) {
                        canSelect = true
                    }
                }
            }
            
        }
        return canSelect
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
       
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currentlySelectedTextField = textField
        appDelegate.scrollStatusOnFirstTime == false
        textField.resignFirstResponder()
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        currentlySelectedTextField.resignFirstResponder()
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    // Get selected area
    
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
            selectedAreaLabel.textColor = UIColor.blackColor()
            selectedAreaLabel.text = areaName
        }
        else {
            selectedAreaLabel.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            selectedAreaLabel.text = " Please select area"
        }
        
    }
    
    // search venue
    
    @IBAction func applyFilter(sender: AnyObject) {
        appDelegate.scrollStatusOnFirstTime == false
        var area_ids:String!
        var property_type_ids:String!
        var price_range_ids:String!
        
        
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
            
            var base1: String = "search.json?area_ids=\(area_ids)&property_type_ids=\(property_type_ids)"
            
            if(price_range_ids != "") {
                base1 = base1 + ("&price_range_ids=\(price_range_ids)")
            }
            
            if(coverdArea.text != "") {
                base1 = base1 + ("&covered_area_min=\(coverdAreaMin)&covered_area_max=\(coverdAreaMax)")
            }
            
            if(capacity.text != "") {
                base1 = base1 + ("&capacity_min=\(capacityMin)&capacity_max=\(capacityMax)")
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
            var connection = appDelegate.connection
            if (connection == true) {
                var methodType: String = "GET"
                var base: String = "search.json?area_ids=1&property_type_ids=1,2,3&price_range_ids=1"
                //var param: String = "Delhi/NCR"
                var urlRequest: String = base1
                var serviceCall : WebServiceCall = WebServiceCall()
                let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                serviceCall.apiCallRequest(methodType, urlRequest: urlRequest, param: [:], completion: {(resultData, response) -> Void in
                    if resultData == nil {
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.labelText = "Data Not Found"
                    }
                    else {
                        self.searchListArray = serviceCall.getSearchVenueArray(resultData!)
                        self.getSearchVenueArray()
                        //self.indicator.stopAnimating()
                        if((self.searchListArray.count) > 0) {
                            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            var dash : venueSearchResultCollectionViewController = storyBoard.instantiateViewControllerWithIdentifier("venueSearchResult") as! venueSearchResultCollectionViewController
                            dash.searchDetails.coveredAreaTextfieldValue = self.coverdArea.text
                            dash.searchDetails.capacityTextfieldValue = self.capacity.text
                            dash.searchDetails.capacityMin = self.capacityMin
                            dash.searchDetails.capacityMax = self.capacityMax
                            dash.searchDetails.coveredAreaMin = self.coverdAreaMin
                            dash.searchDetails.coveredAreaMax = self.coverdAreaMax
                            dash.searchVenueListArray = self.searchListArray
                            dash.searchDetails = self.searchDetails
                            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                            self.navigationController?.pushViewController(dash, animated: true)
                        }
                        else {
                            loadingProgress.mode = MBProgressHUDMode.Text
                            loadingProgress.detailsLabelText = "No Result Found"
                            loadingProgress.hide(true, afterDelay: 1)
                        }
                    }
                    
                })
            }
            else {
                appDelegate.showNetworkErrorView()
            }
        } 
        
    }
    
    // SBPicker 
    
    func pickerSelector(selector: SBPickerSelector!, selectedValue value: String!, index idx: Int) {
        
        if(pickerSelectValue == "coveredArea") {
            let max = appDelegate.rangeArrayListAppDelegate[0]["covered_area_max"] as! NSNumber
            let min = appDelegate.rangeArrayListAppDelegate[0]["covered_area_min"] as! NSNumber
            var coverdAreaString: String = value
            var coverdAreaStringArray = coverdAreaString.componentsSeparatedByString(" ")
            coverdAreaMin = (coverdAreaStringArray [0]).toInt()!
            coverdAreaMax = (coverdAreaStringArray [2]).toInt()!
            
            if ((coverdAreaMin >= min && coverdAreaMin < coverdAreaMax) && (coverdAreaMax <= max && coverdAreaMax > coverdAreaMin)) {
                coverdArea.text = value
            }
            else {
                coverdArea.text = ""
                let alert = UIAlertView()
                alert.title = "Warning !"
                alert.message = "Minimum value cannot be greater than equal to Max value"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
            
            self.coverdArea.resignFirstResponder()
        }
        
        if(pickerSelectValue == "capacity") {
            let max = appDelegate.rangeArrayListAppDelegate[0]["capacity_max"] as! NSNumber
            let min = appDelegate.rangeArrayListAppDelegate[0]["capacity_min"] as! NSNumber
            var capacityAreaString: String = value
            var capacityAreaStringArray = capacityAreaString.componentsSeparatedByString(" ")
            capacityMin = (capacityAreaStringArray [0]).toInt()!
            capacityMax = (capacityAreaStringArray [2]).toInt()!
            
            if ((capacityMin >= min && capacityMin < capacityMax) && (capacityMax <= max && capacityMax > capacityMin)) {
                capacity.text = value
            }
            else {
                capacity.text = ""
                let alert = UIAlertView()
                alert.title = "Warning !"
                alert.message = "Minimum value cannot be greater than equal to Max value"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
            self.capacity.resignFirstResponder()
        }
        
        if(pickerSelectValue == "perPlate") {
            let max = appDelegate.rangeArrayListAppDelegate[0]["price_per_plate_max"] as! NSNumber
            let min = appDelegate.rangeArrayListAppDelegate[0]["price_per_plate_min"] as! NSNumber
            var perPlateString: String = value
            var perPlateStringArray = perPlateString.componentsSeparatedByString(" ")
            perPlateMin = (perPlateStringArray [0]).toInt()!
            perPlateMax = (perPlateStringArray [2]).toInt()!
            
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
            city.text = value
            appDelegate.selectedCity = city.text
            areaLabel.text = ""
            appDelegate.selectedArea = []
            getSelectedAreaText()
            fetchAreaDetails()
            self.city.resignFirstResponder()
        }
        
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
    
    func backButtonPressed() {
        
        self.navigationController?.popViewControllerAnimated(true)
        
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
    
    @IBAction func capacityEndEditing(sender: AnyObject) {
        self.capacity.resignFirstResponder()
    }
    
    @IBAction func coveredEndEditing(sender: AnyObject) {
        self.coverdArea.resignFirstResponder()
    }
    
    @IBAction func perPlateEndEditing(sender: AnyObject) {
        self.ratePerPlate.resignFirstResponder()
        
    }
    
    @IBAction func cityEndEditing(sender: AnyObject) {
        self.city.resignFirstResponder()
    }
}


