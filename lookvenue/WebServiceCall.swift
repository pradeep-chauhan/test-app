    //
//  WebServiceCall.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 8/27/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit
import Alamofire

class WebServiceCall: NSObject {
    
    var login:loginDetails = loginDetails()
    let loadingProcess:MBProgressHUD = MBProgressHUD()
    var authentication = ""
    var cookies = ""
    var contentType = ""
    var window = UIApplication.sharedApplication().delegate!.window
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    // user api call
    
    // search property api call 
    
    
    func searchPropertyApiCallRequest(methodType: String, urlRequest: String, param:Dictionary < String, AnyObject >, completion: (resultData : NSData?, error:String) -> ()) -> Void
    {
        var baseUrl: String! = "http://lookvenue.herokuapp.com/"
        var method: String! = methodType
        var parameter: String! = urlRequest
        
        var url: String = baseUrl + parameter.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
//        var alamoFireManager = Alamofire.Manager.sharedInstance
//        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        configuration.timeoutIntervalForRequest = 1 // seconds
//        configuration.timeoutIntervalForResource = 1
//        alamoFireManager = Alamofire.Manager(configuration: configuration)
        
        Alamofire.request(.GET, url)
            .validate()
            .response { request, response, data, error in
                
                if(error != nil) {
                    completion(resultData: data!, error: "\(error?.localizedDescription)")
                }
                else {
                    completion(resultData: data!, error: "")
                }
            }
            
    
    }
    
    
    
    // Simple web calling function
    
    func apiCallRequest(methodType: String, urlRequest: String, param:Dictionary < String, AnyObject >, completion: (resultData : NSData?, response:NSHTTPURLResponse) -> ()) -> Void
    {
        var baseUrl: String! = "http://lookvenue.herokuapp.com/"
        var method: String! = methodType
        var parameter: String! = urlRequest
        var url: String = baseUrl + parameter
        
        if( method == "GET") {
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let manager = Alamofire.Manager(configuration: configuration)
                Alamofire.request(.GET, url)
                    .validate()
                    .response { request, response, data, error in
                        
                        if(error != nil) {
                            if (response?.statusCode == 422 || response?.statusCode == 401) {
                                completion(resultData: data!, response: response!)
                            }
                            else {
                                self.loadingProcess.detailsLabelText = "\(error?.localizedDescription)"
                                self.loadingProcess.hide(true, afterDelay: 2)
                                MBProgressHUD.hideAllHUDsForView(self.window!, animated: true)
                            }
                        }
                        else {
                            
                            completion(resultData: data!, response: response!)
                        }
                    }
            
           
        }
        
        else if (method == "upload") {
            let fileURL = NSBundle.mainBundle().URLForResource("Default", withExtension: "png")
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let manager = Alamofire.Manager(configuration: configuration)
            Alamofire.upload(.POST, url, file: fileURL!)
                .validate()
                .response { request, response, data, error in
                    if(error != nil) {
                        if (response?.statusCode == 422) {
                            completion(resultData: data!, response: response!)
                        }
                        else {
                            self.loadingProcess.detailsLabelText = "\(error?.localizedDescription)"
                            self.loadingProcess.hide(true, afterDelay: 2)
                            MBProgressHUD.hideAllHUDsForView(self.window!, animated: true)
                        }

                    }
                    else {
                        completion(resultData: data!, response: response!)
                    }
            }
            
        }
            
        else {
//            var jsonData = NSJSONSerialization.dataWithJSONObject(param, options: nil, error: nil)
//            let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)! as String
//            println(jsonString)
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let manager = Alamofire.Manager(configuration: configuration)
            Alamofire.request(.POST, url, parameters: param, encoding: .JSON)
                .validate()
                .responseJSON { request, response, data, error in
                    if(error != nil) {
                        if (response?.statusCode == 422) {
                             let resultString : NSData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                            completion(resultData: resultString, response: response!)
                        }
                        else {
                            self.loadingProcess.detailsLabelText = "\(error?.localizedDescription)"
                            self.loadingProcess.hide(true, afterDelay: 2)
                            MBProgressHUD.hideAllHUDsForView(self.window!, animated: true)
                        }
                        
                    }
                    else {
                        let resultString : NSData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                        completion(resultData: resultString, response: response!)
                    }
                    //MBProgressHUD.hideAllHUDsForView(self.window!, animated: true)
                }
            
            }
        }
    
    // admin function call
    
    func adminApiCallRequest(methodType: String, urlRequest: String, param: Dictionary < String, AnyObject > , authentication: String , completion: (resultData : NSData?, response:NSHTTPURLResponse) -> ()) -> Void
    {
        var baseUrl: String! = "http://lookvenue.herokuapp.com/"
        var method: String! = methodType
        //var parameter: NSArray = param
        var url: String = baseUrl + urlRequest
        
        var authentication:String = authentication
        let headers = [
            "Authorization": "\(authentication)",
            "Cookie": "remember_token=\(authentication)",
            "Content-Type": "application/json"
        ]
        
        //println(headers)
        
        if( method == "GET") {
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let manager = Alamofire.Manager(configuration: configuration)
                Alamofire.request(.GET, url, headers: headers)
                    .validate()
                    .response { request, response, data, error in
//                        println(data)
                        if(error != nil) {
                            if (response?.statusCode == 422) {
                                completion(resultData: data!, response: response!)
                            }
                            else {
                                self.loadingProcess.detailsLabelText = "\(error?.localizedDescription)"
                                self.loadingProcess.hide(true, afterDelay: 2)
                                MBProgressHUD.hideAllHUDsForView(self.window!, animated: true)
                            }
                        }
                        else {
                            completion(resultData: data!, response: response!)
                        }
                        
                    }
            
            
            }
        else if (method == "PUT") {
            
//            var jsonData = NSJSONSerialization.dataWithJSONObject(param, options: nil, error: nil)
//            let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)! as String
//            println(jsonString)
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let manager = Alamofire.Manager(configuration: configuration)
            Alamofire.request(.PUT, url, parameters: param, encoding: .JSON, headers: headers)
                .validate()
                .response { request, response, data, error in
//                        let resultString : NSData = NSKeyedArchiver.archivedDataWithRootObject(data!)
//                        completion(resultData: resultString)
//                    println(response)
//                    println(data)
                    if(error != nil) {
                        if (response?.statusCode == 422) {
                            completion(resultData: data!, response: response!)
                        }
                        else {
                            self.loadingProcess.detailsLabelText = "\(error?.localizedDescription)"
                            self.loadingProcess.hide(true, afterDelay: 2)
                            MBProgressHUD.hideAllHUDsForView(self.window!, animated: true)
                        }
                        
                    }
                    else {
                        completion(resultData: data!, response: response!)
                    }
                   //MBProgressHUD.hideAllHUDsForView(self.window!, animated: true)
                }
        }
        else {
            
//            var jsonData = NSJSONSerialization.dataWithJSONObject(param, options: nil, error: nil)
//            let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)! as String
//            println(jsonString)
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let manager = Alamofire.Manager(configuration: configuration)
            Alamofire.request(.POST, url, parameters: param, encoding: .JSON, headers: headers)
                .validate()
                .responseJSON { request, response, data, error in
                    
                    if(error != nil) {
                        
                        var connection = self.appDelegate.checkConnection()
//                        if (connection == true) {
//                            
//                            let resultString : NSData = NSKeyedArchiver.archivedDataWithRootObject(data!)
//                            completion(resultData: resultString, response: response!)
//                            
//                        }
//                        else {
//                            self.appDelegate.showNetworkErrorView()
//                        }
                        if (response?.statusCode == 422) {
                            let resultString : NSData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                            completion(resultData: resultString, response: response!)
                        }
                        else {
                            self.loadingProcess.detailsLabelText = "\(error?.localizedDescription)"
                            self.loadingProcess.hide(true, afterDelay: 2)
                            MBProgressHUD.hideAllHUDsForView(self.window!, animated: true)
                        }
                        
                    }
                    else {
                        let resultString : NSData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                        completion(resultData: resultString, response: response!)
                    }
                    
                }
            
        }
    }
    
    
    // Image uploading
    
    func imageUploadingResult(data : NSData) -> NSString {
        var error : NSError?
        //var imageUploadingResultArray : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSDictionary
        let tempDict:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data)! as! NSDictionary
        var result : NSString = NSString()
        result = tempDict.valueForKey("message") as! NSString
        return result
    }
    
    // Calendar booking
    
//    func bookingResult(data : NSData) -> NSString {
//        var error : NSError?
//        //var imageUploadingResultArray : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSDictionary
//        let tempDict:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data)! as! NSDictionary
//        var result : NSString = NSString()
//        result = tempDict.valueForKey("status") as! NSString
//        return result
//    }
    
    // Sign up
    
    func signUpResult(data : NSData) -> NSArray {
        var error : NSError?
//        var tempDict : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSDictionary
        let tempDict:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data)! as! NSDictionary
        var result : NSMutableArray = NSMutableArray()
        var tempResult:NSDictionary = tempDict as NSDictionary
        result.addObject(tempResult)
        if let val: AnyObject = tempResult["errors"] {
            //result = result.valueForKey("error") as! NSMutableArray
            return result
        }
        else {
            NSUserDefaults.standardUserDefaults().setObject(tempResult.valueForKey("email") as! NSString, forKey: "email")
            NSUserDefaults.standardUserDefaults().setObject(tempResult.valueForKey("archive") as! NSInteger, forKey: "archive")
            NSUserDefaults.standardUserDefaults().setObject(tempResult.valueForKey("created_at") as! NSString, forKey: "created_at")
            NSUserDefaults.standardUserDefaults().setObject(tempResult.valueForKey("encrypted_password") as! NSString, forKey: "encrypted_password")
            NSUserDefaults.standardUserDefaults().setObject(tempResult.valueForKey("id") as! NSNumber, forKey: "id")
            NSUserDefaults.standardUserDefaults().setObject(tempResult.valueForKey("remember_token") as! NSString, forKey: "remember_token")
            //NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("device_token") as! NSString, forKey: "device_token")
            NSUserDefaults.standardUserDefaults().setObject(tempResult.valueForKey("updated_at") as! NSString, forKey: "updated_at")
            //NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("name") as! NSString, forKey: "name")
            
            var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString
            NSUserDefaults.standardUserDefaults().synchronize()
            return result
        }
        
        
    }
    
    // Get area list
    
    func getAreaArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var areaListArray : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSArray
        var areaArray : NSMutableArray = NSMutableArray()
        for(var i = 0; i < areaListArray.count; i++)
        {
            var area : Area = Area()
            var tempDict : NSDictionary = areaListArray[i] as! NSDictionary
            areaArray.addObject(tempDict)
        }
        NSUserDefaults.standardUserDefaults().setObject(areaArray, forKey: "areaList")
        NSUserDefaults.standardUserDefaults().synchronize()
        return areaArray
    }
    
    // Get city list
    
    func getCityArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var cityListArray : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSArray
        var cityArray : NSMutableArray = NSMutableArray()
        for(var i = 0; i < cityListArray.count; i++)
        {
            var tempDict : NSDictionary = cityListArray[i] as! NSDictionary
            cityArray.addObject(tempDict)
        }
        NSUserDefaults.standardUserDefaults().setObject(cityArray, forKey: "cityList")
        NSUserDefaults.standardUserDefaults().synchronize()
        return cityArray
    }
    
    // Get city name list
    
    func getCityNamesArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var cityListArray : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSArray
        var cityArray : NSMutableArray = NSMutableArray()
        for(var i = 0; i < cityListArray.count; i++)
        {
            //var tempDict : NSDictionary = cityListArray[i] as! NSDictionary
            cityArray.addObject(cityListArray[i])
        }
        appDelegate.cityArrayListNamesAppDelegate = cityArray
        return cityArray
    }
    
    // Get state list
    
    func getStateArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var stateListArray : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSArray
        var stateArray : NSMutableArray = NSMutableArray()
        for(var i = 0; i < stateListArray.count; i++)
        {
            var tempDict : NSDictionary = stateListArray[i] as! NSDictionary
            stateArray.addObject(tempDict)
        }
        NSUserDefaults.standardUserDefaults().setObject(stateArray, forKey: "stateList")
        NSUserDefaults.standardUserDefaults().synchronize()
        return stateArray
    }
    
    // Get venue type
    
    func getVanueArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var venueListArray : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSArray
        var vanueArray : NSMutableArray = NSMutableArray()
        for(var i = 0; i < venueListArray.count; i++)
        {
            var venue : Venue = Venue()
            var tempDict : NSDictionary = venueListArray[i] as! NSDictionary
            
            vanueArray.addObject(tempDict)
            //vanueArray.addObject(tempDict.valueForKey("name")!)
        }
        NSUserDefaults.standardUserDefaults().setObject(vanueArray, forKey: "venueList")
        NSUserDefaults.standardUserDefaults().synchronize()
        return vanueArray
    }
    
    // Get price ranhe
    
    func getPriceArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var priceListArray : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSArray
        var priceArray : NSMutableArray = NSMutableArray()
        for(var i = 0; i < priceListArray.count; i++)
        {
            var price : Price = Price()
            var tempDict : NSDictionary = priceListArray[i] as! NSDictionary
            
            priceArray.addObject(tempDict)
            //priceArray.addObject(tempDict.valueForKey("id")!)
        }
        NSUserDefaults.standardUserDefaults().setObject(priceArray, forKey: "priceList")
        NSUserDefaults.standardUserDefaults().synchronize()
        return priceArray
    }
    
    
    // Get range
    
    func getRangeArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var rangeListArray : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSDictionary
        var rangeArray : NSMutableArray = NSMutableArray()
        var tempDict : NSDictionary = rangeListArray as NSDictionary
        
        rangeArray.addObject(tempDict)
        
        return rangeArray
    }
    
    func getSearchVenueArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var searchVenueListArray : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSArray
        var searchVenueArray : NSMutableArray = NSMutableArray()
        for(var i = 0; i < searchVenueListArray.count; i++)
        {
            var searchVenue : SearchVenue = SearchVenue()
            var tempDict : NSDictionary = searchVenueListArray[i] as! NSDictionary
            var images : NSArray = tempDict.objectForKey("images") as! NSArray
            //println(tempDict)
            searchVenue.images = images
            //            venue.name = (tempDict.valueForKey("name")!)
            
            searchVenueArray.addObject(tempDict)
            //priceArray.addObject(tempDict.valueForKey("id")!)
        }
        //println(searchVenueArray)
        return searchVenueArray
    }
    
    // Get Login Details
    
    func getLoginDetailsArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var loginDetailsListArray : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSDictionary
        var loginDetailsArray : NSMutableArray = NSMutableArray()
        var login : loginDetails = loginDetails()
        
        var tempDict : NSDictionary = loginDetailsListArray as NSDictionary
        
        login.archive = String((tempDict.valueForKey("archive") as! NSInteger))
        login.created_at = tempDict.valueForKey("created_at") as! NSString
        //login.device_token = tempDict.valueForKey("device_token") as! NSString
        login.email = tempDict.valueForKey("email") as! NSString
        login.encrypted_password = tempDict.valueForKey("encrypted_password") as! NSString
        login.id = String(tempDict.valueForKey("id") as! NSInteger)
        //login.name = tempDict.valueForKey("name") as! NSString
        login.remember_token = tempDict.valueForKey("remember_token") as! NSString
        login.updated_at = tempDict.valueForKey("updated_at") as! NSString
          
        loginDetailsArray.addObject(tempDict)
        
        // Session
        
        NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("email") as! NSString, forKey: "email")
        NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("archive") as! NSInteger, forKey: "archive")
        NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("created_at") as! NSString, forKey: "created_at")
        NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("encrypted_password") as! NSString, forKey: "encrypted_password")
        NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("id") as! NSNumber, forKey: "id")
        NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("remember_token") as! NSString, forKey: "remember_token")
        //NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("device_token") as! NSString, forKey: "device_token")
        NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("updated_at") as! NSString, forKey: "updated_at")
        //NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("name") as! NSString, forKey: "name")
        
        var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString
        //NSUserDefaults.standardUserDefaults().setObject(loginDetailsArray as NSArray, forKey: "loginDetails")
        NSUserDefaults.standardUserDefaults().synchronize()
        return loginDetailsArray
    }
    
    // Get Property Details
    
    func getPropertyDetailsArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var propertyDetailsListArray : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSArray
        var propertyDetailsArray : NSMutableArray = NSMutableArray()
        for(var i = 0; i < propertyDetailsListArray.count; i++)
        {
            
        //var login : loginDetails = loginDetails()
        var tempDict : NSDictionary = propertyDetailsListArray[i] as! NSDictionary
        //println(tempDict)
        
        propertyDetailsArray.addObject(tempDict)
            
        }
        var a:NSArray = propertyDetailsArray as AnyObject as! NSArray
        //NSUserDefaults.standardUserDefaults().setObject(a, forKey: "propertyDetails")
        NSUserDefaults.standardUserDefaults().synchronize()
        return propertyDetailsArray
    }
    
    //Edit property details
    
    func getEditPropertyArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var editPropertyListArray : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSDictionary
//        let editPropertyListArray:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data)! as! NSDictionary
        var editPropertyArray : NSMutableArray = NSMutableArray()
        
            var EditProperty : editProperty = editProperty()
            var tempDict : NSDictionary = editPropertyListArray as NSDictionary
//            var images : NSArray = tempDict.objectForKey("images") as! NSArray
            //println(tempDict)
//            EditProperty.images = images
            //            venue.name = (tempDict.valueForKey("name")!)
            
            editPropertyArray.addObject(tempDict)
            //priceArray.addObject(tempDict.valueForKey("id")!)
        
        //println(searchVenueArray)
        return editPropertyArray
    }
    
    func getAddEditPropertyArray(data : NSData) -> NSArray
    {
        var error : NSError?
//        var editPropertyListArray : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSDictionary
        var editPropertyListArray:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data)! as! NSDictionary
        var editPropertyArray : NSMutableArray = NSMutableArray()
        
        var EditProperty : editProperty = editProperty()
        var tempDict : NSDictionary = editPropertyListArray as NSDictionary
        
        var images : NSArray = tempDict.objectForKey("images") as! NSArray
        //println(tempDict)
        EditProperty.images = images
        //            venue.name = (tempDict.valueForKey("name")!)
        
        editPropertyArray.addObject(tempDict)
        //priceArray.addObject(tempDict.valueForKey("id")!)
        
        //println(searchVenueArray)
        return editPropertyArray
    }
    
    // Get calendar details
    
    func getCalendarDetailsArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var calendarDetailsListArray : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSArray
        var calendarDetailsArray : NSMutableArray = NSMutableArray()
        
        //var EditProperty : editProperty = editProperty()
        for(var i = 0; i < calendarDetailsListArray.count; i++)
        {
            
            //var login : loginDetails = loginDetails()
            var tempDict : NSDictionary = calendarDetailsListArray[i] as! NSDictionary
            
            calendarDetailsArray.addObject(tempDict)
            
        }
        return calendarDetailsArray
    }
    
    
    // consolidated view for property
    
    func getCheckAvailabilityArray(data : NSData) -> NSArray
    {
        var error : NSError?
        var checkAvailabilityListArray : NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSArray
        var checkAvailabilityArray : NSMutableArray = NSMutableArray()
        
        //var EditProperty : editProperty = editProperty()
        for(var i = 0; i < checkAvailabilityListArray.count; i++)
        {
            
            //var login : loginDetails = loginDetails()
            var tempDict : NSDictionary = checkAvailabilityListArray[i] as! NSDictionary
            
            checkAvailabilityArray.addObject(tempDict)
            
        }
        return checkAvailabilityArray
    }
    
    // Add property details
    
    // Booking details
    
    func addPropertyDetails(data : NSData) -> NSArray {
        var error : NSError?
        let tempDict:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data)! as! NSDictionary
        var result : NSMutableArray = NSMutableArray()
        var tempResult:NSDictionary = tempDict as NSDictionary
        result.addObject(tempResult)
        return result
    }
    

}
