//
//  signUp.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 8/6/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class signUp: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailSaprator: UILabel!
    @IBOutlet weak var passwordSaprator: UILabel!
    @IBOutlet weak var nameSaprator: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var signUPListArray:NSArray!
    var signUPArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpButton.layer.cornerRadius = 5
        self.signUpButton.backgroundColor = appDelegate.mainColor
        self.loginButton.titleLabel!.textColor = appDelegate.mainColor
        
        self.password.delegate = self
        self.email.delegate = self
        self.name.delegate = self
//        self.nameSaprator.backgroundColor = appDelegate.mainColor
//        self.emailSaprator.backgroundColor = appDelegate.mainColor
//        self.passwordSaprator.backgroundColor = appDelegate.mainColor
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
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func leftSideMenuButtonPressed() {
        if ( self.menuContainerViewController == nil ) {
            
        }
        else {
            self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in
                
            }
        }
    }
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dash = storyBoard.instantiateViewControllerWithIdentifier("loginNav") as! UINavigationController
        self.menuContainerViewController.centerViewController = dash
//        appDelegate.showControllerView("loginNav")
    }
    
    func getSignUpArray() -> Void
    {
        signUPArray = signUPListArray as! NSMutableArray
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
    
    @IBAction func signUpAction(sender: AnyObject) {
//        DPNotify.sharedNotify.showNotifyInView(view, title:"working", dismissOnTap: true, notifyType: .DEFAULT)
//        println(DPNotify)
        
        var flag = validate()
        if ( flag == true) {
            var email = self.email.text
            var password = self.password.text
            var name = self.name.text
            
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingProgress.detailsLabelText = "Please wait"
            
            var methodType: String = "POST"
            var base: String = "users"
            var param: String = ""
            var urlRequest: String = base
            var details = [
                "name":name,
                "email":email,
                "password":password
            ]
            var user = [
                "user":details
            ]
            var connection = appDelegate.checkConnection()
            if (connection == true) {
                var serviceCall : WebServiceCall = WebServiceCall()
                serviceCall.apiCallRequest(methodType, urlRequest: urlRequest, param: user ,completion: { (resultData, response) -> () in
                    
                    if resultData == nil {
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.labelText = "Data Not Found"
                    }
                    else {
                        self.signUPListArray = serviceCall.signUpResult(resultData!)
                        self.getSignUpArray()
                        if (response.statusCode == 422) {
                            loadingProgress.mode = MBProgressHUDMode.Text
                            var error: NSArray = self.signUPArray.valueForKey("errors") as! NSArray
                            var msg: [String] = error[0] as! [String]
                            loadingProgress.detailsLabelText = "\(msg[0])"
                            loadingProgress.hide(true, afterDelay:2)
                        }
                        else if (response.statusCode == 200) {
                            loadingProgress.mode = MBProgressHUDMode.Text
                            loadingProgress.detailsLabelText = "Done"
                            loadingProgress.hide(true, afterDelay: 2)
                            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            var dash : DashBoardViewController = storyBoard.instantiateViewControllerWithIdentifier("DashboardView") as! DashBoardViewController
                            var dash1 : ListPropertyViewController = storyBoard.instantiateViewControllerWithIdentifier("ListPropertyViewController") as! ListPropertyViewController
                            dashData.sharedInstance.selectedPropertyDetailsArray = []
                            self.menuContainerViewController.leftMenuViewController = dash1
                            self.navigationController?.pushViewController(dash, animated: true)
                            
                        }
                        else {
                            loadingProgress.mode = MBProgressHUDMode.Text
                            loadingProgress.detailsLabelText = "Something went wrong"
                            loadingProgress.hide(true, afterDelay: 2)
                        }
                    } 
                    
                })
            }
            else {
                appDelegate.showNetworkErrorView()
            }
            
            
        }
        
        
        
//        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        var dash : DashBoardViewController = storyBoard.instantiateViewControllerWithIdentifier("DashboardView") as! DashBoardViewController
//        self.navigationController?.pushViewController(dash, animated: true)
        
        
    }
    
    
    // validation 
    
    func validate() -> Bool {
        var flag:Bool = true
        
        if (name.text.isEmpty) {
            name.attributedPlaceholder = NSAttributedString(string:"Please enter name", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
        }
        
        if (password.text.isEmpty) {
            
            password.attributedPlaceholder = NSAttributedString(string:"Please enter password", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
            
        }
        
        if (email.text.isEmpty) {
            email.attributedPlaceholder = NSAttributedString(string:"Please enter email", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
        }
        else {
            var valid = isValidEmail(email.text)
            if (valid == false) {
                email.text = ""
                email.attributedPlaceholder = NSAttributedString(string:"Email address is not valid", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
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
