//
//  propertyViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 9/4/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class propertyViewController: UIViewController, CLUploaderDelegate, UITabBarDelegate {

    @IBOutlet weak var containerView: UIView!
    //@IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var information : infoViewController = infoViewController()
    var location : locationViewController = locationViewController()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var mainTabBar: UITabBar!
    // cloudinary setup
    
    var selectedSearchVanueDictionary = NSDictionary()
    
    var name:String!
    var website:String!
    var Description:String!
    var priceRange:String!
    var rooms:String!
    var parkingCapacity:String!
    var coverdArea:String!
    var propertyCapacity:String!
    var venueType:String!
    var address:String!
    var area:String!
    var city:String!
    var state:String!
    var zipcode:String!
    var lat:Double!
    var long:Double!
    var images: NSMutableArray!
    var phone:String!
    var email:String!
    var perPlate:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainTabBar.delegate = self
        self.segmentControl.tintColor = appDelegate.mainColor
        self.segmentControl.backgroundColor = UIColor.whiteColor()
        self.mainTabBar.barTintColor = appDelegate.mainColor
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        if let mobile_number = selectedSearchVanueDictionary.valueForKey("mobile_number") as? NSString {
            phone = selectedSearchVanueDictionary.valueForKey("mobile_number") as! NSString as String
        } else {
            phone = ""
        }
        
        if let emailAddress = selectedSearchVanueDictionary.valueForKey("email") as? NSString {
            email = selectedSearchVanueDictionary.valueForKey("email") as! NSString as String
        } else {
            email = ""
        }
        
        if let nameString = selectedSearchVanueDictionary.valueForKey("name") as? NSString {
            name = selectedSearchVanueDictionary.valueForKey("name") as! NSString as String
        } else {
            name = ""
        }
        
        if let websiteString = selectedSearchVanueDictionary.valueForKey("website") as? NSString {
             website = selectedSearchVanueDictionary.valueForKey("website") as! NSString as String
        } else {
            website = ""
        }
        
        if let perPlateString = selectedSearchVanueDictionary.valueForKey("price_per_plate") as? NSNumber {
            perPlate = (selectedSearchVanueDictionary.valueForKey("price_per_plate") as! NSNumber).stringValue
        } else {
            perPlate = ""
        }
        
        if let DescriptionString = selectedSearchVanueDictionary.valueForKey("description") as? NSString {
            Description = selectedSearchVanueDictionary.valueForKey("description") as! NSString as String
        } else {
            Description = ""
        }
        
        if let priceRangeString = selectedSearchVanueDictionary.valueForKey("price_range") as? NSString {
            priceRange = selectedSearchVanueDictionary.valueForKey("price_range") as! NSString as String
        } else {
            priceRange = ""
        }
        
        if let roomsString = selectedSearchVanueDictionary.valueForKey("rooms") as? NSNumber {
            rooms = (selectedSearchVanueDictionary.valueForKey("rooms") as! NSNumber).stringValue
        } else {
            rooms = ""
        }
        
        if let parkingCapacityString = selectedSearchVanueDictionary.valueForKey("parking") as? NSNumber {
            parkingCapacity = (selectedSearchVanueDictionary.valueForKey("parking") as! NSNumber).stringValue
        } else {
            parkingCapacity = ""
        }
       
        if let coverdAreaString = selectedSearchVanueDictionary.valueForKey("covered_area") as? NSNumber {
            coverdArea = (selectedSearchVanueDictionary.valueForKey("covered_area") as? NSNumber)!.stringValue
        } else {
            coverdArea = ""
        }
        
        if let propertyCapacityString = selectedSearchVanueDictionary.valueForKey("capacity") as? NSNumber {
            propertyCapacity = (selectedSearchVanueDictionary.valueForKey("capacity") as? NSNumber)!.stringValue
        } else {
            propertyCapacity = ""
        }
        
        if let venueTypeString = selectedSearchVanueDictionary.valueForKey("property_type") as? NSString {
            venueType = selectedSearchVanueDictionary.valueForKey("property_type") as! NSString as String
        } else {
            venueType = ""
        }
        
        if let addressString = selectedSearchVanueDictionary.valueForKey("address_line_1") as? NSString {
            address = selectedSearchVanueDictionary.valueForKey("address_line_1") as! NSString as String
        } else {
            address = ""
        }
        
        if let areaString = selectedSearchVanueDictionary.valueForKey("area") as? NSString {
            area = selectedSearchVanueDictionary.valueForKey("area") as! NSString as String
        } else {
            area = ""
        }
        
        if let cityString = selectedSearchVanueDictionary.valueForKey("city") as? NSString {
            city = selectedSearchVanueDictionary.valueForKey("city") as! NSString as String
        } else {
            city = ""
        }
        
        if let stateString = selectedSearchVanueDictionary.valueForKey("state") as? NSString {
            state = selectedSearchVanueDictionary.valueForKey("state") as! NSString as String
        } else {
            state = ""
        }
        
        if let zipcodeString = selectedSearchVanueDictionary.valueForKey("zipcode") as? NSString {
            zipcode = selectedSearchVanueDictionary.valueForKey("zipcode") as! NSString as String
        } else {
            zipcode = ""
        }
        
        if let latString = selectedSearchVanueDictionary.valueForKey("lat") as? NSString {
            lat = (selectedSearchVanueDictionary.valueForKey("lat") as! NSString).doubleValue
        } else {
            lat = 0.0
        }
        
        if let longString = selectedSearchVanueDictionary.valueForKey("lng") as? NSString {
            long = (selectedSearchVanueDictionary.valueForKey("lng") as! NSString).doubleValue
        } else {
            long = 0.0
        }
        
        
        images = (selectedSearchVanueDictionary.valueForKey("images")) as! NSMutableArray
        
        
        if(segmentControl.selectedSegmentIndex == 0)
        {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            var information = storyBoard.instantiateViewControllerWithIdentifier("information") as! infoViewController
            
            information.totalImages = images
            
            information.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)
            self.containerView.addSubview(information.view)
            self.addChildViewController(information)
            information.name.text = name
            information.website.text = website
            if (Description == "") {
                information.Description.text = "N/A"
            }
            else {
                information.Description.text = Description
            }
            
            information.priceRange.text = priceRange
            if (rooms == nil) {
                information.rooms.text = "N/A"
            }
            else {
                information.rooms.text = rooms
            }
            if (parkingCapacity == nil) {
                information.parkingCapacity.text = "N/A"
            }
            else {
                information.parkingCapacity.text = parkingCapacity
            }
            if (coverdArea == nil) {
                information.coverdArea.text = "N/A"
            }
            else {
                information.coverdArea.text = coverdArea
            }
            if (propertyCapacity == nil) {
                information.propertyCapacity.text = "N/A"
            }
            else {
                information.propertyCapacity.text = propertyCapacity
            }
            
            information.venueType.text = venueType
            
            if (perPlate == "0.0") {
                information.perPlate.text = "N/A"
            }
            else {
                information.perPlate.text = perPlate
            }
            information.didMoveToParentViewController(self)
            
        }
        else if(segmentControl.selectedSegmentIndex == 1)
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            var location = storyBoard.instantiateViewControllerWithIdentifier("locationView") as! locationViewController
            location.lat = lat
            location.lng = long
            location.markerTitle = name
            location.markerSubTitle = venueType
            location.view.frame = self.containerView.bounds
            self.containerView.addSubview(location.view)
            self.addChildViewController(location)
            
            location.address.text = address
            location.area.text = area
            location.city.text = city
            location.state.text = state
            location.zipcode.text = zipcode
            
            location.didMoveToParentViewController(self)
            
        }
        

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if(item.tag == 0) {
            if(phone != nil) {
                UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + phone)!)
            }
            else {
                let alert = UIAlertView()
                alert.title = "Sorry!"
                alert.message = "Phone number is not available for this business"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
        else if(item.tag == 1) {
            if( email != nil) {
                 UIApplication.sharedApplication().openURL(NSURL(string: "mailto://" + email)!)
            }
            else {
                let alert = UIAlertView()
                alert.title = "Sorry!"
                alert.message = "Email is not available for this business"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
        else {
            println("tab bar")
        }
    }
    
    @IBAction func segmentControlAction(sender: AnyObject) {
        
        if(segmentControl.selectedSegmentIndex == 0)
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            var information = storyBoard.instantiateViewControllerWithIdentifier("information") as! infoViewController
            information.totalImages = images
            information.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)
            self.containerView.addSubview(information.view)
            self.addChildViewController(information)
            information.name.text = name
            information.website.text = website
            
            if (Description == "") {
               information.Description.text = "N/A"
            }
            else {
              information.Description.text = Description
            }
            
            information.priceRange.text = priceRange
            
            if (rooms == nil) {
                information.rooms.text = "N/A"
            }
            else {
                information.rooms.text = rooms
            }
            
            if (parkingCapacity == nil) {
                information.parkingCapacity.text = "N/A"
            }
            else {
               information.parkingCapacity.text = parkingCapacity
            }
            
            if (coverdArea == nil) {
                information.coverdArea.text = "N/A"
            }
            else {
                information.coverdArea.text = coverdArea
            }
            
            if (propertyCapacity == nil) {
               information.propertyCapacity.text = "N/A"
            }
            else {
               information.propertyCapacity.text = propertyCapacity
            }
            
            information.venueType.text = venueType
            
            if (perPlate == "0.0") {
                information.perPlate.text = "N/A"
            }
            else {
                information.perPlate.text = perPlate
            }
            information.didMoveToParentViewController(self)
            
        }
        else if(segmentControl.selectedSegmentIndex == 1)
        {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            var location = storyBoard.instantiateViewControllerWithIdentifier("locationView") as! locationViewController
            location.lat = lat
            location.lng = long
            location.markerTitle = name
            location.markerSubTitle = venueType
            location.view.frame = self.containerView.bounds
            self.containerView.addSubview(location.view)
            self.addChildViewController(location)
            
            location.address.text = address
            location.area.text = area
            location.city.text = city
            location.state.text = state
            location.zipcode.text = zipcode

            location.didMoveToParentViewController(self)
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
