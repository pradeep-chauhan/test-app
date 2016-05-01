
//
//  propertyInfoSegmentViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 8/11/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class propertyInfoSegmentViewController: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var addpropertyViewController : addProperty = addProperty()
    var propertyArray:NSMutableArray = NSMutableArray()
    var imageProperty : imagePropertyViewController = imagePropertyViewController()
    var selectedPropertyDetailsArray : NSMutableArray = NSMutableArray()
    var LoginDetails: loginDetails = loginDetails()
    var editPropertyListArray : NSArray!
    var editPropertyArray : NSMutableArray = NSMutableArray()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let leftBarButton: UIButton! = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading window show
        self.segmentControl.tintColor = appDelegate.mainColor
        appDelegate.addPropertyMode = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = appDelegate.mainColor
        // image for button
        leftBarButton.setImage(UIImage(named: "arrow-left.png"), forState: UIControlState.Normal)
        //set frame
        leftBarButton.frame = CGRectMake(0, 0,20, 20)
        
        let leftMenubarButton = UIBarButtonItem(customView: leftBarButton)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = leftMenubarButton
        loadPropertyData()
        
        if (selectedPropertyDetailsArray.count == 0) {
            self.segmentControl.enabled = false
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.segmentControl.selectedSegmentIndex = appDelegate.setSegmentControl
    }
    
    
    func backButtonPressed() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addProprtyBackButtonPressed() {
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        var dash : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("dashNav") as! UINavigationController
        self.menuContainerViewController.centerViewController = dash
    }
    
    func getEditPropertyArray() -> Void
    {
        editPropertyArray = editPropertyListArray as! NSMutableArray
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func segmentControlAction(sender: AnyObject) {
        if(segmentControl.selectedSegmentIndex == 0)
        {
            //self.navigationItem.rightBarButtonItem = nil
            loadPropertyData()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            addpropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("editPropertyView") as! addProperty
            addpropertyViewController.propertyArray = propertyArray
            addpropertyViewController.selectedPropertyDetailsArray = self.selectedPropertyDetailsArray
            addpropertyViewController.editPropertyArray = self.editPropertyArray
            addpropertyViewController.LoginDetails = self.LoginDetails
            addpropertyViewController.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)
            self.containerView.addSubview(addpropertyViewController.view)
            self.addChildViewController(addpropertyViewController)
            addpropertyViewController.didMoveToParentViewController(self)

        }
        else if(segmentControl.selectedSegmentIndex == 1)
        {
            loadPropertyData()
            //self.navigationItem.rightBarButtonItem = editButtonItem()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            imageProperty = storyBoard.instantiateViewControllerWithIdentifier("propertyImages") as! imagePropertyViewController
             self.imageProperty.editPropertyArray = self.editPropertyArray
            imageProperty.LoginDetails = self.LoginDetails
            imageProperty.view.frame = self.containerView.bounds
            self.containerView.addSubview(imageProperty.view)
            self.addChildViewController(imageProperty)
            imageProperty.didMoveToParentViewController(self)
        }
    }
    
    func segmentCall(tag:Int) {
        if(tag == 0)
        {
            loadPropertyData()
            //self.navigationItem.rightBarButtonItem = nil
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            addpropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("editPropertyView") as! addProperty
            addpropertyViewController.propertyArray = propertyArray
            addpropertyViewController.selectedPropertyDetailsArray = self.selectedPropertyDetailsArray
            addpropertyViewController.editPropertyArray = self.editPropertyArray
            addpropertyViewController.LoginDetails = self.LoginDetails
            addpropertyViewController.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)
            self.containerView.addSubview(addpropertyViewController.view)
            self.addChildViewController(addpropertyViewController)
            addpropertyViewController.didMoveToParentViewController(self)
            
        }
        else if(tag == 1)
        {
            loadPropertyData()
            //self.navigationItem.rightBarButtonItem = editButtonItem()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            imageProperty = storyBoard.instantiateViewControllerWithIdentifier("propertyImages") as! imagePropertyViewController
            println(editPropertyArray)
            self.imageProperty.editPropertyArray = []
            self.imageProperty.editPropertyArray = editPropertyArray
            println(self.imageProperty.editPropertyArray)
            imageProperty.LoginDetails = self.LoginDetails
            self.addChildViewController(imageProperty)
            imageProperty.view.frame = self.containerView.bounds
            self.containerView.addSubview(imageProperty.view)
            
            imageProperty.didMoveToParentViewController(self)
        }
    }
    
    func loadPropertyData () {
        
        let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingProgress.labelText = "Loading"
        
        if( self.selectedPropertyDetailsArray.count > 0 ) {
            
            var propertyName = selectedPropertyDetailsArray[0]["name"] as! NSString as String
            let trimmedString = propertyName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            var propertyNameStringArray = trimmedString.componentsSeparatedByString(" ")
            var propertyListName = ""
            for ( var i = 0; i < propertyNameStringArray.count; i++) {
                propertyNameStringArray[i].replaceRange(propertyNameStringArray[i].startIndex...propertyNameStringArray[i].startIndex, with: String(propertyNameStringArray[i][propertyNameStringArray[i].startIndex]).capitalizedString)
                propertyListName = propertyListName + " " + propertyNameStringArray[i]
            }
            self.navigationItem.title = propertyListName
            
            leftBarButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            
            var authentication = ( self.LoginDetails.remember_token as NSString) as String
            var methodType: String = "GET"
            var propertyId = (selectedPropertyDetailsArray[0]["id"] as! NSNumber).stringValue
            //println(propertyId)
            var base: String = "properties/\(propertyId).json"
            var param: String = ""
            var urlRequest: String = base
            var serviceCall : WebServiceCall = WebServiceCall()
            var connection = appDelegate.checkConnection()
            if (connection == true) {
                serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param: [:], authentication: authentication) { (resultData, response) -> Void in
                    
                    if resultData == nil {
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.detailsLabelText = "Property Info Not Found"
                        loadingProgress.hide(true, afterDelay: 2)
                    }
                    else {
                        if (response.statusCode == 200) {
                            self.editPropertyListArray = serviceCall.getEditPropertyArray(resultData!)
                            self.getEditPropertyArray()
                            
                            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                            //alert.dismissWithClickedButtonIndex(0, animated: true)
                            
                            if(self.segmentControl.selectedSegmentIndex == 0)
                            {
                                
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                self.addpropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("editPropertyView") as! addProperty
                                self.addpropertyViewController.editPropertyArray = self.editPropertyArray
                                self.addpropertyViewController.selectedPropertyDetailsArray = self.selectedPropertyDetailsArray
                                self.addpropertyViewController.LoginDetails = self.LoginDetails
                                self.addpropertyViewController.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)
                                self.containerView.addSubview(self.addpropertyViewController.view)
                                self.addChildViewController(self.addpropertyViewController)
                                self.addpropertyViewController.didMoveToParentViewController(self)
                                
                            }
                            else if(self.segmentControl.selectedSegmentIndex == 1)
                            {
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                self.imageProperty = storyBoard.instantiateViewControllerWithIdentifier("propertyImages") as! imagePropertyViewController
                                self.imageProperty.editPropertyArray = self.editPropertyArray
                                self.imageProperty.LoginDetails = self.LoginDetails
                                self.imageProperty.view.frame = self.containerView.bounds
                                self.containerView.addSubview(self.imageProperty.view)
                                self.addChildViewController(self.imageProperty)
                                self.imageProperty.didMoveToParentViewController(self)
                            }
                        }
                        else {
                            loadingProgress.mode = MBProgressHUDMode.Text
                            loadingProgress.detailsLabelText = "Property Info Not Found"
                            loadingProgress.hide(true, afterDelay: 2)
                            if(self.segmentControl.selectedSegmentIndex == 0)
                            {
                                
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                self.addpropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("editPropertyView") as! addProperty
                                self.addpropertyViewController.editPropertyArray = self.editPropertyArray
                                self.addpropertyViewController.selectedPropertyDetailsArray = self.selectedPropertyDetailsArray
                                self.addpropertyViewController.LoginDetails = self.LoginDetails
                                self.addpropertyViewController.view.frame = CGRectMake(0, 0,self.containerView.frame.size.width, self.containerView.frame.size.height)
                                self.containerView.addSubview(self.addpropertyViewController.view)
                                self.addChildViewController(self.addpropertyViewController)
                                self.addpropertyViewController.didMoveToParentViewController(self)
                                
                            }
                            else if(self.segmentControl.selectedSegmentIndex == 1)
                            {
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                self.imageProperty = storyBoard.instantiateViewControllerWithIdentifier("propertyImages") as! imagePropertyViewController
                                //                        self.imageProperty.editPropertyArray = self.editPropertyArray
                                self.imageProperty.LoginDetails = self.LoginDetails
                                self.imageProperty.view.frame = self.containerView.bounds
                                self.containerView.addSubview(self.imageProperty.view)
                                self.addChildViewController(self.imageProperty)
                                self.imageProperty.didMoveToParentViewController(self)
                            }
                        }
                    }
                    
                    
                }
            }
            else {
                appDelegate.showNetworkErrorView()
            }
            
        }
        else {
            self.navigationItem.title = "Add Property"
            leftBarButton.addTarget(self, action: "addProprtyBackButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.selectedPropertyDetailsArray = []
            self.editPropertyArray = []
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if(self.segmentControl.selectedSegmentIndex == 0)
            {
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                self.addpropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("editPropertyView") as! addProperty
                self.addpropertyViewController.editPropertyArray = self.editPropertyArray
                self.addpropertyViewController.selectedPropertyDetailsArray = self.selectedPropertyDetailsArray
                //self.addpropertyViewController.LoginDetails = self.LoginDetails
                self.addpropertyViewController.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)
                self.containerView.addSubview(self.addpropertyViewController.view)
                self.addChildViewController(self.addpropertyViewController)
                self.addpropertyViewController.didMoveToParentViewController(self)
                
            }
            else if(self.segmentControl.selectedSegmentIndex == 1)
            {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                self.imageProperty = storyBoard.instantiateViewControllerWithIdentifier("propertyImages") as! imagePropertyViewController
                self.imageProperty.editPropertyArray = self.editPropertyArray
                //self.imageProperty.LoginDetails = self.LoginDetails
                self.imageProperty.view.frame = self.containerView.bounds
                self.containerView.addSubview(self.imageProperty.view)
                self.addChildViewController(self.imageProperty)
                self.imageProperty.didMoveToParentViewController(self)
            }
            
        }
    }
    
    // Disable segment while uploading data
    
    func changeSegmentStatus(flag:Bool) {
        if (flag == true) {
           segmentControl.enabled = false
        }
        else {
           segmentControl.enabled = true
        }
        
    }
    
    func selectedSegmentControll () {
        segmentControl.selectedSegmentIndex = 1
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
