//
//  imagePropertyViewController.swift
//  lookvenue
//
//  Created by Pradeep Chauhan on 8/11/15.
//  Copyright (c) 2015 Pradeep Chauhan. All rights reserved.
//

import UIKit

class imagePropertyViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CLUploaderDelegate {
    
    @IBOutlet var footerTabBar: UIView!
    @IBOutlet weak var tabBar: UIToolbar!
    var totalImages: NSMutableArray = NSMutableArray()
    var totalImagesMutableCopyArray:NSArray = NSArray()
    var displayImagesUrl: NSMutableArray = NSMutableArray()
    var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var selectedSearchVanueDictionary = NSDictionary()
    let cloudinary: CLCloudinary = CLCloudinary()
    var editPropertyArray : NSMutableArray = NSMutableArray()
    var addImages: NSMutableArray = NSMutableArray()
    var deleteImages:NSMutableArray = NSMutableArray()
    var LoginDetails: loginDetails = loginDetails()
    var alert:UIAlertView!
    var statusMode:Bool = true
    var addPropertyId = 0
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var edit: UIBarButtonItem!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = appDelegate.mainColor
        toolbar.tintColor = appDelegate.mainColor
        imagePicker.delegate = self
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        toolbar.hidden = true
        imageCollectionView?.allowsSelection = false
        edit.title = "Edit"
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        var propertySegment: propertyInfoSegmentViewController = storyBoard.instantiateViewControllerWithIdentifier("propertyInfoSegment") as! propertyInfoSegmentViewController
//        propertySegment.segmentControl.hidden = false
//        self.view.reloadInputViews()
        
        if ( editPropertyArray.count == 0 ) {
            editPropertyArray = appDelegate.addNewPropertyArray
        }
        
        if ( appDelegate.addPropertyMode == true ) {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Please create property first"
            self.view.userInteractionEnabled = false
            loadingProgress.hide(true, afterDelay: 2)
//            var property = self.parentViewController as! propertyInfoSegmentViewController
//            self.appDelegate.addNewPropertyArray = self.editPropertyArray
//            property.segmentControl.selectedSegmentIndex = 0
//            property.segmentCall(0);
        }
        else {
            if ( editPropertyArray.count > 0 ) {
                totalImagesMutableCopyArray = editPropertyArray[0]["images"] as! NSArray
                totalImages = totalImagesMutableCopyArray.mutableCopy() as! NSMutableArray
                
                for ( var i = 0; i < totalImages.count; i++ ) {
                    var cloudinary_image_id = totalImages[i]["cloudinary_image_id"] as! NSString as String
                    addImages.addObject(cloudinary_image_id)
                }
            }
                
            else {
                totalImages = []
            }
        }
        
        
        // lookvenue cloudinary account
        
        cloudinary.config().setValue("dtpcuqqq2", forKey: "cloud_name")
        cloudinary.config().setValue("897166688766548", forKey: "api_key")
        cloudinary.config().setValue("HZ3xp9PcVYWyaUaNB8yivz9FX8E", forKey: "api_secret")
        
        
        // my cloudinary account
        
//        cloudinary.config().setValue("dykhnkdyi", forKey: "cloud_name")
//        cloudinary.config().setValue("243966527335567", forKey: "api_key")
//        cloudinary.config().setValue("2cus07IvyULcSWjJ-TaD8zMRneA", forKey: "api_secret")
        
        var transformation: CLTransformation = CLTransformation.transformation() as AnyObject as! CLTransformation
        transformation.setWidthWithInt(100)
        transformation.setHeightWithInt(100)
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return totalImages.count
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var width = ((imageCollectionView.frame.width)/3) - 7
            var height = width
            return CGSize(width: width, height: height)
            
    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! editPropertyImagesCollectionViewCell
        cell.activityController.startAnimating()
        var cloudinary_image_id:String = (totalImages[indexPath.row]["cloudinary_image_id"]) as! NSString as String
        var cloudinaryUrl:String = cloudinary.url(cloudinary_image_id as String)
        var url = NSURL(string: cloudinaryUrl)
        //println(url)
        displayImagesUrl.addObject(url!)
        //println(displayImagesUrl)
        
        cell.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "nophoto.jpg"))
        cell.activityController.stopAnimating()
        return cell
        // Configure the cell+
        
    }
    
    override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    
        if let indexPath = getIndexPathForSelectedCell() {
        
            highlightCell(indexPath, flag: false)
        }
    }
    
    // MARK:- Selected Cell IndexPath
    
    func getIndexPathForSelectedCell() -> NSIndexPath? {
        
        var indexPath:NSIndexPath?
        
        if imageCollectionView.indexPathsForSelectedItems().count > 0 {
            indexPath = imageCollectionView.indexPathsForSelectedItems()[0] as? NSIndexPath
        }
        return indexPath
    }
    
    // MARK:- Editing
    
    @IBAction func addImages(sender: AnyObject) {
        
        var propertySegment = self.parentViewController as! propertyInfoSegmentViewController
        propertySegment.selectedSegmentControll()
        
         let actionSheet = UIAlertController(title: "", message: "Select Image", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let gallery = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.galleryPickerController()
        }
        // Configure a new action to share on Facebook.
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.cameraPickerController()
        }
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        actionSheet.addAction(gallery)
        actionSheet.addAction(camera)
        actionSheet.addAction(dismissAction)
        presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    func cameraPickerController() {
        
        var propertySegment = self.parentViewController as! propertyInfoSegmentViewController
        propertySegment.selectedSegmentControll()
        
        imagePicker.allowsEditing = false
        //imagePicker.sourceType = .PhotoLibrary
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func galleryPickerController() {
        
        var propertySegment = self.parentViewController as! propertyInfoSegmentViewController
        propertySegment.selectedSegmentControll()
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        //imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func editImages(sender: AnyObject) {
        
        if( statusMode == true) {
            
            self.edit.title = "Done"
            self.edit.action = "editImages:"
            setEditing(statusMode, animated: true)
        }
        else {
            self.edit.title = "Edit"
            self.edit.action = "editImages:"
            var unselectAllImages = imageCollectionView?.indexPathsForSelectedItems()
            if let indexPath = unselectAllImages {
                for item in indexPath {
                    var index = NSIndexPath(forItem: item.row, inSection: 0)
                    highlightCell(index, flag: false)
                    
                }
            }
            
            setEditing(statusMode, animated: statusMode)
        }
        
        
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
//        return !editing
//    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if( statusMode == true) {
            
            super.setEditing(editing, animated: animated)
            self.imageCollectionView?.allowsSelection = true
            self.imageCollectionView?.allowsMultipleSelection = statusMode
            toolbar.hidden = !editing
            statusMode = false
        }
        else {
            super.setEditing(editing, animated: animated)
            self.imageCollectionView?.allowsSelection = false
            self.imageCollectionView?.allowsMultipleSelection = false
            
            toolbar.hidden = true
            statusMode = true
            
        }
        
    }
    
    // Delete cell or image from collection view
    
    @IBAction func deleteCell(sender: AnyObject) {
        var selectedIndexPath = imageCollectionView?.indexPathsForSelectedItems()
        
        if (totalImages.count == 1) {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Can't be delete this image"
            loadingProgress.hide(true, afterDelay: 1)
        }
        else if (totalImages.count == selectedIndexPath!.count) {
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingProgress.mode = MBProgressHUDMode.Text
            loadingProgress.detailsLabelText = "Atleast one image should be there"
            loadingProgress.hide(true, afterDelay: 1)
        }
//        else if (totalImages.count > 1 && deleteImages.count ==  0) {
//            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            loadingProgress.detailsLabelText = "Atleast one image should be there"
//            loadingProgress.hide(true, afterDelay: 1)
//        }
        else {
            var propertySegment = self.parentViewController as! propertyInfoSegmentViewController
            propertySegment.changeSegmentStatus(true)
            let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingProgress.labelText = "Deleting"
            loadingProgress.detailsLabelText = "Please wait"
            
            if let indexPath = selectedIndexPath {
                for item in indexPath {
                    let cell = imageCollectionView.cellForItemAtIndexPath(item as! NSIndexPath)
                    imageCollectionView?.deselectItemAtIndexPath(item as? NSIndexPath, animated: true)
                    println(item.row)
                    
                    if (item.row == 0) {
                        var cloudinary_image_id = totalImages[item.row]["cloudinary_image_id"] as! NSString as String
                        var delete_key = ["cloudinary_image_id":"\(cloudinary_image_id)"]
                        deleteImages.addObject(cloudinary_image_id)
                        totalImages.removeObjectAtIndex(item.row)
                    }
                    else {
                        var cloudinary_image_id = totalImages[item.row - 1]["cloudinary_image_id"] as! NSString as String
                        var delete_key = ["cloudinary_image_id":"\(cloudinary_image_id)"]
                        deleteImages.addObject(cloudinary_image_id)
                        totalImages.removeObjectAtIndex(item.row - 1)
                    }
                    
                    
                    highlightCell(item as! NSIndexPath, flag: false)
                }
                imageCollectionView?.deleteItemsAtIndexPaths(indexPath)
                updateImagesToserver()
            }
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        highlightCell(indexPath, flag: true)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
         highlightCell(indexPath, flag: false)
    }
    
    // MARK:- Highlight
    func highlightCell(indexPath : NSIndexPath, flag: Bool) {
        
        let cell = imageCollectionView.cellForItemAtIndexPath(indexPath)
        
        if flag {
            cell?.contentView.backgroundColor = UIColor.blueColor()
        } else {
            cell?.contentView.backgroundColor = UIColor.clearColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        var propertySegment = self.parentViewController as! propertyInfoSegmentViewController
        propertySegment.changeSegmentStatus(true)
        let loadingProgress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingProgress.labelText = "Uploading"
        loadingProgress.detailsLabelText = "Please wait"
        // Loading Window Show
        dismissViewControllerAnimated(true, completion: nil)
        uploadToCloudinary()
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uploadDetailsToServer(publicKey:String) {
        //upload your metadata to your rest endpoint
        
        var count = totalImages.count
        var upload_key = ["cloudinary_image_id":"\(publicKey)"]
        addImages.addObject(publicKey)
        totalImages.addObject(upload_key)
        if (count < totalImages.count)
        {
            var index: Int = totalImages.count - 1
            var indexPath = NSIndexPath(forItem: index, inSection: 0)
            updateImagesToserver()
            self.imageCollectionView.insertItemsAtIndexPaths([indexPath])
            //println(addImages)
        }
        
        //alert.dismissWithClickedButtonIndex(0, animated: true)
    }
    
    func updateImagesToserver() {
        
        var propertySegment = self.parentViewController as! propertyInfoSegmentViewController
        propertySegment.selectedSegmentControll()
        var updateImages : [String: AnyObject] = [:]
        updateImages["add_image_ids"] = addImages
        updateImages["remove_image_ids"] = deleteImages
        var authentication = NSUserDefaults.standardUserDefaults().objectForKey("remember_token") as! NSString
        var methodType: String = "POST"
        var base: String = "image/create_update_images.json"
        var propertyId = (editPropertyArray[0]["id"] as! NSNumber).stringValue
        var urlRequest: String = base
        var serviceCall : WebServiceCall = WebServiceCall()
        var uploadImages : [String: AnyObject] = [:]
        uploadImages["property_id"] = propertyId
        uploadImages["image_ids"] = updateImages
        
        var connection = appDelegate.checkConnection()
        if (connection == true)
        {
            serviceCall.adminApiCallRequest(methodType, urlRequest: urlRequest, param:uploadImages as Dictionary<String, AnyObject>, authentication: authentication as String, completion: { (resultData, response) -> () in
                
                var result = serviceCall.imageUploadingResult(resultData!)
                if ( result != "") {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    let message = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    message.mode = MBProgressHUDMode.Text
                    message.detailsLabelText = "Done Successfully"
                    message.hide(true, afterDelay: 2)
                    propertySegment.changeSegmentStatus(false)
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            })
        }
        else {
            appDelegate.showNetworkErrorView()
        }
        
    }
    
    func uploadToCloudinary(){
        
        var newSize: CGSize = CGSizeMake(1280, 720)
        UIGraphicsBeginImageContext(newSize)
        pickedImage!.drawInRect(CGRectMake(0, 0, 1280, 720))
        pickedImage = UIGraphicsGetImageFromCurrentImageContext()
        let forUpload = UIImageJPEGRepresentation(pickedImage, 0.0) as NSData
        UIGraphicsEndImageContext()
        let uploader = CLUploader(cloudinary, delegate: self)
        var connection = appDelegate.checkConnection()
        if (connection == true) {
            uploader.upload(forUpload, options: nil, withCompletion: onCloudinaryCompletion, andProgress: onCloudinaryProgress)
        }
        else {
            appDelegate.showNetworkErrorView()
        }
        
    }
    
    func onCloudinaryCompletion(successResult:[NSObject : AnyObject]!, errorResult:String!, code:Int, idContext:AnyObject!) {
        
        
        if(errorResult != nil) {
            alert = UIAlertView(title: "Message", message: "Image is not uploaded", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            var propertySegment = self.parentViewController as! propertyInfoSegmentViewController
            propertySegment.selectedSegmentControll()
            propertySegment.changeSegmentStatus(false)
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
        else {
            var public_id = successResult["public_id"] as! String
            uploadDetailsToServer(public_id)
        }
        
        
        
    }
    
    func onCloudinaryProgress(bytesWritten:Int, totalBytesWritten:Int, totalBytesExpectedToWrite:Int, idContext:AnyObject!) {
        //do any progress update you may need
    }

}
