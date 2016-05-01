//
//  calendarViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 10/6/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class calendarViewController: UIViewController, SBPickerSelectorDelegate, UITextViewDelegate, UITextFieldDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var yearChangeButton: UIButton!
    @IBOutlet weak var monthChangeButton: UIButton!
    @IBOutlet weak var monthYearView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var checkUpdateView: UIView!
    @IBOutlet weak var checkUpdateButton: UIButton!
    @IBOutlet weak var dateSeletedView: UIView!
    @IBOutlet weak var bookingStatusView: UIView!
    @IBOutlet weak var bookingButton: UIButton!
    @IBOutlet weak var showBookingInfo: UIButton!
    var selectedColor = UIColor(red: 135.0/255.0, green: 206.0/255.0, blue: 235.0/255.0, alpha: 1.0)
    var is_date_selected = false // check date is selected or not
    var bookingWithStatus = false // if it is true then doing bulk update
    var is_booked_selected = false
    var is_update_button = true
    var is_alreadyBookedDate = false
    
    
    var showDetailsArray:NSMutableArray = NSMutableArray()
    var minimumDate:NSDate = NSDate()
    var dateFormatter = NSDateFormatter()
    var dateFormatterForBookingConfirmationView = NSDateFormatter()
    var chosenDates:NSMutableArray = NSMutableArray()
    var disabledDates:NSMutableArray = NSMutableArray()
    var tempDisabledDates:NSMutableArray = NSMutableArray()
    var selectedPropertyDetailsArray : NSMutableArray = NSMutableArray()
    var calendarDetailsListArray : NSArray!
    var calendarDetailsArray : NSMutableArray = NSMutableArray()
    var editPropertyArray : NSMutableArray = NSMutableArray()
    var LoginDetails: loginDetails = loginDetails()
    
    var monthStartDate:String!
    var monthEndDate:String!
    var currentDate = NSDate()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userTextField: UITextField!
    var userMobileNoTextField: UITextField!
    var bookingConfirmView: bookingConfirmationView!
    //var bookingPopUpView = bookingConfirmationView()
    //var calendar: CKCalendarView = CKCalendarView()
    
    var updateViewStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingButton.backgroundColor = appDelegate.mainColor
        //bookingButton.layer.cornerRadius = 5
        
        checkUpdateButton.backgroundColor = appDelegate.mainColor
        //checkUpdateButton.layer.cornerRadius = 5
        
        showBookingInfo.backgroundColor = appDelegate.mainColor
        //showBookingInfo.layer.cornerRadius = 5
        
        
        // month year change option
        
        self.monthYearView.backgroundColor = UIColor.clearColor()
        //self.monthChangeButton.layer.borderColor = UIColor.whiteColor().CGColor
        //self.yearChangeButton.layer.borderColor = UIColor.whiteColor().CGColor
        //self.monthChangeButton.layer.borderWidth = 1
        //self.yearChangeButton.layer.borderWidth = 1
        //calendar.appearance.headerMinimumDissolvedAlpha = 1
        
        // end
        
        /* CKCalendar
        
        calendar.delegate = self
        calendar.backgroundColor = UIColor.grayColor()
        calendar.onlyShowCurrentMonth = false;
        
        calendar.adaptHeightToNumberOfWeeksInMonth = false;
        calendar.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
        self.view.addSubview(calendar)
        
        */
        
        // FSCalendar start
        
        self.calendar.scrollDirection = .Vertical
        self.calendar.allowsMultipleSelection = true
        //calendar.appearance.cellShape = .Rectangle
        self.calendar.clipsToBounds = true
        self.calendar.appearance.todayColor = UIColor.grayColor()
        self.calendar.appearance.weekdayTextColor = appDelegate.mainColor
        self.calendar.appearance.headerTitleColor = appDelegate.mainColor
        
        // FSCalendar end
        
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.navigationItem.title = "Calendar"
        
        bookingConfirmView = NSBundle.mainBundle().loadNibNamed("BookinConfirmationView", owner: self, options: nil).first as! bookingConfirmationView
        self.bookingConfirmView.customerName.delegate = self
        self.bookingConfirmView.customerMobileNo.delegate = self
        self.returnDate(currentDate)
        getBookingDetails()
        self.calendar.reloadData()
        
        self.bookingStatusView.backgroundColor = appDelegate.mainColor
        var numberToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        numberToolbar.items = [UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelNumberPad"), UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneWithNumberPad")]
        numberToolbar.sizeToFit()
        numberToolbar.tintColor = appDelegate.mainColor
        self.bookingConfirmView.customerMobileNo.inputAccessoryView = numberToolbar
        self.dateSeletedView.backgroundColor = selectedColor
        showHideUpdateButtonOnCalendarView()
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        bookingStatusView.addGestureRecognizer(tapGesture)
        self.calendar.addSubview(monthYearView)
        
//        self.monthStartDate = "\(calendar.yearOfDate(calendar.currentPage))-\(calendar.monthOfDate(calendar.currentPage))-01"
//        self.monthEndDate = "\(calendar.yearOfDate(calendar.currentPage))-\(calendar.monthOfDate(calendar.currentPage))-\(calendar.numberOfDatesInMonthOfDate(calendar.currentPage))"
//        let currentPageStartDate = calendar.dateFromString("\(monthStartDate)", format: "yyyy-MM-dd")
//        monthChangeButton.titleLabel?.text = calendar.stringFromDate(currentPageStartDate, format: "MMMM")
//        yearChangeButton.titleLabel?.text = calendar.stringFromDate(currentPageStartDate, format: "yyyy")
        
        //self.calendar.reloadData()
        //showHideBookingForm()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func monthChange(sender: AnyObject) {
        monthYearPicker(sender)
    }

    @IBAction func yearChange(sender: AnyObject) {
        monthYearPicker(sender)
    }
    
    func monthYearPicker (sender:AnyObject) {
        
        let picker: SBPickerSelector = SBPickerSelector.picker()
        picker.delegate = self
        picker.pickerType = SBPickerSelectorType.Date
        picker.datePickerType = SBPickerSelectorDateType.OnlyMonthAndYear
        
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
        picker.optionsToolBar.tintColor =  appDelegate.mainColor
        let point: CGPoint = view.convertPoint(sender.frame.origin, fromView: sender.superview)
        var frame: CGRect = sender.frame
        frame.origin = point
        picker.showPickerIpadFromRect(frame, inView: view)
    }
    
    func pickerSelector(selector: SBPickerSelector!, dateSelected date: NSDate!) {
        
        self.monthChangeButton.titleLabel?.text = calendar.stringFromDate(date, format: "MMM")
        self.yearChangeButton.titleLabel?.text = calendar.stringFromDate(date, format: "yyyy")
        calendar.selectDate( date, scrollToDate: true)
        calendar.deselectDate(date)
        
    }
    
    
    func doneWithNumberPad () {
        self.bookingConfirmView.customerMobileNo.resignFirstResponder()
    }
    
    func cancelNumberPad () {
        self.bookingConfirmView.customerMobileNo.resignFirstResponder()
    }
    
    func hideKeyboard () {
        view.endEditing(true)
    }
    
    // Get booking details
    
    func getBookingDetails () {
        
        self.disabledDates = []
        self.chosenDates = []
        self.tempDisabledDates = []
        //self.returnDate(currentDate)
        let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingProgress.labelText = "Loading"
        var authentication = ( NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString) as String
        var methodType: String = "GET"
        var base: String = "bookings?"
        var startDate = "\(self.monthStartDate)"
        var endDate = "\(self.monthEndDate)"
        var propertyId = (selectedPropertyDetailsArray[0]["id"] as! NSNumber).stringValue
        var param: String = "property_id=\(propertyId)&start_date=\(startDate)&end_date=\(endDate)"
        var urlRequest: String = base + param
        var serviceCall : WebServiceCall = WebServiceCall()
        serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param:[:], authentication: authentication, completion: { (resultData, response) -> () in
            
            if resultData == nil {
                loadingProgress.labelText = "Data Not Found"
                loadingProgress.hide(true, afterDelay: 2)
            }
            else {
                self.calendarDetailsListArray = serviceCall.getCalendarDetailsArray(resultData!)
                self.getCalendarDetailsArray()
                for ( var i = 0; i < self.calendarDetailsArray.count; i++) {
                    var bookingDates = self.calendarDetailsArray[i]["status"]
                    var flag = 1
                    if ( bookingDates as! Int == flag ) {
                        //self.calendar.enqueueSelectedDate(self.calendar.dateFromString(self.calendarDetailsArray[i]["for_date"] as! NSString as String, format: "yyyy-MM-dd"))
                        self.calendar.selectDate(self.calendar.dateFromString(self.calendarDetailsArray[i]["for_date"] as! NSString as String, format: "yyyy-MM-dd"))
                        self.disabledDates.addObject(self.calendarDetailsArray[i]["for_date"] as! NSString as String)
                        self.tempDisabledDates.addObject(self.calendarDetailsArray[i]["for_date"] as! NSString as String)
//                        println(self.disabledDates)
                    }
                    
                }
            }
            
            self.is_date_selected = false // check date is selected or not
            self.bookingWithStatus = false // if it is true then doing bulk update
            self.is_update_button = true
            self.is_alreadyBookedDate = false
            //self.disableDates()
            self.calendar.reloadData()
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        })
        //self.calendar.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getBookingDetails()
        self.calendar.reloadData()
    }
    
    func getCalendarDetailsArray () -> Void {
        
        calendarDetailsArray = calendarDetailsListArray as! NSMutableArray
    }
    
    
    @IBAction func updateBookingButtonAction(sender: AnyObject) {
        
        if (chosenDates.count > 0) {
            showHideUpdateButtonOnCalendarView()
            if ( is_booked_selected == false ) {
                showHideBookingForm()
                popUpView()
                //saveBookingInfoPopUpButton()
            }
        }
        else {
            var loadingProcess = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProcess.mode = MBProgressHUDMode.Text
            loadingProcess.detailsLabelText = "Please select date"
            loadingProcess.hide(true, afterDelay: 2)
        }
        
        
//        showHideBookingForm()
    }
    
    // show/hide update button
    
    func showHideUpdateButtonOnCalendarView () {
        
        if (updateViewStatus == true && is_alreadyBookedDate == false) {
            checkUpdateView.hidden = false
            self.bookingButton.hidden = true
            self.showBookingInfo.hidden = true
        }
        else {
            checkUpdateView.hidden = true
            self.bookingButton.hidden = false
            self.showBookingInfo.hidden = false
        }
    }
    
    
    @IBAction func showBookingInfo(sender: AnyObject) {
        
        if ( chosenDates.count > 0) {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingProgress.labelText = "Loading"
            showDetailsArray.removeAllObjects()
            for ( var i = 0; i < chosenDates.count; i++) {
                var selectedForDate = "\(dateFormatter.stringFromDate(chosenDates[i] as! NSDate))"
                for (var j = 0; j < calendarDetailsArray.count; j++) {
                    var calenderForDate = calendarDetailsArray[j]["for_date"] as! NSString as String
                    if (calenderForDate == selectedForDate) {
//                        println(calenderForDate)
//                        println(selectedForDate)
                        if (calendarDetailsArray[j]["status"] as! Int == 1 ) {
                            showDetailsArray.addObject(calendarDetailsArray[j])
                        } 
                    }
                }
            }
            
            if (showDetailsArray.count > 0) {
                var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                var dash:calendarUserDetailsViewController = storyboard?.instantiateViewControllerWithIdentifier("calendarUserDetailsViewController") as! calendarUserDetailsViewController
                dash.showBookingDetails = showDetailsArray
                self.navigationController?.pushViewController(dash, animated: true)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            else {
                let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                loadingProgress.labelText = "Loading"
                loadingProgress.mode = MBProgressHUDMode.Text
                loadingProgress.detailsLabelText = "Result not found"
                loadingProgress.hide(true, afterDelay: 2)
            }
            
            
        }
        else {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProgress.labelText = "Loading"
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Please select date"
            loadingProgress.hide(true, afterDelay: 2)
        }
        
    }
    
    
    func saveBookingInfoPopUpButton() {
        
        if (is_alreadyBookedDate == true) {
            var status = false
            updateBookingInformation(status)
        }
            
        if (is_alreadyBookedDate == false) {
            var status = true
            updateBookingInformation(status)
        }
        
        
    }
    
    // Update booking details
    
    func updateBookingInformation (status:Bool) {
        
        if (chosenDates.count > 0) {
            
            var customerName = self.bookingConfirmView.customerName.text
            var customerMobileNo = self.bookingConfirmView.customerMobileNo.text
            self.bookingConfirmView.removeFromSuperview()
            var allBookingDates:NSMutableArray = NSMutableArray()
            
            var loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingProgress.detailsLabelText = "Please wait"
            
            for ( var i = 0; i < chosenDates.count; i++ ) {
                
                allBookingDates.addObject(calendar.stringFromDate(chosenDates[i] as! NSDate, format: "yyyy-MM-dd"))
            }
            
            var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString
            var methodType: String = "PUT"
            var base: String = "bookings/bulk_update"
            var propertyId = (selectedPropertyDetailsArray[0]["id"] as! NSNumber).stringValue
            var urlRequest: String = base
            var serviceCall : WebServiceCall = WebServiceCall()
            var bulk_data : [String: AnyObject] = [:]
            bulk_data["for_dates"] = allBookingDates
            bulk_data["property_id"] = propertyId
            bulk_data["status"] = status
            
            if (status == true) {
                bulk_data["customer_name"] = customerName
                bulk_data["customer_contact"] = customerMobileNo
            }
            
            
            var upload_data : [String: AnyObject] = [:]
            upload_data["bulk_data"] = bulk_data
            
            if (status == true) {
                
                var connection = appDelegate.checkConnection()
                if (connection == true) {
                    serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param:upload_data as Dictionary<String, AnyObject>, authentication: authentication as String, completion: { (resultData, response) -> () in
                        //self.is_booked_selected = false
                        
                        if resultData == nil {
                            loadingProgress.mode = MBProgressHUDMode.Text
                            loadingProgress.labelText = "Data Not Found"
                            loadingProgress.hide(true, afterDelay: 2)
                        }
                        else {
                            if (response.statusCode == 200) {
                                //                        loadingProgress.mode = MBProgressHUDMode.Text
                                //                        loadingProgress.detailsLabelText = "Updated Successfully"
                                
                                self.getBookingDetails()
                                self.showHideUpdateButtonOnCalendarView()
                                self.calendar.reloadData()
                                //self.closeLoader()
                            }
                            else {
                                //                        loadingProgress.mode = MBProgressHUDMode.Text
                                //                        loadingProgress.detailsLabelText = "Not Updated"
                                
                                for date in self.chosenDates {
                                    self.chosenDates.removeObject(date)
                                    if (self.is_alreadyBookedDate == true) {
                                        self.calendar.deselectDate(date as! NSDate)
                                    }
                                    else {
                                        self.calendar.selectDate(date as! NSDate)
                                    }
                                    
                                }
                                self.getBookingDetails()
                                self.showHideUpdateButtonOnCalendarView()
                                self.calendar.reloadData()
                                //self.closeLoader()
                            }
                        }
                        
                        
                    })
                    
                }
                else {
                    appDelegate.showNetworkErrorView()
                }
                
            }
            else {
                
                var connection = appDelegate.checkConnection()
                if (connection == true) {
                    serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param:upload_data as Dictionary<String, AnyObject>, authentication: authentication as String, completion: { (resultData, response) -> () in
                        self.is_booked_selected = false
                        
                        if resultData == nil {
                            loadingProgress.mode = MBProgressHUDMode.Text
                            loadingProgress.labelText = "Data Not Found"
                            loadingProgress.hide(true, afterDelay: 2)
                        }
                        else {
                            if (response.statusCode == 200) {
                                //                        loadingProgress.mode = MBProgressHUDMode.Text
                                //                        loadingProgress.detailsLabelText = "Updated Successfully"
                                //self.chosenDates = []
                                for date in self.chosenDates {
                                    self.chosenDates.removeObject(date)
                                    if (self.is_alreadyBookedDate == true) {
                                       self.calendar.deselectDate(date as! NSDate)
                                    }
                                    else {
                                        self.calendar.selectDate(date as! NSDate)
                                    }
                                    
                                }
                                self.getBookingDetails()
                                self.showHideUpdateButtonOnCalendarView()
                                self.calendar.reloadData()
                                
                                //self.closeLoader()
                                
                            }
                            else {
                                //                        loadingProgress.mode = MBProgressHUDMode.Text
                                //                        loadingProgress.detailsLabelText = "Not Updated"
                                for date in self.chosenDates {
                                    self.chosenDates.removeObject(date)
                                    if (self.is_alreadyBookedDate == true) {
                                        self.calendar.deselectDate(date as! NSDate)
                                    }
                                    else {
                                        self.calendar.selectDate(date as! NSDate)
                                    }
                                    
                                }
                                self.getBookingDetails()
                                self.showHideUpdateButtonOnCalendarView()
                                self.calendar.reloadData()
                                //self.closeLoader()
                            }
                        }
                        
                        
                    })
                }
                else {
                    appDelegate.showNetworkErrorView()
                }
                
            }

        }
        else {
            var loadingProcess = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProcess.mode = MBProgressHUDMode.Text
            loadingProcess.detailsLabelText = "Please select date"
            loadingProcess.hide(true, afterDelay: 2)
        }
        
        
    }
    
    func closeLoader () {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
//    func getBookingDetailsAfterBookingUpdate () {
//        
//        self.disabledDates = []
//        self.chosenDates = []
//        self.tempDisabledDates = []
//        self.returnDate(currentDate)
//        var authentication = ( self.LoginDetails.remember_token as NSString) as String
//        var methodType: String = "GET"
//        var base: String = "bookings?"
//        
//        var startDate = "\(monthStartDate)"
//        var endDate = "\(monthEndDate)"
//        var propertyId = (selectedPropertyDetailsArray[0]["id"] as! NSNumber).stringValue
//        var param: String = "property_id=\(propertyId)&start_date=\(startDate)&end_date=\(endDate)"
//        var urlRequest: String = base + param
//        var serviceCall : WebServiceCall = WebServiceCall()
//        serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param:[:], authentication: authentication, completion: { (resultData, response) -> () in
//            
//            if resultData == nil {
//                let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                loadingProgress.mode = MBProgressHUDMode.Text
//                loadingProgress.labelText = "Data Not Found"
//                loadingProgress.hide(true, afterDelay: 2)
//            }
//            else {
//                if (response.statusCode == 200) {
//                    self.calendarDetailsListArray = serviceCall.getCalendarDetailsArray(resultData!)
//                    self.getCalendarDetailsArray()
//                    
//                    for ( var i = 0; i < self.calendarDetailsArray.count; i++) {
//                        var bookingDates = self.calendarDetailsArray[i]["status"]
//                        var flag = 1
//                        if ( bookingDates as! Int == flag ) {
//                            self.calendar.enqueueSelectedDate(self.calendar.dateFromString(self.calendarDetailsArray[i]["for_date"] as! NSString as String, format: "yyyy-MM-dd"))
//                            self.disabledDates.addObject(self.calendarDetailsArray[i]["for_date"] as! NSString as String)
//                            self.tempDisabledDates.addObject(self.calendarDetailsArray[i]["for_date"] as! NSString as String)
//                        }
//                    }
//                }
//                else {
//                    self.appDelegate.showNetworkErrorView()
//                }
//            }
//            
//            self.is_date_selected = false // check date is selected or not
//            self.bookingWithStatus = false // if it is true then doing bulk update
//            self.is_booked_selected = false
//            self.is_update_button = true
//            self.is_alreadyBookedDate = false
//            
//            self.calendar.reloadData()
//            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//        })
//        //self.calendar.reloadData()
//    }
    
    
//    func validate() -> Bool {
//        var flag:Bool = true
//        var string:String = bookingConfirmView.customerMobileNo.text
//        var length = count(string)
//        if (bookingConfirmView.customerName.text.isEmpty) {
//            
//            bookingConfirmView.customerName.attributedPlaceholder = NSAttributedString(string:"Please enter name", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
//            flag = false
//            
//        }
//        
//        if (bookingConfirmView.customerMobileNo.text.isEmpty) {
//            bookingConfirmView.customerMobileNo.attributedPlaceholder = NSAttributedString(string:"Please enter mobile no.", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
//            flag = false
//        }
//        
//        if ( length <= 9 && bookingConfirmView.customerMobileNo.text != "" && bookingConfirmView.customerMobileNo.text != nil && length > 10) {
//            bookingConfirmView.customerMobileNo.attributedPlaceholder = NSAttributedString(string:"Please enter 10 digit", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
//            flag = false
//        }
//        
//        return flag
//    }
    
    // Setting contraint for pop up 
    
    func stateChanged(switchState: UISwitch) {
        
        if switchState.on {
            bookingWithStatus = true
            self.bookingConfirmView.heightConstraint.constant = 300
        }
        else {
            bookingWithStatus = false
            self.bookingConfirmView.heightConstraint.constant = 230
        }
        showHideBookingForm ()
    }
    
    func showHideBookingForm () {
        
        dateFormatterForBookingConfirmationView.dateFormat = "EE, dd-MMM-yyyy"
        if (is_alreadyBookedDate == true) {
            
            if (chosenDates.count > 0) {
                self.bookingConfirmView.headerBackground.backgroundColor = UIColor(red: 1.0/255.0, green: 223.0/255.0, blue: 58.0/255.0, alpha: 1)
                self.bookingConfirmView.customerMobileNo.hidden = true
                self.bookingConfirmView.customerName.hidden = true
                self.bookingConfirmView.yesButtonHeightConstraint.constant = 12
                self.bookingConfirmView.cancelButtonHeightConstraint.constant = 12
                if (chosenDates.count > 1) {
                    self.bookingConfirmView.dateLabel.text = "Bulk Update"
                    self.bookingConfirmView.messageLabel.text = "Do you really want to un-book all the dates?"
                }
                else {
                    
                    self.bookingConfirmView.dateLabel.text = "\(dateFormatterForBookingConfirmationView.stringFromDate(chosenDates[0] as! NSDate))"
                    self.bookingConfirmView.messageLabel.text = "Do you really want to un-book the date?"
                }
            }
            else {
                var loadingProcess = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                loadingProcess.mode = MBProgressHUDMode.Text
                loadingProcess.detailsLabelText = "Please select date"
                loadingProcess.hide(true, afterDelay: 2)
            }
            
            
        }
        else {
            
            if (chosenDates.count > 0) {
                self.bookingConfirmView.headerBackground.backgroundColor = appDelegate.mainColor
                self.bookingConfirmView.customerMobileNo.hidden = false
                self.bookingConfirmView.customerName.hidden = false
                self.bookingConfirmView.customerMobileNo.text = ""
                self.bookingConfirmView.customerName.text = ""
                self.bookingConfirmView.yesButtonHeightConstraint.constant = 85
                self.bookingConfirmView.cancelButtonHeightConstraint.constant = 85
                if (chosenDates.count > 1) {
                    self.bookingConfirmView.dateLabel.text = "Bulk Update"
                    self.bookingConfirmView.messageLabel.text = "Do you really want to book all the dates?"

                }
                else {
                    self.bookingConfirmView.dateLabel.text = "\(dateFormatterForBookingConfirmationView.stringFromDate(chosenDates[0] as! NSDate))"
                    self.bookingConfirmView.messageLabel.text = "Do you really want to book the date?"
                }
            }
            else {
                var loadingProcess = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                loadingProcess.mode = MBProgressHUDMode.Text
                loadingProcess.detailsLabelText = "Please select date"
                loadingProcess.hide(true, afterDelay: 2)
            }
            
        }
        
    }
    
    @IBAction func bookingUpdate(sender: AnyObject) {
        showHideBookingForm()
        popUpView()
        
    }
    
    func popUpView () {
        self.view.addSubview(bookingConfirmView)
        self.bookingConfirmView.frame = self.view.bounds
        self.bookingConfirmView.customerName.delegate = self
        self.bookingConfirmView.customerMobileNo.delegate = self
        self.bookingConfirmView.updateBookingPopUpButton.addTarget(self, action: "saveBookingInfoPopUpButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.bookingConfirmView.closeWindowButton.addTarget(self, action: "closeWindow", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func closeWindow () {
        
        if (chosenDates.count > 0) {
            for date in chosenDates {
                calendar.deselectDate(date as! NSDate)
                chosenDates.removeObject(date)
                if (disabledDates.containsObject(calendar.stringFromDate(date as! NSDate, format: "yyyy-MM-dd"))) {
                    tempDisabledDates.addObject(calendar.stringFromDate(date as! NSDate, format: "yyyy-MM-dd"))
                    calendar.selectDate(date as! NSDate)
                }
            }
            is_alreadyBookedDate = false
        }
        
        self.bookingConfirmView.removeFromSuperview()
        self.calendar.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dateIsDisabled(date: NSDate) -> Bool {
        //self.disabledDates.removeAllObjects()
        for ( var i = 0; i < self.disabledDates.count; i++) {
            
            if ( tempDisabledDates[i].isEqual("\(dateFormatter.stringFromDate(date))")) {
                
                return true
            }
        }
        return false
    }
    
    /* CKCalendar
    
    func calendar(calendar: CKCalendarView!, configureDateItem dateItem: CKDateItem!, forDate date: NSDate!) {
        
        if date.laterDate(minimumDate) == minimumDate {
            dateItem.textColor = UIColor.grayColor()
        }
        else {
            if (self.dateIsDisabled(date)) {
                dateItem.backgroundColor = appDelegate.mainColor
                dateItem.textColor = UIColor.blackColor()
                
            }
            
            if chosenDates.containsObject(date) {
                dateItem.backgroundColor = selectedColor
            }
        }
        //self.calendar.reloadData()
    }
    
    func calendar(calendar: CKCalendarView!, willSelectDate date: NSDate!) -> Bool {
        var dateItem = CKDateItem()
        if date.laterDate(minimumDate) == minimumDate {
            return false
        }
        return calendar.dateIsInCurrentMonth(date)
//        return self.dateIsDisabled(date!)
    }
    
    func calendar(calendar: CKCalendarView!, willDeselectDate date: NSDate!) -> Bool {
        var dateItem = CKDateItem()
        dateItem.backgroundColor = UIColor.clearColor()
        chosenDates.removeObject(date)
        
//        println("remove \(chosenDates)")
        return true
    }
    
    func calendar(calendar: CKCalendarView!, didSelectDate date: NSDate!) {
        var selectedDate = CKDateItem()
        selectedDate.backgroundColor = UIColor.orangeColor()
        var is_already_selected = false
        for (var i = 0; i < chosenDates.count; i++) {
            if("\(dateFormatter.stringFromDate(chosenDates[i] as! NSDate))" == "\(dateFormatter.stringFromDate(date))") {
                is_already_selected = true
                chosenDates.removeObject(date)
                break
            }
        }
        if (is_already_selected == false) {
            var flag = checkDateSelection(date)
            if (flag == true) {
                
                chosenDates.addObject(date)
            }
        }
        if (chosenDates.count == 0) {
            is_booked_selected = false
        }
        showHideUpdateButtonOnCalendarView()
        self.calendar.reloadData()
        
    }
    
    func calendar(calendar: CKCalendarView!, didDeselectDate date: NSDate!) {
        var abc = CKDateItem()
        abc.backgroundColor = UIColor.clearColor()
        chosenDates.removeObject(date)
    }
    
    func calendar(calendar: CKCalendarView!, willChangeToMonth date: NSDate!) -> Bool {
        self.chosenDates = []
        return true
    }
    
    func calendar(calendar: CKCalendarView!, didChangeToMonth date: NSDate!) {
        currentDate = date
        self.getBookingDetails()
        
    }

    */
    
    // FSCalendar functionality start
    
//    func calendarCurrentMonthDidChange(calendar: FSCalendar) {
//        // Do something
//        //currentDate = date
//        self.monthStartDate = "\(calendar.yearOfDate(calendar.currentPage))-\(calendar.monthOfDate(calendar.currentPage))-01"
//        self.monthEndDate = "\(calendar.yearOfDate(calendar.currentPage))-\(calendar.monthOfDate(calendar.currentPage))-\(calendar.numberOfDatesInMonthOfDate(calendar.currentPage))"
//        let currentPageStartDate = calendar.dateFromString("\(monthStartDate)", format: "yyyy-MM-dd")
//        let month = calendar.stringFromDate(currentPageStartDate, format: "MMMM")
//        monthChangeButton.titleLabel?.text = calendar.stringFromDate(currentPageStartDate, format: "MMMM")
//        yearChangeButton.titleLabel?.text = calendar.stringFromDate(currentPageStartDate, format: "yyyy")
//        println("Month Text: \(monthChangeButton.titleLabel?.text)")
//        println("Year Text: \(yearChangeButton.titleLabel?.text)")
//        self.getBookingDetails()
//        println("After")
//        println("Month Text: \(monthChangeButton.titleLabel?.text)")
//        println("Year Text: \(yearChangeButton.titleLabel?.text)")
//        monthChangeButton.titleLabel?.text = "\(month)"
//    }
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        
        if (chosenDates.count > 0) {
            for date in chosenDates {
                calendar.deselectDate(date as! NSDate)
                chosenDates.removeObject(date)
            }
        }
        self.monthStartDate = "\(calendar.yearOfDate(calendar.currentPage))-\(calendar.monthOfDate(calendar.currentPage))-01"
        self.monthEndDate = "\(calendar.yearOfDate(calendar.currentPage))-\(calendar.monthOfDate(calendar.currentPage))-\(calendar.numberOfDatesInMonthOfDate(calendar.currentPage))"
//        let currentPageStartDate = calendar.dateFromString("\(monthStartDate)", format: "yyyy-MM-dd")
//        let month = calendar.stringFromDate(currentPageStartDate, format: "MMMM")
//        monthChangeButton.titleLabel?.text = calendar.stringFromDate(currentPageStartDate, format: "MMMM")
//        yearChangeButton.titleLabel?.text = calendar.stringFromDate(currentPageStartDate, format: "yyyy")
        if (tempDisabledDates.count > 0) {
            for date in tempDisabledDates {
                calendar.deselectDate(calendar.dateFromString(date as! String, format: "yyyy-MM-dd"))
                
            }
            tempDisabledDates.removeAllObjects()
            disabledDates.removeAllObjects()
        }
        self.getBookingDetails()
        showHideUpdateButtonOnCalendarView()
    }
    
    func disableDates(date:NSDate)-> Bool {
        for disableDate in tempDisabledDates {
            if (disableDate as! String == calendar.stringFromDate(date, format: "yyyy-MM-dd")) {
                return true
            }
        }
        //showHideUpdateButtonOnCalendarView()
        return false
    }
    
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        
        var currentMonth = calendar.monthOfDate(calendar.currentPage)
        var dateMonth = calendar.stringFromDate(date, format: "MM")
        
        if (checkDateStausForSelection(date) == true) {
            if (dateMonth.toInt() == currentMonth && is_alreadyBookedDate == false) {
                
                chosenDates.addObject(date)
                is_alreadyBookedDate = false
                showHideUpdateButtonOnCalendarView()
                
            }
            else {
                calendar.deselectDate(date)
            }
        }
        else {
            calendar.deselectDate(date)
        }
        
        
    }
    
    // checking date is earlier or later
    // if return true then is not past date from today's date else it's past date
    
    func checkDateStausForSelection (date:NSDate) -> Bool {
        
        let selectedDate = calendar.stringFromDate(date, format: "dd")
        let todayDate = calendar.stringFromDate(currentDate, format: "dd")
        let selectedDateYear = calendar.stringFromDate(date, format: "yyyy")
        let todayDateYear = calendar.stringFromDate(currentDate, format: "yyyy")
        var flag = false
        for (var i = 0; i < calendarDetailsArray.count; i++) {
            if (calendarDetailsArray[i]["for_date"] as! NSString as String == calendar.stringFromDate(date, format: "yyyy-MM-dd")) {
                flag = true
                break
            }
        }
        
        if (flag == true) {
            if (calendar.monthOfDate(date) > calendar.monthOfDate(currentDate) && (todayDateYear.toInt() == selectedDateYear.toInt() || selectedDateYear.toInt() > todayDateYear.toInt())) {
                return true
            }
            else if (calendar.monthOfDate(date) == calendar.monthOfDate(currentDate) && todayDateYear.toInt() == selectedDateYear.toInt()) {
                if ((selectedDate.toInt() >= todayDate.toInt())) {
                    return true
                }
                else {
                    let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                    loadingProgress.mode = MBProgressHUDMode.Text
                    loadingProgress.detailsLabelText = "Can't select previous date"
                    loadingProgress.hide(true, afterDelay: 2)
                    return false
                }
            }
            else if (calendar.monthOfDate(date) < calendar.monthOfDate(currentDate) && todayDateYear.toInt() == selectedDateYear.toInt()) {
                let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                loadingProgress.mode = MBProgressHUDMode.Text
                loadingProgress.detailsLabelText = "Can't select previous date"
                loadingProgress.hide(true, afterDelay: 2)
                return false
            }
            else if (selectedDateYear.toInt() >= todayDateYear.toInt()) {
                return true
            }
            else {
                
                let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                loadingProgress.mode = MBProgressHUDMode.Text
                loadingProgress.detailsLabelText = "Can't select previous date"
                loadingProgress.hide(true, afterDelay: 2)
                return false
            }
        }
        else {
            
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProgress.mode = MBProgressHUDMode.Text
            let dateSelected = calendar.stringFromDate(date, format:"EE, dd-MMM-yyyy")
            loadingProgress.detailsLabelText = "Can't select \(dateSelected)). Please contact with lookvenue."
            loadingProgress.hide(true, afterDelay: 2)
            return false
            
        }
        
        
        

        
//        if (date == calendar.today) {
//            println(date)
//            return true
//        }
//        else if (date.earlierDate(calendar.today) == date) {
//            println(date)
//            return false
//        }
//        else {
//            println(date)
//            return true
//        }
        
        
//        if date.compare(calendar.today) == NSComparisonResult.OrderedDescending {
//            // its Earlier date
//            return false
//        }
//        else if date.compare(calendar.today) == NSComparisonResult.OrderedAscending {
//            // its later date
//            return true
//        }
//        else if date.compare(calendar.today) == NSComparisonResult.OrderedSame {
//            // its today date
//            return true
//        }
        //return false
    }
    
    func calendar(calendar: FSCalendar, appearance: FSCalendarAppearance, selectionColorForDate date: NSDate) -> UIColor? {
        if (disableDates(date) == true) {
            return appDelegate.mainColor
            
        }
        if (chosenDates.containsObject(date)) {
           return selectedColor
        }
        return selectedColor
    }
    
    
    func calendar(calendar: FSCalendar, didDeselectDate date: NSDate) {
        
        var currentMonth = calendar.monthOfDate(calendar.currentPage)
        var dateMonth = calendar.stringFromDate(date, format: "MM")
        
        if (checkDateStausForSelection(date) == true) {
            if (checkDateStausForSelection(date) == true) {
                if (chosenDates.count == 0) {
                    if (tempDisabledDates.containsObject(calendar.stringFromDate(date, format: "yyyy-MM-dd"))) {
                        tempDisabledDates.removeObject(calendar.stringFromDate(date, format: "yyyy-MM-dd"))
                        chosenDates.addObject(date)
                        calendar.selectDate(date)
                        is_alreadyBookedDate = true
                        self.calendar.reloadData()
                    }
                    else {
                        is_alreadyBookedDate = false
                    }
                }
                else {
                    
                    if(tempDisabledDates.containsObject(calendar.stringFromDate(date, format: "yyyy-MM-dd")) && is_alreadyBookedDate == true) {
                        // select
                        tempDisabledDates.removeObject(calendar.stringFromDate(date, format: "yyyy-MM-dd"))
                        chosenDates.addObject(date)
                        calendar.selectDate(date)
                        is_alreadyBookedDate = true
                        self.calendar.reloadData()
                    }
                    else if (disabledDates.containsObject(calendar.stringFromDate(date, format: "yyyy-MM-dd")) && is_alreadyBookedDate == true) {
                        // de select, remove from choosen
                        tempDisabledDates.addObject(calendar.stringFromDate(date, format: "yyyy-MM-dd"))
                        chosenDates.removeObject(date)
                        calendar.selectDate(date)
                        if (chosenDates.count == 0) {
                            is_alreadyBookedDate = false
                        }
                        else {
                            is_alreadyBookedDate = true
                        }
                        
                        self.calendar.reloadData()
                    }
                    else {
                        if (tempDisabledDates.containsObject(calendar.stringFromDate(date, format: "yyyy-MM-dd")) && is_alreadyBookedDate == false) {
                            calendar.selectDate(date)
                            is_alreadyBookedDate = false
                            self.calendar.reloadData()
                        }
                        else {
                            chosenDates.removeObject(date)
                            is_alreadyBookedDate = false
                        }
                    }
                    
                }
            }
            else {
                calendar.select(date)
                self.calendar.reloadData()
            }
        
        }
        else {
            calendar.selectDate(date)
        }
        
        

        showHideUpdateButtonOnCalendarView()
    }
    
//    func checkDateSelectionType(date:NSDate) {
//        var is_already_selected = false
//        for (var i = 0; i < chosenDates.count; i++) {
//            if("\(dateFormatter.stringFromDate(chosenDates[i] as! NSDate))" == "\(dateFormatter.stringFromDate(date))") {
//                is_already_selected = true
//                chosenDates.removeObject(date)
//                break
//            }
//        }
//        if (is_already_selected == false) {
//            var flag = checkDateSelection(date)
//            if (flag == true) {
//                
//                chosenDates.addObject(date)
//            }
//        }
//        if (chosenDates.count == 0) {
//            is_booked_selected = false
//        }
//        showHideUpdateButtonOnCalendarView()
//    }
    
    // FSCalendar functionality end
    
    
    
//    func checkDateSelection (date: NSDate)-> Bool {
//        var flag = false
//        if(chosenDates.count == 0) {
//            
//            for ( var i = 0; i < calendarDetailsArray.count; i++) {
//                var calendarDate = calendarDetailsArray[i]["for_date"] as! NSString as String
//                if ( calendarDate == "\(dateFormatter.stringFromDate(date))") {
//                    flag = true
//                    var status = calendarDetailsArray[i]["status"] as! NSNumber as Int
//                    if(status == 0) {
//                        is_booked_selected = true
//                        
//                        showHideUpdateButtonOnCalendarView()
//                        return true
//                    }
//                    else {
//                        is_booked_selected = false
//                        showHideUpdateButtonOnCalendarView()
//                        return false
//                    }
//                    
//                }
//            }
//        }
//            
//        else {
//            for ( var i = 0; i < calendarDetailsArray.count; i++) {
//                var calendarDate = calendarDetailsArray[i]["for_date"] as! NSString as String
//                if(calendarDate == "\(dateFormatter.stringFromDate(date))") {
//                    flag = true
//                    var status = calendarDetailsArray[i]["status"] as! NSNumber as Int
//                    if(status == 0 && is_booked_selected == true) {
//                        showHideUpdateButtonOnCalendarView()
//                        calendar.selectDate(date)
//                        return true
//                    }
//                    else if(status == 0 && is_booked_selected == false) {
//                        showHideUpdateButtonOnCalendarView()
//                        return false
//                    }
//                    else if(status == 1 && is_booked_selected == true) {
//                        showHideUpdateButtonOnCalendarView()
//                        return true
//                    }
//                    else if(status == 1 && is_booked_selected == false) {
//                        showHideUpdateButtonOnCalendarView()
//                        calendar.deselectDate(date)
//                        return false
//                    }
//                    
//                }
//            }
//        }
//        showHideUpdateButtonOnCalendarView()
//        return false
//    }
    
    func returnDate(date: NSDate) {
        //let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components(NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: date)
        let firstDay = self.returnDateForMonth(dateComponents.month, year: dateComponents.year, day: 1)
        let lastDay = self.returnDateForMonth(dateComponents.month+1, year: dateComponents.year, day: 0)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        monthStartDate = "\(dateFormatter.stringFromDate(firstDay))"
        monthEndDate = "\(dateFormatter.stringFromDate(lastDay) )"
        
    }
    
    
    func returnDateForMonth(month:NSInteger, year:NSInteger, day:NSInteger)->NSDate{
        let comp = NSDateComponents()
        comp.month = month
        comp.year = year
        comp.day = day
        //print(comp)
        let grego = NSCalendar.currentCalendar()
        return grego.dateFromComponents(comp)!
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.animateTextField(textField, up: true, withOffset: textField.frame.origin.y / 2)
        //self.services.resignFirstResponder()
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.animateTextField(textField, up: false, withOffset: textField.frame.origin.y / 2)
        //self.services.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func animateTextField(textField: UITextField, up: Bool, withOffset offset:CGFloat)
    {
        let movementDistance : Int = -Int(offset)
        let movementDuration : Double = 0.4
        let movement : Int = (up ? movementDistance : -movementDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, CGFloat(movement))
        UIView.commitAnimations()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
