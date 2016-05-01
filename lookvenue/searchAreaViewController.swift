//
//  searchAreaViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 2/14/16.
//  Copyright (c) 2016 Pradeep Chauhan. All rights reserved.
//

import UIKit

class searchAreaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchTableContent: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedArea:NSMutableArray = NSMutableArray()
    var areaList:NSMutableArray = NSMutableArray()
    var searchResult:NSMutableArray = NSMutableArray()
    var availableAreaList:NSMutableArray = NSMutableArray()
    
    var is_searching:Bool = false   // It's flag for searching
    var searchDetails:SearchDetails = SearchDetails()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var searchDetailsModel:SearchDetails = SearchDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.placeholder = "search area..."
        searchBar.becomeFirstResponder()
        self.searchTableContent.tableFooterView = UIView(frame: CGRectZero)
    
        if (self.appDelegate.availableAreaList.count > 0) {
            self.availableAreaList.addObjectsFromArray(self.appDelegate.availableAreaList as [AnyObject])
        }
        else {
            self.availableAreaList.addObjectsFromArray(areaList as [AnyObject])
        }
        
        searchBar(searchBar, textDidChange: "")
        //self.selectedArea.addObjectsFromArray(appDelegate.selectedArea as [AnyObject])
        
        self.navigationItem.title = "Select Area"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "DoneNavButton")
        selectedArea = appDelegate.selectedArea
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
//        if ( is_searching == false) {
//            let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
//            tapGesture.cancelsTouchesInView = true
//            self.searchTableContent.addGestureRecognizer(tapGesture)
//        }
    }
    
    func hideKeyboard () {
        view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if( is_searching == true ) {
            return searchResult.count
        }
        else {
            return selectedArea.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = searchTableContent.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        var image: UIImage = UIImage(named: "cancel.png")!
        var button: UIButton = UIButton.buttonWithType(.Custom) as! UIButton
        var frame: CGRect = CGRectMake(0.0, 0.0, 30.0, 30.0)
        button.frame = frame
        button.setBackgroundImage(image, forState: .Normal)
        button.tag = indexPath.row
        button.addTarget(self, action: "deleteSelectedArea:", forControlEvents: .TouchUpInside)
        button.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        if(is_searching == true) {
            cell.textLabel?.text = searchResult[indexPath.row]["name"] as! NSString as String
            cell.accessoryView?.hidden = true
            
        }
        else {
            cell.textLabel?.text = selectedArea[indexPath.row]["name"] as! NSString as String
        
            cell.accessoryView = button
            
        }
        return cell
    }
    
    // Deleting selected area
    
    func deleteSelectedArea (sender:UIButton) {
        if (is_searching == false) {
            availableAreaList.addObject(selectedArea[sender.tag])
            selectedArea.removeObject(selectedArea[sender.tag])
                // Delete the row from the data source
            //searchTableContent.deleteRowsAtIndexPaths([sender.tag])
            self.searchTableContent.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (is_searching == true) {
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
            selectedArea.addObject(searchResult[indexPath.row])
            availableAreaList.removeObject(searchResult[indexPath.row])
            self.searchBar.text = ""
            is_searching = false
            self.searchBar.resignFirstResponder()
            tableView.reloadData()
            self.searchTableContent.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (is_searching == false) {
            if editingStyle == .Delete {
                availableAreaList.addObject(selectedArea[indexPath.row])
                selectedArea.removeObject(selectedArea[indexPath.row])
                // Delete the row from the data source
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            self.searchTableContent.reloadData()
        }
        
    }
    
    // Search area
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if ( searchBar.text.isEmpty ) {
            is_searching = false
            searchTableContent.reloadData()
        }
        else {
            is_searching = true
            searchResult.removeAllObjects()
            var resultPredicate = NSPredicate(format: "name contains[c] %@", searchText)
            var temporaryArray: NSArray = availableAreaList.filteredArrayUsingPredicate(resultPredicate) as NSArray
            searchResult = temporaryArray.mutableCopy() as! NSMutableArray
            searchTableContent.reloadData()
        }
    }
    
    // Passing selected area to search property
    
    func DoneNavButton () {
        appDelegate.selectedArea = []
        appDelegate.selectedArea.addObjectsFromArray(selectedArea as [AnyObject])
        appDelegate.availableAreaList = availableAreaList
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

