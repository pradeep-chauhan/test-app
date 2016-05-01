//
//  DashBoardViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 8/8/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController, SBPickerSelectorDelegate {
   
    let identifier = "Cell"
    
    @IBOutlet weak var propertyImage: UIButton!
    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var editPropertybutton: UIButton!
    @IBOutlet var tableView: UITableView!
//    @IBOutlet weak var DashBoardTabBar: UITabBar!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var propertyListArray : NSArray!
    var propertyArray : NSMutableArray = NSMutableArray()
    var checkAvailabilityListArray:NSArray = NSArray()
    var checkAvailabilityArray: NSMutableArray = NSMutableArray()
    var LoginDetails: loginDetails = loginDetails()
    var LoginDetailsArray:NSMutableArray = NSMutableArray()
    
    var menuName = [ "Edit Property","Calendar","Settings","Contact Us" ]
    var menuImage = [ "home-small-red.png","calendar-check.png","settings.png","email-outline.png" ]
    var withoutPropertyMenuName = [ "Add Property","Settings","Contact Us" ]
    var withoutPropertyMenuImage = [ "appproperty.png","settings.png","email-outline.png" ]
    @IBOutlet weak var checkAvailability: UIButton!
    var selectedPropertyDetailsArray : NSMutableArray = NSMutableArray()
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: NOTIFICATION_REACHABILITY_STATUS_CHANGED, object: nil)
        
        selectedPropertyDetailsArray = NSMutableArray()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationController?.navigationBar.barTintColor = appDelegate.mainColor
        self.checkAvailability.backgroundColor = appDelegate.mainColor
        
        
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
        
        // right bar
        
        let rightBarButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        //set image for button
        rightBarButton.setImage(UIImage(named: "magnify1.png"), forState: UIControlState.Normal)
        //add function for button
        rightBarButton.addTarget(self, action: "SearchButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        //set frame
        rightBarButton.frame = CGRectMake(0, 0,25, 25)
        
        let barButton = UIBarButtonItem(customView: rightBarButton)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        reachabilityStatusChanged()
        
    }
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS:
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.appDelegate.showNetworkErrorView()
            }
            
        default:
            
            if (appDelegate.listPropertySelectedFlag == true) {
                self.selectedPropertyDetailsArray = dashData.sharedInstance.selectedPropertyDetailsArray
                showPropertyDetails()
            }
            else {
               getPropertyDetails()
            }
            
        }
    }
    
    func getPropertyDetails() {
        let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingProgress.labelText = "Loading"
        var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String
        var methodType: String = "GET"
        var base: String = "properties"
        var param: String = ""
        var urlRequest: String = base
        var serviceCall : WebServiceCall = WebServiceCall()
        serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param: [:], authentication: authentication) { (resultData, response) -> () in
            if resultData == nil {
                loadingProgress.mode = MBProgressHUDMode.Text
                loadingProgress.labelText = "Record not found"
                loadingProgress.hide(true, afterDelay: 2)
                self.appDelegate.showNetworkErrorView()
            }
            else {
                if (response.statusCode == 200) {
                    self.propertyListArray = serviceCall.getPropertyDetailsArray(resultData!)
                    self.getPropertyArray()
                    
                    var selectedArray:NSMutableArray = NSMutableArray()
                    var tempDict : NSDictionary = self.propertyArray[0] as! NSDictionary
                    selectedArray.addObject(tempDict)
                    dashData.sharedInstance.selectedPropertyDetailsArray = selectedArray
                    
                    self.selectedPropertyDetailsArray = dashData.sharedInstance.selectedPropertyDetailsArray
                    NSNotificationCenter.defaultCenter().postNotificationName("updatePropertyList", object: nil)
                    
                    self.showPropertyDetails()
                   
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                }
                else {
                    let loadingProgress = MBProgressHUD.showHUDAddedTo(self.window, animated: true)
                    loadingProgress.labelText = "Record not found"
                    loadingProgress.hide(true, afterDelay: 2)
                }
                
            }
            
        }
    }
    
    func showPropertyDetails() {
        
        
        //        appDelegate.selectedProprtyCreatedDate = selectedPropertyDetailsArray[0]["created_at"] as! NSString as String
        //        println(appDelegate.selectedProprtyCreatedDate)
        
        if (self.selectedPropertyDetailsArray.count > 0) {
            self.propertyLabel.text = "Edit Property"
            self.propertyImage.setBackgroundImage(UIImage(named: "list-property.png"), forState: UIControlState.Normal)
        }
        else {
            self.propertyLabel.text = "Add Property"
            self.propertyImage.setBackgroundImage(UIImage(named: "appproperty.png"), forState: UIControlState.Normal)
        }
        
        
        if (self.selectedPropertyDetailsArray.count > 0) {
            self.appDelegate.firstTimeLogin = false
            var propertyName = self.selectedPropertyDetailsArray[0]["name"] as! NSString as String
            let trimmedString = propertyName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            var propertyNameStringArray = trimmedString.componentsSeparatedByString(" ")
            var propertyListName = ""
            for ( var i = 0; i < propertyNameStringArray.count; i++) {
                
                if (propertyNameStringArray[i] != "") {
                    propertyNameStringArray[i].replaceRange(propertyNameStringArray[i].startIndex...propertyNameStringArray[i].startIndex, with: String(propertyNameStringArray[i][propertyNameStringArray[i].startIndex]).capitalizedString)
                    propertyListName = propertyListName + " " + propertyNameStringArray[i]
                }
                
            }
            self.navigationItem.title = propertyListName
        }
        else {
            self.appDelegate.firstTimeLogin = true
            self.navigationItem.title = "Look Venue"
            
        }
    }
    
    func getPropertyArray() -> Void
    {
        propertyArray = propertyListArray as! NSMutableArray
        
    }
    
    func SearchButtonPressed() {
        //appDelegate.showControllerView ("navigationStart")
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var dash : searchProperrty = storyBoard.instantiateViewControllerWithIdentifier("searchPropertyInfo") as! searchProperrty
        dash.cityStatus = true
        appDelegate.selectedArea = []
        self.navigationController?.pushViewController(dash, animated: true)
    }
    
    func leftSideMenuButtonPressed() {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in
            
        }
    }
    
  
    @IBAction func editPropertyAction(sender: AnyObject) {
        
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if (selectedPropertyDetailsArray.count > 0) {
            var dash : propertyInfoSegmentViewController = storyBoard.instantiateViewControllerWithIdentifier("propertyInfoSegment") as! propertyInfoSegmentViewController
            dash.LoginDetails = LoginDetails
            dash.selectedPropertyDetailsArray = selectedPropertyDetailsArray
            self.navigationController?.pushViewController(dash, animated: true)
        }
        else {
            var dash : propertyInfoSegmentViewController = storyBoard.instantiateViewControllerWithIdentifier("propertyInfoSegment") as! propertyInfoSegmentViewController
            dash.LoginDetails = LoginDetails
            dash.selectedPropertyDetailsArray = []
            self.navigationController?.pushViewController(dash, animated: true)
        }
        
    }
    
    
    @IBAction func calendarAction(sender: AnyObject) {
        
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if (selectedPropertyDetailsArray.count > 0) {
            var dash : calendarViewController = storyBoard.instantiateViewControllerWithIdentifier("calendarViewController") as! calendarViewController
            dash.selectedPropertyDetailsArray = selectedPropertyDetailsArray
            dash.LoginDetails = LoginDetails
            self.navigationController?.pushViewController(dash, animated: true)
        }
        else {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Please add property first"
            loadingProgress.hide(true, afterDelay: 2)
        }
        
    }
    
    
    @IBAction func settingsAction(sender: AnyObject) {
        
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if (selectedPropertyDetailsArray.count > 0) {
            var dash : SettingsViewController = storyBoard.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
            dash.selectedPropertyDetailsArray = selectedPropertyDetailsArray
            self.navigationController?.pushViewController(dash, animated: true)
        }
        else {
            var dash : SettingsViewController = storyBoard.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
            dash.selectedPropertyDetailsArray = selectedPropertyDetailsArray
            self.navigationController?.pushViewController(dash, animated: true)
        }
        
    }
    
    
    @IBAction func contactUsAction(sender: AnyObject) {
        
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if (selectedPropertyDetailsArray.count > 0) {
            var venuetype = ""
//            for ( var i = 1; i < appDelegate.venueArrayListAppDelegate.count; i++) {
//                if ((appDelegate.venueArrayListAppDelegate[i]["id"] as! NSNumber == (selectedPropertyDetailsArray[0]["property_type_id"] as! NSNumber))) {
//                    venuetype = appDelegate.venueArrayListAppDelegate[i]["name"] as! NSString as String
//                    break
//                }
//            }
            venuetype = selectedPropertyDetailsArray[0]["name"] as! NSString as String
            
            if (venuetype != "") {
                var dash : contactUs = storyBoard.instantiateViewControllerWithIdentifier("contactUs") as! contactUs
                dash.venueName = venuetype
                self.navigationController?.pushViewController(dash, animated: true)
            }
        }
        else {
            var dash : contactUs = storyBoard.instantiateViewControllerWithIdentifier("contactUs") as! contactUs
            self.navigationController?.pushViewController(dash, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! propertyTableViewCell
//        if (selectedPropertyDetailsArray.count > 0) {
//            var imageString = menuImage[indexPath.row]
//            var image = UIImage(named: imageString)
//            cell.label.text = menuName[indexPath.row] as String
//            cell.imageName.image = image
//            cell.accessoryType  = UITableViewCellAccessoryType.DisclosureIndicator
//            cell.selectionStyle = UITableViewCellSelectionStyle.None
//            cell.backgroundColor = UIColor.clearColor()
//        }
//        else {
//            var imageString = withoutPropertyMenuImage[indexPath.row]
//            var image = UIImage(named: imageString)
//            cell.label.text = withoutPropertyMenuName[indexPath.row] as String
//            cell.imageName.image = image
//            cell.accessoryType  = UITableViewCellAccessoryType.DisclosureIndicator
//            cell.selectionStyle = UITableViewCellSelectionStyle.None
//            cell.backgroundColor = UIColor.clearColor()
//        }
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (selectedPropertyDetailsArray.count > 0) {
//           return menuName.count
//        }
//        else {
//            return withoutPropertyMenuName.count
//        }
//        
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        
//        if (selectedPropertyDetailsArray.count > 0) {
//            if(indexPath.row == 0) {
//                
//                var dash : propertyInfoSegmentViewController = storyBoard.instantiateViewControllerWithIdentifier("propertyInfoSegment") as! propertyInfoSegmentViewController
//                dash.LoginDetails = LoginDetails
//                dash.selectedPropertyDetailsArray = selectedPropertyDetailsArray
//                self.navigationController?.pushViewController(dash, animated: true)
//            }
//            else if(indexPath.row == 1) {
//                
//                var dash : calendarViewController = storyBoard.instantiateViewControllerWithIdentifier("calendarViewController") as! calendarViewController
//                dash.selectedPropertyDetailsArray = selectedPropertyDetailsArray
//                dash.LoginDetails = LoginDetails
//                self.navigationController?.pushViewController(dash, animated: true)
//            }
//            else if(indexPath.row == 2) {
//                
//                var dash : SettingsViewController = storyBoard.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
//                dash.selectedPropertyDetailsArray = selectedPropertyDetailsArray
//                self.navigationController?.pushViewController(dash, animated: true)
//            }
//            else {
//                var venuetype = ""
//                for ( var i = 1; i < appDelegate.venueArrayListAppDelegate.count; i++) {
//                    if ((appDelegate.venueArrayListAppDelegate[i]["id"] as! NSNumber == (selectedPropertyDetailsArray[0]["property_type_id"] as! NSNumber))) {
//                        venuetype = appDelegate.venueArrayListAppDelegate[i]["name"] as! NSString as String
//                        break
//                    }
//                }
//                var dash : contactUs = storyBoard.instantiateViewControllerWithIdentifier("contactUs") as! contactUs
//                dash.venueName = venuetype
//                self.navigationController?.pushViewController(dash, animated: true)
//            }
//        }
//        else {
//            if(indexPath.row == 0) {
//                
//                var dash : propertyInfoSegmentViewController = storyBoard.instantiateViewControllerWithIdentifier("propertyInfoSegment") as! propertyInfoSegmentViewController
//                dash.LoginDetails = LoginDetails
//                dash.selectedPropertyDetailsArray = []
//                self.navigationController?.pushViewController(dash, animated: true)
//            }
//            else if(indexPath.row == 1) {
//                
//                var dash : SettingsViewController = storyBoard.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
//                dash.selectedPropertyDetailsArray = selectedPropertyDetailsArray
//                self.navigationController?.pushViewController(dash, animated: true)
//            }
//            else {
//                var dash : contactUs = storyBoard.instantiateViewControllerWithIdentifier("contactUs") as! contactUs
//                self.navigationController?.pushViewController(dash, animated: true)
//            }
//        }
//        
//        
//        
//    }
    
    
    @IBAction func checkAvailabilityButton(sender: AnyObject) {
        
        if (selectedPropertyDetailsArray.count > 0) {
            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
            var dash : checkAvailabilityViewController = storyBoard.instantiateViewControllerWithIdentifier("checkAvailabilityViewController") as! checkAvailabilityViewController
            appDelegate.addPropertyMode = true
            self.navigationController?.pushViewController(dash, animated: true)
//            self.menuContainerViewController.centerViewController = dash
//            self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in
//                
//            }
        }
        else {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Please add property first"
            loadingProgress.hide(true, afterDelay: 2)
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //println("current view")
        
    }
    
    
    
//    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
//        if(item.tag == 0) {
//            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            var dash : ListPropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("ListPropertyViewController") as! ListPropertyViewController
//            dash.LoginDetails = LoginDetails
//            dash.LoginDetailsArray = LoginDetailsArray
//            //dash.propertyArray = self.propertyArray
//            dash.view.frame = CGRectMake(0, 0, self.displayControllerView.frame.size.width, self.displayControllerView.frame.size.height)
//            self.displayControllerView.addSubview(dash.view)
//            self.addChildViewController(dash)
//        }
//        else if(item.tag == 1) {
//            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            var dash : propertyInfoSegmentViewController = storyBoard.instantiateViewControllerWithIdentifier("propertyInfoSegment") as! propertyInfoSegmentViewController
//            dash.view.frame = CGRectMake(0, 0, self.displayControllerView.frame.size.width, self.displayControllerView.frame.size.height)
//            self.displayControllerView.addSubview(dash.view)
//            self.addChildViewController(dash)
//        }
//        else if(item.tag == 2) {
//            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            var dash : calendarViewController = storyBoard.instantiateViewControllerWithIdentifier("calendarViewController") as! calendarViewController
//            dash.view.frame = CGRectMake(0, 0, self.displayControllerView.frame.size.width, self.displayControllerView.frame.size.height)
//            self.displayControllerView.addSubview(dash.view)
//            self.addChildViewController(dash)
//        }
//        else if(item.tag == 3) {
//            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            var dash : contactUs = storyBoard.instantiateViewControllerWithIdentifier("contactUs") as! contactUs
//            dash.view.frame = CGRectMake(0, 0, self.displayControllerView.frame.size.width, self.displayControllerView.frame.size.height)
//            self.displayControllerView.addSubview(dash.view)
//            self.addChildViewController(dash)
//        }
//        else if(item.tag == 4) {
//            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            var dash : SettingsViewController = storyBoard.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
//            dash.view.frame = CGRectMake(0, 0, self.displayControllerView.frame.size.width, self.displayControllerView.frame.size.height)
//            self.displayControllerView.addSubview(dash.view)
//            self.addChildViewController(dash)
//        }
//        else {
//            println("tab bar")
//        }
//    }
    
    
//    @IBAction func editPropertyButton(sender: AnyObject) {
//        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        var dash : addProperty = storyBoard.instantiateViewControllerWithIdentifier("editPropertyView") as! addProperty
//        self.navigationController?.pushViewController(dash, animated: true)
//    }
    // MARK: - ENSideMenu Delegate
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
