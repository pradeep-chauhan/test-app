//
//  AppDelegate.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 8/4/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Alamofire
import IQKeyboardManagerSwift

var reachability: Reachability?
var reachabilityStatus = ""

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var venueArrayListAppDelegate:NSMutableArray = NSMutableArray()
    var priceArrayListAppDelegate:NSMutableArray = NSMutableArray()
    var areaArrayListAppDelegate:NSMutableArray = NSMutableArray()
    var rangeArrayListAppDelegate:NSMutableArray = NSMutableArray()
    var loginDetails:NSMutableArray = NSMutableArray()
    var propertyDetails : NSMutableArray = NSMutableArray()
    var selectedArea:NSMutableArray = NSMutableArray()
    var availableAreaList:NSMutableArray = NSMutableArray()
    var addEditPropertySelectedArea:NSMutableArray = NSMutableArray()
    var addNewPropertyArray:NSMutableArray = NSMutableArray()
    var cityArrayListNamesAppDelegate:NSMutableArray = NSMutableArray()
    var setSegmentControl:Int = 0
    var connection = false
    var firstTimeLogin = false
    var scrollStatusOnFirstTime = false
    var selectedProprtyCreatedDate:NSDate!
    // already login
    var propertyListArray:NSArray = NSArray()
    var propertyArray:NSMutableArray = NSMutableArray()
    
    var selectedCity = ""
    var selectedState = ""
    
    var internetCheck: Reachability?
    
    var window: UIWindow?
    var mainColor: UIColor = UIColor(red: 210.0/255.0, green: 63.0/255.0, blue: 49.0/255.0, alpha: 1)
    var cellLoad = false
    var addPropertyMode = false
    var networkErrorUIView: networkErrorView!
    var listPropertySelectedFlag = false
    
    var reload:Bool = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //var connection = checkConnection()
        IQKeyboardManager.sharedManager().enable = true
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkActiveInternetConnection:"), name: kReachabilityChangedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("logout"), name: "logout", object: nil)
        networkErrorUIView = NSBundle.mainBundle().loadNibNamed("NetworkErrorView", owner: self, options: nil).first as! networkErrorView
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "CircularAir-Book", size: 18)!,NSForegroundColorAttributeName:UIColor.whiteColor()]
//        UILabel.appearance().font = UIFont(name: "OpenSans", size: 16)
        
        internetCheck = Reachability.reachabilityForInternetConnection()
        internetCheck?.startNotifier()
        showFirstController()
        statusChangedWithReachability(internetCheck!)
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func statusChangedWithReachability(reachability: Reachability) {
        let networkStatus: NetworkStatus = reachability.currentReachabilityStatus()
        
        switch networkStatus.value {
        case NotReachable.value: reachabilityStatus = NOACCESS
        case ReachableViaWiFi.value: reachabilityStatus = WIFI
        case ReachableViaWWAN.value: reachabilityStatus = WWAN
        default: return
        }
        
        // Post a Notification
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_REACHABILITY_STATUS_CHANGED, object: nil)
    }
    
    func showFirstController () -> Void {
        
        var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("remember_token") == nil || NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString as String == "") {
            
            let mfSideMenuContainer = mainStoryBoard.instantiateViewControllerWithIdentifier("MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
            let leftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideMenuViewController") as! LeftSideMenuViewController
            let centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("navigationStart") as! UINavigationController
            self.window?.rootViewController = mfSideMenuContainer
            mfSideMenuContainer.leftMenuViewController = leftViewController
            mfSideMenuContainer.centerViewController = centerViewController
            self.window?.makeKeyAndVisible()
            //MBProgressHUD.hideAllHUDsForView(self.window, animated: true)
            
        }
        else {
            
            let mfSideMenuContainer = mainStoryBoard.instantiateViewControllerWithIdentifier("MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
            let leftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ListPropertyViewController") as! ListPropertyViewController
            let centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("dashNav") as! UINavigationController
            self.window?.rootViewController = mfSideMenuContainer
            mfSideMenuContainer.leftMenuViewController = leftViewController
            mfSideMenuContainer.centerViewController = centerViewController
            self.window?.makeKeyAndVisible()
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        showFirstController()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
    
    }
    
//    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        
//    }
    
    func logout () {
        
        self.firstTimeLogin = false
        
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "email")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "archive")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "created_at")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "encrypted_password")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "id")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "remember_token")
        //NSUserDefaults.standardUserDefaults().setObject(tempDict.valueForKey("device_token") as! NSString, forKey: "device_token")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "updated_at")
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mfSideMenuContainer = mainStoryBoard.instantiateViewControllerWithIdentifier("MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        let leftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideMenuViewController") as! LeftSideMenuViewController
        let centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("navigationStart") as! UINavigationController
        self.window?.rootViewController = mfSideMenuContainer
        mfSideMenuContainer.leftMenuViewController = leftViewController
        mfSideMenuContainer.centerViewController = centerViewController
        
    }
    
    func showControllerView ( identifier:String) {
        var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mfSideMenuContainer = mainStoryBoard.instantiateViewControllerWithIdentifier("MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        let leftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideMenuViewController") as! LeftSideMenuViewController
        let centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier(identifier) as! UINavigationController
        self.window?.rootViewController = mfSideMenuContainer
        mfSideMenuContainer.leftMenuViewController = leftViewController
        mfSideMenuContainer.centerViewController = centerViewController
    }
    
    func checkConnection ()-> Bool {
        let status = Reach.connectionStatus()
        switch status {
        case .Unknown, .Offline:
            connection = false
        case .Online(.WWAN):
            connection = true
        case .Online(.WiFi):
            connection = true
        }
        return connection
    }
    
    func showNetworkErrorView() {
        
        self.window!.addSubview(networkErrorUIView)
        self.networkErrorUIView.frame = CGRect(x: 0.0, y: 0.0, width: self.window!.frame.width, height: self.window!.frame.height)
        self.networkErrorUIView.retry.backgroundColor = mainColor
        self.networkErrorUIView.lookVenueLabel.textColor = mainColor
        self.networkErrorUIView.retry.addTarget(self, action: "retryButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        window!.makeKeyAndVisible()
        
    }
    
    func checkActiveInternetConnection(notification: NSNotification) {
//        var rootHostStatus = self.reachability?.currentReachabilityStatus()
//        if (rootHostStatus?.value == NotReachable.value) {
//            self.window!.addSubview(networkErrorUIView)
//            self.networkErrorUIView.frame = CGRect(x: 0.0, y: 0.0, width: self.window!.frame.width, height: self.window!.frame.height)
//            self.networkErrorUIView.retry.backgroundColor = mainColor
//            self.networkErrorUIView.lookVenueLabel.textColor = mainColor
//            self.networkErrorUIView.retry.addTarget(self, action: "retryButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
//             MBProgressHUD.hideAllHUDsForView(self.window, animated: true)
//            window!.makeKeyAndVisible()
//        }
//        else {
//            //Alamofire.Manager.sharedInstance.session.invalidateAndCancel()
//            self.networkErrorUIView.removeFromSuperview()
//            MBProgressHUD.hideAllHUDsForView(self.window, animated: true)
//            window!.makeKeyAndVisible()
//        }
        
        reachability = notification.object as? Reachability
        statusChangedWithReachability(reachability!)

        
    }
    
    func retryButtonAction () {
        var connection = checkConnection()
        
        if(connection == true) {
             MBProgressHUD.hideAllHUDsForView(self.window, animated: true)
            self.networkErrorUIView.removeFromSuperview()
        }
    }
    
    func getPropertyArray() -> Void
    {
        propertyArray = propertyListArray as! NSMutableArray
        NSNotificationCenter.defaultCenter().postNotificationName("updatePropertyList", object: nil)
        
    }
    
    func appDelegateNetworkCheck () {
        self.window!.addSubview(networkErrorUIView)
        self.networkErrorUIView.frame = CGRect(x: 0.0, y: 0.0, width: self.window!.frame.width, height: self.window!.frame.height)
        self.networkErrorUIView.retry.backgroundColor = mainColor
        self.networkErrorUIView.lookVenueLabel.textColor = mainColor
        self.networkErrorUIView.retry.addTarget(self, action: "appDelegateRetryButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        MBProgressHUD.hideAllHUDsForView(self.window, animated: true)
        window!.makeKeyAndVisible()
    }
    
    func appDelegateRetryButtonAction () {
        var connection = checkConnection()
        
        if(connection == true) {
            var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let mfSideMenuContainer = mainStoryBoard.instantiateViewControllerWithIdentifier("MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
            let leftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideMenuViewController") as! LeftSideMenuViewController
            let centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("navigationStart") as! UINavigationController
            self.window?.rootViewController = mfSideMenuContainer
            mfSideMenuContainer.leftMenuViewController = leftViewController
            mfSideMenuContainer.centerViewController = centerViewController
        }
    }

}

