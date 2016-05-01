//
//  forgotPasswordViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 2/9/16.
//  Copyright (c) 2016 Pradeep Chauhan. All rights reserved.
//

import UIKit

class forgotPasswordViewController: UIViewController {

    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var repeatEmail: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var buttonSaprator: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var repeatEmailSaprator: UILabel!
    @IBOutlet weak var emailSaprator: UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forgotButton.layer.cornerRadius = 5
        self.forgotButton.backgroundColor = appDelegate.mainColor
        self.loginButton.tintColor = appDelegate.mainColor
        self.signUpButton.tintColor = appDelegate.mainColor
        self.buttonSaprator.tintColor = appDelegate.mainColor
        self.emailSaprator.backgroundColor = appDelegate.mainColor
        self.repeatEmailSaprator.backgroundColor = appDelegate.mainColor
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = appDelegate.mainColor
        
        self.navigationItem.title = "Forgot Password"
        
        let leftBarButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        //set image for button
        leftBarButton.setImage(UIImage(named: "arrow-left.png"), forState: UIControlState.Normal)
        //add function for button
        leftBarButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        //set frame
        leftBarButton.frame = CGRectMake(0, 0,20, 20)
        
        let leftMenubarButton = UIBarButtonItem(customView: leftBarButton)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = leftMenubarButton
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var dash : UINavigationController = storyboard.instantiateViewControllerWithIdentifier("loginNav") as! UINavigationController
        self.menuContainerViewController.centerViewController = dash
        
    }
    
    
    @IBAction func signUpButtonClick(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var dash : UINavigationController = storyboard.instantiateViewControllerWithIdentifier("signUpNav") as! UINavigationController
        self.menuContainerViewController.centerViewController = dash
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
    
    @IBAction func forgotPasswordButton(sender: AnyObject) {
        let alert = UIAlertView()
        alert.title = "Sorry!"
        alert.message = "Send Email"
        alert.addButtonWithTitle("Ok")
        alert.show()
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
    
    func validate() -> Bool {
        var flag:Bool = true
        
        if (repeatEmail.text.isEmpty || repeatEmail.text != email.text) {
            repeatEmail.attributedPlaceholder = NSAttributedString(string:"Email doesn't match", attributes:[NSForegroundColorAttributeName: UIColor.redColor(),NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
