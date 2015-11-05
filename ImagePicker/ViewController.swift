//
//  ViewController.swift
//  ImagePicker
//
//  Created by Tina Guthmann on 10/29/15.
//  Copyright (c) 2015 Tina Guthmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var cancelImagePicker: UIToolbar!
    
    //the Meme struct stores data needed to save a Meme
    struct Meme {
        var topText : String
        var bottomText : String
        var image : UIImage
        var memedImage : UIImage
    }
    
    //executes just after view loads; setup information here
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up view as a delegate for the text fields
        topText.delegate = self;
        bottomText.delegate = self;
        
        //enable the camera button only if caller has a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //set up text
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.clearColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSBackgroundColorAttributeName : UIColor.clearColor(),
            NSStrokeWidthAttributeName : -1.0
        ]
        
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        topText.text = "TOP"
        topText.hidden = false;

        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.Center
        bottomText.text = "BOTTOM"
        bottomText.hidden = false;
    }

    //subscribe to keyboard notifications just before the view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    //unsubscribe from keyboard notifications just before view disappears
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
   //this is the function that will save a meme; it will be further
    //implemented in Meme Me 2.0
    //the compiler suggested adding the '_' to remove the warning that
    //the created meme is not being used.
    //warning: /Users/tinaguthmann/Udacity2/ImagePicker/ImagePicker/ViewController.swift:36:13: Initialization of immutable value 'meme' was never used; consider replacing with assignment to '_' or removing it

    func save(memedImage:UIImage){
        _ = Meme( topText:topText.text!, bottomText: bottomText.text!, image:
            imagePickerView.image!, memedImage: memedImage)
       
    }
    
    //this function is executed when the Action button is selected
    //the meme is generated and the Activity View Controller is displayed
    @IBAction func takeAction(sender: AnyObject) {
        
        //memed image, with image and text is generated
        let memedImage = generateMemedImage()
        
        //create the Activity View Controller
        let activityViewController = UIActivityViewController(activityItems: [memedImage],applicationActivities: nil)
        
        //this sets up the save of the meme, which will be doen when the Activity View Controller is completed
        activityViewController.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.save(memedImage)
            } }

        //display the Activity View Controller
          presentViewController(activityViewController,animated: true, completion: nil)
    }

    //I did not implement the cancel button, even though it is shown on the
    //demo app.  The documentation I found discouraged cancelling the app,
    //though it can be done with a call to the exit function.
    @IBAction func cancelApp(sender: AnyObject) {
      dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    //this creates the memed image from what is currently on the screen
    func generateMemedImage() -> UIImage {
        
        //we want to hide the toolbars, so that they are not
        //part of the meme
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        //create the image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //once the image is created, the toolbars can be redisplayed
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }
    
    //we have subscribed to keyboard notifications, so we can be
    //notified just before the keyboard will display;
    func keyboardWillShow(notification: NSNotification) {
        
        //move the picture up so that the user can see the text
        //while typing; we need to do this only for the botton 
        //keyboard
        if (bottomText.isFirstResponder())
        {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        //move the picture back down while typing; we need to do this 
        //only for the botton keyboard
        if (bottomText.isFirstResponder())
        {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //retrieve the height of the keyboard; 
    //used in the keyboard show/hide functions
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        //notification.user
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //dismisses the keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    //detects when a user touches the screen and removes the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    //subscribe to keyboard show and hide notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //unsubscribe from keyboard show and hide notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

    //execute this when user selects camera icon
    @IBAction func pickAnImageCamera(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated:true, completion:nil)
    }

    //execute this when user selects album icon
    @IBAction func pickAnImageAlbum(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated:true, completion:nil)
    }

    //executed when user selects image from image picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
            topText.hidden = false;
            bottomText.hidden = false;

        }
    }
 
    //executed when user selects cancel icon from image picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        imagePickerView.image = nil
        topText.hidden = true
        bottomText.hidden = true
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
}

