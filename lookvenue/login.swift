//
//  login.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 8/6/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class login:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var passwordSaprator: UILabel!
    @IBOutlet weak var usernameSaprator: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var password: UITextField!
    var propertyArray : NSMutableArray = NSMutableArray()
    var propertyListArray : NSArray!
    
    var loginDetailsListArray : NSArray!
    var loginDetailsArray : NSMutableArray = NSMutableArray()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var LoginDetails: loginDetails = loginDetails()
    var networkErrorUIView: networkErrorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.backgroundColor = appDelegate.mainColor
        //self.forgotPasswordButton.tintColor = appDelegate.mainColor
        self.signUpButton.tintColor = appDelegate.mainColor
//        self.usernameSaprator.backgroundColor = appDelegate.mainColor
//        self.passwordSaprator.backgroundColor = appDelegate.mainColor
        self.username.delegate = self
        self.password.delegate = self
        self.username.text = "pankaj@gkmit.co"
        self.password.text = "1"
        //self.username.enabled = false
        //self.password.enabled = false
        // Calling side mune bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = appDelegate.mainColor
        // center image in nav bar
        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
//        imageView.contentMode = .ScaleAspectFit
//        
//        let image = UIImage(named: "look-venue-logo.png")
//        imageView.image = image
        //self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationItem.title = "LookVenue"
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
        networkErrorUIView = NSBundle.mainBundle().loadNibNamed("NetworkErrorView", owner: self, options: nil).first as! networkErrorView
        var rememberToken = ""
        if let checkRememberToken = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as? NSString {
            rememberToken = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String
        }
        else {
            rememberToken = ""
        }
        
        if ( rememberToken != "" ) {
            
          isAlreadylogin()
            
        }
        
        
    }
    
    func getLoginDetailsArray() -> Void
    {
        loginDetailsArray = loginDetailsListArray as! NSMutableArray
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }

//    @IBAction func forgotButton(sender: AnyObject) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let dash : forgotPasswordViewController = storyboard.instantiateViewControllerWithIdentifier("forgotPasswordViewController") as! forgotPasswordViewController
//        self.navigationController?.pushViewController(dash, animated: true)
//    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dash = storyBoard.instantiateViewControllerWithIdentifier("signUpNav") as! UINavigationController
        self.menuContainerViewController.centerViewController = dash
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftSideMenuButtonPressed() {
        if ( self.menuContainerViewController == nil ) {
            
        }
        else {
            self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in
                
            }
        }
        
    }
    
    // MARK: - ENSideMenu Delegate
    

    @IBAction func showForgotPasswordAction(sender: AnyObject) {
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
    }
    
    func getPropertyArray() -> Void
    {
        propertyArray = propertyListArray as! NSMutableArray
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.animateTextField(textField, up: true, withOffset: textField.frame.origin.y / 2)
        //self.services.resignFirstResponder()
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        self.animateTextField(textField, up: false, withOffset: textField.frame.origin.y / 2)
//        textField.resignFirstResponder()
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
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        
        var connection = appDelegate.checkConnection()
        
        if (connection == true) {
            let flag = validate()
            
            if (flag == true) {
                let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                var username = self.username.text
                var password = self.password.text
                var param1: String = username
                var param2: String = password
                var device_token = "123"
                var methodType: String = "GET"
                var base: String = "user_sign_in?email=\(param1)&password=\(param2)&device_token=\(device_token)"
                
                var urlRequest: String = base
                var serviceCall : WebServiceCall = WebServiceCall()
                //indicator.startAnimating()
                serviceCall.apiCallRequest(methodType, urlRequest: urlRequest, param: [:], completion: {(resultData, response) -> Void in
                    if(response.statusCode == 401 || response.statusCode == 422) {
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.detailsLabelText = "username and password is wrong"
                        loadingProgress.hide(true, afterDelay: 2)
                    }
                    else if(response.statusCode == 200) {
                        
                        self.loginDetailsListArray = serviceCall.getLoginDetailsArray(resultData!)
                        self.getLoginDetailsArray()
                        self.LoginDetails.remember_token = (self.loginDetailsArray[0]["remember_token"] as! NSString as String)
                        self.LoginDetails.created_at = (self.loginDetailsArray[0]["created_at"] as! NSString as String)
                        self.LoginDetails.id = (self.loginDetailsArray[0]["id"] as! NSNumber).stringValue
                        self.LoginDetails.updated_at = (self.loginDetailsArray[0]["updated_at"] as! NSString as String)
                        self.LoginDetails.archive = (self.loginDetailsArray[0]["archive"] as! NSNumber).stringValue
                        self.LoginDetails.email = (self.loginDetailsArray[0]["email"] as! NSString as String)
                        self.LoginDetails.encrypted_password = (self.loginDetailsArray[0]["encrypted_password"] as! NSString as String)
                        //Calling view Controller
                        var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String
                        var methodType: String = "GET"
                        var base: String = "properties"
                        var param: String = ""
                        var urlRequest: String = base
                        var serviceCall : WebServiceCall = WebServiceCall()
                        serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param: [:], authentication: authentication) { (resultData, response) -> () in
                            
                            if (response.statusCode == 200) {
                                
                                self.propertyListArray = serviceCall.getPropertyDetailsArray(resultData!)
                                self.getPropertyArray()
                                
                                if( self.propertyArray.count > 0) {
                                    
                                    var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    var dash : DashBoardViewController = storyBoard.instantiateViewControllerWithIdentifier("DashboardView") as! DashBoardViewController
                                    var dash1 : ListPropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("ListPropertyViewController") as! ListPropertyViewController
                                    dash1.LoginDetails = self.LoginDetails
                                    dash1.LoginDetailsArray = self.loginDetailsArray
                                    dash1.propertyArray = self.propertyArray
                                    self.appDelegate.firstTimeLogin = false
                                    //dash.LoginDetails = self.LoginDetails
                                    dash.LoginDetailsArray = self.loginDetailsArray
                                    var selectedPropertyDetailsArray:NSMutableArray = NSMutableArray()
                                    var tempDict : NSDictionary = self.propertyArray[0] as! NSDictionary
                                    selectedPropertyDetailsArray.addObject(tempDict)
                                    dashData.sharedInstance.selectedPropertyDetailsArray = selectedPropertyDetailsArray
                                    dash.LoginDetails = self.LoginDetails
                                    self.menuContainerViewController.leftMenuViewController = dash1
                                    self.navigationController?.pushViewController(dash, animated: true)
                                }
                                    
                                else {
                                    var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    var dash : DashBoardViewController = storyBoard.instantiateViewControllerWithIdentifier("DashboardView") as! DashBoardViewController
                                    var dash1 : ListPropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("ListPropertyViewController") as! ListPropertyViewController
                                    dash1.LoginDetails = self.LoginDetails
                                    dash1.LoginDetailsArray = self.loginDetailsArray
                                    dash1.propertyArray = []
                                    self.appDelegate.firstTimeLogin = true
                                    //dash.LoginDetails = self.LoginDetails
                                    dash.LoginDetailsArray = self.loginDetailsArray
                                    dashData.sharedInstance.selectedPropertyDetailsArray = []
                                    dash.LoginDetails = self.LoginDetails
                                    self.menuContainerViewController.leftMenuViewController = dash1
                                    self.navigationController?.pushViewController(dash, animated: true)
                                }
                            }
                            
                        }
                        
                    }
                    else {
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.detailsLabelText = "Server Error"
                        loadingProgress.hide(true, afterDelay: 2)
                    }
                    
                })
                
                // Calling view Controller
                //        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                //        var dash : DashBoardViewController = storyBoard.instantiateViewControllerWithIdentifier("DashboardView") as! DashBoardViewController
                //        self.navigationController?.pushViewController(dash, animated: true)
                
                
                //        var request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: "http:lookvenue.herokuapp.com/property_types/")!)
                //        request.HTTPMethod = "GET"
                //        var error : NSError?
                //        var response : NSURLResponse?
                //
                //        var data : NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!
                //
                //        if(error == nil)
                //        {
                //            var resultString : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                //            var dictionary : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSArray
                //            println((dictionary[0] as! NSDictionary).valueForKey("name"))
                //            println(resultString)
                //        }
                //        else
                //        {
                //            println(error?.localizedDescription)
                //        }
                
                
                //                var request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: "http://lookvenue.herokuapp.com/user_sign_in?email=prdpchauhan4@gmail.com&password=1&device_token=123")!)
                //                request.HTTPMethod = "GET"
                //                var error : NSError?
                //                var response : NSURLResponse?
                //
                //                var data : NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!
                //
                //                if(error == nil)
                //                {
                //                    var resultString : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                //                    var dictionary : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSArray
                //                    println((dictionary[0] as! NSDictionary).valueForKey("email"))
                //                    println(resultString)
                //                    
                //                }
                //                else
                //                {
                //                    println(error?.localizedDescription)
                //                }
            }
            
        }
        else {
            showNetworkErrorView()
        }
        
    }
    
    func showNetworkErrorView() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.addSubview(networkErrorUIView)
        self.networkErrorUIView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.networkErrorUIView.retry.backgroundColor = appDelegate.mainColor
        self.networkErrorUIView.lookVenueLabel.textColor = appDelegate.mainColor
        self.networkErrorUIView.retry.addTarget(self, action: "retryButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func retryButtonAction () {
        var connection = appDelegate.checkConnection()
        
        if(connection == true) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.networkErrorUIView.removeFromSuperview()
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func isAlreadylogin () {
        var loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String
        if  (authentication != "") {
            var authentication = authentication
            var methodType: String = "GET"
            var base: String = "properties"
            var param: String = ""
            var urlRequest: String = base
            var serviceCall : WebServiceCall = WebServiceCall()
            serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param: [:], authentication: authentication) { (resultData, response) -> () in
                
                if (response.statusCode == 200) {
                    self.propertyListArray = serviceCall.getPropertyDetailsArray(resultData!)
                    self.getPropertyArray()
                    
                    if( self.propertyArray.count > 0) {
                        
                        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        var dash : DashBoardViewController = storyBoard.instantiateViewControllerWithIdentifier("DashboardView") as! DashBoardViewController
                        
                        var dash1 : ListPropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("ListPropertyViewController") as! ListPropertyViewController
                        dash1.propertyArray = self.propertyArray
                        self.appDelegate.firstTimeLogin = false
                        var selectedPropertyDetailsArray:NSMutableArray = NSMutableArray()
                        var tempDict : NSDictionary = self.propertyArray[0] as! NSDictionary
                        selectedPropertyDetailsArray.addObject(tempDict)
                        dashData.sharedInstance.selectedPropertyDetailsArray = selectedPropertyDetailsArray
                        self.menuContainerViewController.leftMenuViewController = dash1
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.navigationController?.pushViewController(dash, animated: true)
                        
                    }
                    else {
                        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        var dash : DashBoardViewController = storyBoard.instantiateViewControllerWithIdentifier("DashboardView") as! DashBoardViewController
                        var dash1 : ListPropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("ListPropertyViewController") as! ListPropertyViewController
                        dash1.LoginDetails = self.LoginDetails
                        dash1.LoginDetailsArray = self.loginDetailsArray
                        dash1.propertyArray = []
                        //dash.LoginDetails = self.LoginDetails
                        self.appDelegate.firstTimeLogin = true
                        dash.LoginDetailsArray = self.loginDetailsArray
                        dashData.sharedInstance.selectedPropertyDetailsArray = []
                        dash.LoginDetails = self.LoginDetails
                        self.menuContainerViewController.leftMenuViewController = dash1
                        self.navigationController?.pushViewController(dash, animated: true)
                        
                    }
                }
                else {
                    self.showNetworkErrorView()
                }
                
                
            }
        }
    }
    
    func validate() -> Bool {
        var flag:Bool = true
        
        if (password.text.isEmpty) {
            
            password.attributedPlaceholder = NSAttributedString(string:"Please enter password", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
            
        }
        
        if (username.text.isEmpty) {
            username.attributedPlaceholder = NSAttributedString(string:"Please enter email", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
        }
        else {
            var valid = isValidEmail(username.text)
            if (valid == false) {
                username.text = ""
                username.attributedPlaceholder = NSAttributedString(string:"Email address is not valid", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
                flag = false
                
            }
            else {
                flag = true
            }
        }
        
        return flag
    }
    
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(emailID)
    }

}
