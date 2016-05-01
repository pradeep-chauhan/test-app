//
//  calendarUserDetailsViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 2/22/16.
//  Copyright (c) 2016 Pradeep Chauhan. All rights reserved.
//

import UIKit

class calendarUserDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bookingInfoTableView: UITableView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var showBookingDetails:NSMutableArray = NSMutableArray()
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "dd-MMM-yyyy"
        self.bookingInfoTableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = appDelegate.mainColor
        let leftBarButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        // image for button
        leftBarButton.setImage(UIImage(named: "arrow-left.png"), forState: UIControlState.Normal)
        //set frame
        leftBarButton.frame = CGRectMake(0, 0,20, 20)
        self.navigationItem.title = "Customer Details"
        let leftMenubarButton = UIBarButtonItem(customView: leftBarButton)
        //assign button to navigationbar
        leftBarButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = leftMenubarButton
        //dateFormatter.dateFormat = "dd-MMM-yyyy"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! calendarUserDetailsTableViewCell
        
        if let for_date = showBookingDetails[indexPath.row]["for_date"] as? NSString {
            
            cell.bookingDate.text = showBookingDetails[indexPath.row]["for_date"] as! NSString as String
        }
        else {
            cell.customerName.text = ""
        }
        
        if let customer_name = showBookingDetails[indexPath.row]["customer_name"] as? NSString {
            if (customer_name != "") {
                cell.customerName.text = showBookingDetails[indexPath.row]["customer_name"] as! NSString as String
            }
            else {
               cell.customerName.text = "Name not available"
            }
            
            
        }
        else {
            cell.customerName.text = "Name not available"
        }
        
        if let customer_contact = showBookingDetails[indexPath.row]["customer_contact"] as? NSNumber {
            if (customer_contact != "") {
                cell.customerMobileNo.text = (showBookingDetails[indexPath.row]["customer_contact"] as! NSNumber).stringValue
                cell.callButton.addTarget(self, action: "callButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.callButton.tag = indexPath.row
                cell.callButton.enabled = true
                cell.callButton.setBackgroundImage(UIImage(named: "phone-red.png"), forState: UIControlState.Normal)
                
            }
            else {
                cell.customerMobileNo.text = "Phone number not available"
                cell.callButton.enabled = false
            }
            
        }
        else if let customer_contact = showBookingDetails[indexPath.row]["customer_contact"] as? NSString {
            if (customer_contact != "") {
                cell.customerMobileNo.text = showBookingDetails[indexPath.row]["customer_contact"] as! NSString as String
                cell.callButton.addTarget(self, action: "callButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.callButton.tag = indexPath.row
                println(cell.callButton.tag)
                cell.callButton.enabled = true
                cell.callButton.setBackgroundImage(UIImage(named: "phone-red.png"), forState: UIControlState.Normal)
                
            }
            else {
                cell.customerMobileNo.text = "Phone number not available"
                cell.callButton.enabled = false
            }
            
        }
        else {
            cell.customerMobileNo.text = "Phone number not available"
            cell.callButton.enabled = false
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showBookingDetails.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // Call if number is available
    
    func callButtonAction (sender:UIButton) {
        
        let phone = showBookingDetails[sender.tag]["customer_contact"] as! NSString as String
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + phone)!)
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
