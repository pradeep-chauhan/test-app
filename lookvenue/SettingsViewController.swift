//
//  SettingsViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 10/6/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var emailNotification: UISwitch!
    @IBOutlet weak var pushNotification: UISwitch!
    var selectedPropertyDetailsArray : NSMutableArray = NSMutableArray()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoutButton.backgroundColor = appDelegate.mainColor
        pushNotification.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        emailNotification.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.title = "Settings"
        
        let leftBarButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        // image for button
        leftBarButton.setImage(UIImage(named: "arrow-left.png"), forState: UIControlState.Normal)
        //set frame
        leftBarButton.frame = CGRectMake(0, 0,20, 20)
        leftBarButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftMenubarButton = UIBarButtonItem(customView: leftBarButton)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = leftMenubarButton
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonPressed() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func emailSwitch(sender: AnyObject) {
//        if(emailNotification.on) {
//            emailNotification.setOn(false, animated: true)
//        }
//        else {
//            emailNotification.setOn(true, animated: true)
//        }
    }
   
    @IBAction func pushSwitch(sender: AnyObject) {
//        if(pushNotification.on) {
//            pushNotification.setOn(false, animated: true)
//        }
//        else {
//            pushNotification.setOn(true, animated: true)
//        }
    }
    
    func stateChanged(switchState: UISwitch) {
        if(switchState.tag == 1) {
            if switchState.on {
                //println("The Switch is On")
            } else {
                //println("The Switch is Off")
            }
        }
        else {
            if switchState.on {
                //println("The Switch is On")
            } else {
                //println("The Switch is Off")
            }
        }
        
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("logout", object: nil)
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
