//
//  ListPropertyViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 10/5/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class ListPropertyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var checkAvailability: UILabel!
    @IBOutlet weak var topBanner: UIView!
    var propertyArray : NSMutableArray = NSMutableArray()
    var propertyListArray : NSArray!
    var LoginDetails: loginDetails = loginDetails()
    var webhearder: WebServiceCall = WebServiceCall()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var LoginDetailsArray:NSMutableArray = NSMutableArray()
    var tableViewController = UITableViewController(style: .Plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBanner.backgroundColor = appDelegate.mainColor
//        self.tableView.estimatedRowHeight = 60
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.footerView.backgroundColor = appDelegate.mainColor
        tableView.backgroundColor = UIColor.clearColor()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshPropertyWithNotification:", name: "updatePropertyList", object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.grayColor()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshPropertyList", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("checkAvailabilityButton"))
        tapGesture.cancelsTouchesInView = true
        footerView.addGestureRecognizer(tapGesture)
        //tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    // Api call for pull to refresh
    
    func refreshPropertyList () {
        
        var connection = appDelegate.checkConnection()
        if (connection == true) {
            var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String
            var methodType: String = "GET"
            var base: String = "properties"
            var param: String = ""
            var urlRequest: String = base
            var serviceCall : WebServiceCall = WebServiceCall()
            serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param: [:], authentication: authentication) { (resultData, response) -> () in
                
                var alert:UIAlertView!
                
                if resultData == nil {
                    alert = UIAlertView(title: "Message", message: "Try Again", delegate: self, cancelButtonTitle: "Ok")
                    alert.show()
                }
                else {
                    if (response.statusCode == 200) {
                        
                        self.propertyListArray = serviceCall.getPropertyDetailsArray(resultData!)
                        self.getPropertyArray()
                        self.tableView.reloadData()
                    }
                    else {
                        
                        alert = UIAlertView(title: "Message", message: "Try Again", delegate: self, cancelButtonTitle: "Ok")
                        alert.show()
                    }
                }
                
            }
        }
        else {
            appDelegate.showNetworkErrorView()
        }
        
        
        self.refreshControl.endRefreshing()
        
    }
    
    // call this function when get property update notification
    
    func refreshPropertyWithNotification(notification: NSNotification) {
        
        var connection = appDelegate.checkConnection()
        if (connection == true) {
            var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String
            var methodType: String = "GET"
            var base: String = "properties"
            var param: String = ""
            var urlRequest: String = base
            var serviceCall : WebServiceCall = WebServiceCall()
            serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param: [:], authentication: authentication) { (resultData, response) -> () in
                
                var alert:UIAlertView!
                
                if resultData == nil {
                    alert = UIAlertView(title: "Message", message: "Try Again", delegate: self, cancelButtonTitle: "Ok")
                    alert.show()
                }
                else {
                    if (response.statusCode == 200) {
                        
                        self.propertyListArray = serviceCall.getPropertyDetailsArray(resultData!)
                        self.getPropertyArray()
                        self.tableView.reloadData()
                    }
                    else {
                        
                        alert = UIAlertView(title: "Message", message: "Try Again", delegate: self, cancelButtonTitle: "Ok")
                        alert.show()
                    }
                }
                
            }
        }
        else {
            appDelegate.showNetworkErrorView()
        }

    }
    
    
    func getPropertyArray() -> Void
    {
        propertyArray = propertyListArray as! NSMutableArray
        
    }
    
    // check availabilty 
    
    func checkAvailabilityButton () {
        
        if (propertyArray.count > 0) {
            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
            var dash : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("checkNav") as! UINavigationController
            appDelegate.addPropertyMode = true
            self.menuContainerViewController.centerViewController = dash
            self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in
                
            }
        }
        else {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Please add property first"
            loadingProgress.hide(true, afterDelay: 2)
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ListPropertyTableViewCell
        
        
        if (indexPath.row == 0) {
            cell.propertyName.text = "Add Property"
            let image = UIImage(named: "appproperty.png")
            cell.propertyImage.image = image
            cell.selectionStyle = .None
        }
        else {
            if (propertyArray.count > 0) {
                var propertyName = propertyArray[indexPath.row - 1]["name"] as! NSString as String
                let trimmedString = propertyName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
               
                var propertyNameStringArray = trimmedString.componentsSeparatedByString(" ")
                var propertyListName = ""
                for ( var i = 0; i < propertyNameStringArray.count; i++) {
                    
                    if (propertyNameStringArray[i] != " ") {
                        propertyNameStringArray[i].replaceRange(propertyNameStringArray[i].startIndex...propertyNameStringArray[i].startIndex, with: String(propertyNameStringArray[i][propertyNameStringArray[i].startIndex]).capitalizedString)
                        propertyListName = propertyListName + " " + propertyNameStringArray[i]
                    }
                    
                }
                
                //propertyName.replaceRange(propertyName.startIndex...propertyName.startIndex, with: String(propertyName[propertyName.startIndex]).capitalizedString)
                cell.propertyName.text = propertyListName
                let image = UIImage(named: "list-property.png")
                cell.propertyImage.image = image
                cell.selectionStyle = .None
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (propertyArray.count > 0) {
            return propertyArray.count + 1
        }
        else {
            return 1
        }
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 60
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if (indexPath.row == 0) {
            appDelegate.listPropertySelectedFlag = false
            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            var dash : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("addNav") as! UINavigationController
            appDelegate.addPropertyMode = true
            self.menuContainerViewController.centerViewController = dash
            self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in
                
            }
        }
        else if (propertyArray.count > 0 && indexPath.row > 0) {
            appDelegate.listPropertySelectedFlag = true
            var dash : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("dashNav") as! UINavigationController
            
            var selectedPropertyDetailsArray : NSMutableArray = NSMutableArray()
            var tempDict : NSDictionary = propertyArray[indexPath.row - 1] as! NSDictionary
            selectedPropertyDetailsArray.addObject(tempDict)
            //println(selectedPropertyDetailsArray)
            dashData.sharedInstance.selectedPropertyDetailsArray = NSMutableArray()
            dashData.sharedInstance.selectedPropertyDetailsArray = selectedPropertyDetailsArray
            //loginClass.loginSharedInstance.login = NSUserDefaults()
            loginClass.loginSharedInstance.login = LoginDetails
            self.menuContainerViewController.centerViewController = dash
            self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in
                
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

}
