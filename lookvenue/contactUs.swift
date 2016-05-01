//
//  contactUs.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 8/6/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class contactUs: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tellUsMoreLabel: UILabel!
    @IBOutlet weak var venueType: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var contactNo: UITextField!
    var contactUsListArray:NSArray = NSArray()
    var contactUsArray:NSMutableArray = NSMutableArray()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var venueName:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.messageView.layer.borderWidth = 0.5
        self.messageView.layer.cornerRadius = 5
        self.messageView.clipsToBounds = true
        self.sendButton.backgroundColor = appDelegate.mainColor
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("email") == nil || NSUserDefaults.standardUserDefaults().objectForKey("email") as! String == "") {
            self.email.text = ""
            self.email.enabled = true
            self.venueType.text = ""
            self.venueType.enabled = true
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            //self.tableView.tableFooterView = UIView(frame: CGRectZero)
            self.navigationController?.navigationBar.barTintColor = appDelegate.mainColor
            
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
        else {
           self.email.text = NSUserDefaults.standardUserDefaults().objectForKey("email") as! String
            self.email.enabled = false
            self.venueType.text = venueName
            self.venueType.enabled = false
            
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
        
        self.email.userInteractionEnabled = false
        self.navigationItem.title = "How We Can Help You?"
        self.messageView.text = "Message"
        self.messageView.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        self.messageView.delegate = self
        self.tellUsMoreLabel.textColor = appDelegate.mainColor
//        self.contactNo.delegate = self
//        self.email.delegate = self
//        self.venueType.delegate = self
        var numberToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        numberToolbar.items = [UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelNumberPad"), UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneWithNumberPad")]
        numberToolbar.sizeToFit()
        numberToolbar.tintColor = appDelegate.mainColor
        contactNo.inputAccessoryView = numberToolbar
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
        
        
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func leftSideMenuButtonPressed() {
        self.menuContainerViewController.toggleLeftSideMenuCompletion { () -> Void in
            
        }
    }
    
    func backButtonPressed() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func contactusButton(sender: AnyObject) {
        
        var flag = validate()
        if ( flag == true) {
            var email = self.email.text
            var phone = self.contactNo.text
            var name = self.venueType.text
            var message = self.messageView.text
            
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingProgress.detailsLabelText = "Please wait"
            var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String
            var methodType: String = "POST"
            var base: String = "contacts"
            var param: String = ""
            var urlRequest: String = base
            var contact_details = [
                "name":name,
                "email":email,
                "message":message,
                "phone":phone
            ]
            var contact = [
                "contact":contact_details
            ]
            var connection = appDelegate.checkConnection()
            if (connection == true) {
                var serviceCall : WebServiceCall = WebServiceCall()
                serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param: contact, authentication: authentication, completion: { (resultData, response) -> () in
                    
//                    self.contactUsListArray = serviceCall.contactUsResult(resultData!)
//                    self.getContactUsArray()
                    if (response.statusCode == 422) {
                        loadingProgress.mode = MBProgressHUDMode.Text
//                        var error: NSArray = self.contactUsArray.valueForKey("errors") as! NSArray
//                        var msg: [String] = error[0] as! [String]
                        loadingProgress.detailsLabelText = "Message Not Sent"
                        loadingProgress.hide(true, afterDelay:2)
                    }
                    else if (response.statusCode == 200 || response.statusCode == 201) {
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.detailsLabelText = "Message Sent Successfully"
                        loadingProgress.hide(true, afterDelay: 2)
                        
                        self.messageView.text = "Message"
                        self.messageView.textColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
                        self.contactNo.text = ""
                        
                        
                    }
                    else {
                        loadingProgress.mode = MBProgressHUDMode.Text
                        loadingProgress.detailsLabelText = "Something went wrong"
                        loadingProgress.hide(true, afterDelay: 2)
                    }
                    
                })
            }
            else {
                appDelegate.showNetworkErrorView()
            }
            
            
        }
        
    }
    
    func checkMessage () {
        if ( messageView.textColor == UIColor.redColor() || messageView.text == "" || messageView.textColor == UIColor.grayColor().colorWithAlphaComponent(0.5)) {
            messageView.text = ""
            messageView.font = UIFont(name: "OpenSans", size: 16)
            messageView.textColor = UIColor.blackColor()
        }
    }
    
    func getContactUsArray() {
        contactUsArray = contactUsListArray as! NSMutableArray
    }
    
    func cancelNumberPad() {
        
        self.view.endEditing(true)
        
    }
    
    func doneWithNumberPad() {
        
        var numberFromTheKeyboard: String = contactNo.text
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.view.endEditing(false)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        checkMessage()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.view.endEditing(true)
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func validate() -> Bool {
        var flag:Bool = true
        var string:String = contactNo.text
        var length = count(string)
        if (venueType.text.isEmpty) {
            venueType.attributedPlaceholder = NSAttributedString(string:"Please enter venue type", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
        }
        
        if (contactNo.text.isEmpty) {
            
            contactNo.attributedPlaceholder = NSAttributedString(string:"Please enter mobile no.", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
            
        }
        
        if( length <= 9 && contactNo.text != "" && contactNo.text != nil) {
            contactNo.text = ""
            contactNo.attributedPlaceholder = NSAttributedString(string:"Please enter 10 digit", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
            flag = false
        }
        
        if (messageView.text.isEmpty || messageView.textColor == UIColor.grayColor()) {
            messageView.textColor = UIColor.redColor()
            messageView.text = "Please enter message"
            messageView.font = UIFont(name: "OpenSans", size: 14)
            flag = false
        }
        
        return flag
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
