//
//  addPropertyAreaViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 2/18/16.
//  Copyright (c) 2016 Pradeep Chauhan. All rights reserved.
//

import UIKit

class addPropertyAreaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCity = ""
    var selectedArea:NSMutableArray = NSMutableArray()
    var areaList:NSMutableArray = NSMutableArray()
    var searchResult:NSMutableArray = NSMutableArray()
    var is_searching = false
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        searchBar.becomeFirstResponder()
        //areaList = appDelegate.areaArrayListAppDelegate
        self.navigationItem.title = "Select Area"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = appDelegate.mainColor
        self.navigationItem.setHidesBackButton(true, animated: false)
        
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
    
    func backButtonPressed() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    func doneButtonPressed () {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (is_searching == true) {
            return searchResult.count
        }
        else {
            return areaList.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        if(is_searching == true) {
            cell.textLabel?.text = searchResult[indexPath.row]["name"] as! NSString as String
        }
        else {
            cell.textLabel?.text = areaList[indexPath.row]["name"] as! NSString as String
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedArea.removeAllObjects()
        var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        selectedArea.insertObject(areaList[indexPath.row], atIndex: 0)
        doneAreaSelection()
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if ( searchBar.text.isEmpty ) {
            is_searching = false
            tableView.reloadData()
        }
        else {
            is_searching = true
            searchResult.removeAllObjects()
            var resultPredicate = NSPredicate(format: "name contains[c] %@", searchText)
            var temporaryArray: NSArray = areaList.filteredArrayUsingPredicate(resultPredicate) as NSArray
            searchResult = temporaryArray.mutableCopy() as! NSMutableArray
            tableView.reloadData()
        }
    }
    
    
    func doneAreaSelection () {
        appDelegate.addEditPropertySelectedArea = []
        appDelegate.addEditPropertySelectedArea = selectedArea
        self.navigationController?.popViewControllerAnimated(true)
        
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
