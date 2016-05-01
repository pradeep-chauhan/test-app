//
//  checkAvailabilityViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 2/27/16.
//  Copyright (c) 2016 Pradeep Chauhan. All rights reserved.
//

import UIKit

class checkAvailabilityViewController: UIViewController, UITextFieldDelegate, SBPickerSelectorDelegate {
    
    var checkAvailabilityArray:NSMutableArray = NSMutableArray()
    var checkAvailabilityListArray:NSArray = NSArray()
    var sortedResults:NSArray = NSArray()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var propertyTableView: UITableView!
    @IBOutlet weak var checkAvailabilityDate: UITextField!
    var selectedDate = ""
    var pickerSelectValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAvailabilityDate.delegate = self
        self.propertyTableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = appDelegate.mainColor
        navigationItem.title = "Property Availability"
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
        datePicker(self.checkAvailabilityDate)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
//        tapGesture.cancelsTouchesInView = true
//        propertyTableView.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
        
        
    }
    
    func leftSideMenuButtonPressed() {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in
            
        }
    }
    
    func hideKeyboard() {
        self.propertyTableView.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! checkAvailabilityTableViewCell
        
        if(checkAvailabilityArray.count > 0) {
            cell.propertyName.text = checkAvailabilityArray[indexPath.row]["name"] as! NSString as String
            
            if (checkAvailabilityArray[indexPath.row]["status"] as! Int == 0) {
                cell.backgroundColorLabel.backgroundColor = UIColor.greenColor()
            }
            else {
                cell.backgroundColorLabel.backgroundColor = UIColor.redColor()
            }
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkAvailabilityArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @IBAction func datePicker(sender: AnyObject) {
        //self.checkAvailabilityDate.resignFirstResponder()
//        DatePickerDialog().show(title: "Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
//            (date) -> Void in
//            var dateFormatter = NSDateFormatter()
//            var dateFormatter1 = NSDateFormatter()
//            dateFormatter.dateFormat = "dd-MMM-yyyy"
//            dateFormatter1.dateFormat = "yyyy-MM-dd"
//            self.checkAvailabilityDate.text = dateFormatter.stringFromDate(date)
//            self.selectedDate = dateFormatter1.stringFromDate(date)
//            self.checkAvailabilityDate.resignFirstResponder()
            
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
        //}
        
    }
    
    
    func pickerSelector(selector: SBPickerSelector!, dateSelected date: NSDate!) {
        
        if(pickerSelectValue == "date") {
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            var dateFormatter = NSDateFormatter()
            var dateFormatter1 = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            self.checkAvailabilityDate.text = dateFormatter.stringFromDate(date)
            self.selectedDate = dateFormatter1.stringFromDate(date)
            
        }
        findPropertyStatus()
    }
    
    @IBAction func dateEndEditing(sender: AnyObject) {
        self.checkAvailabilityDate.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //checkAvailabilityDate.resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        self.view.endEditing(true)
    }
    
    // Find property status

    func findPropertyStatus () {
        var connection = appDelegate.checkConnection()
        if (connection == true) {
            var loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            if(self.checkAvailabilityDate.text != "") {
                var methodType: String = "GET"
                var base: String = "properties/properties_status_for?for_date=\(selectedDate)"
                var urlRequest: String = base
                var serviceCall : WebServiceCall = WebServiceCall()
                var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String
                loadingProgress.labelText = "Please wait..."
                
                serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param: [:], authentication: authentication, completion: { (resultData, response) -> Void in
                    
                    if resultData == nil {
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.labelText = ""
                        loadingProgress.detailsLabelText = "Result Not Found."
                        loadingProgress.hide(true, afterDelay: 2)
                        self.checkAvailabilityArray = []
                        self.propertyTableView.reloadData()
                    }
                    else {
                        if (response.statusCode == 200) {
                            self.checkAvailabilityListArray = serviceCall.getCheckAvailabilityArray(resultData!)
                            
                            var descriptor: NSSortDescriptor = NSSortDescriptor(key: "status", ascending: true)
                            self.sortedResults = self.checkAvailabilityListArray.sortedArrayUsingDescriptors([descriptor])
                            
                            self.getCheckAvailabilityArray()
                            
                            if((self.checkAvailabilityArray.count) > 0) {
                                self.propertyTableView.reloadData()
                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                            }
                            else {
                                loadingProgress.mode = MBProgressHUDMode.Text
                                loadingProgress.labelText = ""
                                loadingProgress.detailsLabelText = "Result Not Found."
                                loadingProgress.hide(true, afterDelay: 2)
                                self.checkAvailabilityArray = []
                                self.propertyTableView.reloadData()
                            }
                        }
                            
                        else {
                            loadingProgress.mode = MBProgressHUDMode.Text
                            loadingProgress.labelText = ""
                            loadingProgress.detailsLabelText = "Result Not Found."
                            loadingProgress.hide(true, afterDelay: 2)
                            self.checkAvailabilityArray = []
                            self.propertyTableView.reloadData()
                        }
                    }
                    
                })
            }
            else {
                loadingProgress.mode = MBProgressHUDMode.Text
                loadingProgress.detailsLabelText = "Please select date."
                loadingProgress.hide(true, afterDelay: 1)
            }
        }
        else {
            appDelegate.showNetworkErrorView()
        }
        
        
    }
    
    func getCheckAvailabilityArray() -> Void {
        checkAvailabilityArray = sortedResults.mutableCopy() as! NSMutableArray
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
