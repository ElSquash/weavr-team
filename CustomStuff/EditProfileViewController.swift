//
//  EditProfileViewController.swift
//  Weavr
//
//  Created by Joshua Peeling on 4/24/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var saveChanges: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var userWords: UITextView!
    
    @IBOutlet weak var topicOneInput: UITextField!
    
    @IBOutlet weak var topicTwoInput: UITextField!
    
    @IBOutlet weak var topicThreeInput: UITextField!
    
    @IBOutlet weak var leavingAtPicker: UIPickerView!
    
    let pickerData = [["12:","1:","2:","3:","4:","5:","6:","7:","8:","9:","10:","11:"], ["00","15","30","45"], ["AM", "PM"]]
    
    var previousUserInfo = [String : String]()
    var updatedUserInfo : [String : String]?

    var currentHourSelected = "12:"
    var currentMinuteSelected = "00"
    var currentAmPmSelected = "AM"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.contentSize.height = 700
        
        leavingAtPicker.dataSource = self
        leavingAtPicker.delegate = self
        
        userWords.delegate = self
        topicOneInput.delegate = self
        topicTwoInput.delegate = self
        topicThreeInput.delegate = self
        
        // This should always be the case, and will populate the edit fields with the user's current info he/she wants to change
        if previousUserInfo.count > 0 {
            
            userWords.text = previousUserInfo["userWords"]
            topicOneInput.text = previousUserInfo["topicOne"]
            topicTwoInput.text = previousUserInfo["topicTwo"]
            topicThreeInput.text = previousUserInfo["topicThree"]

        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelEditProfile(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    // make sure that at least one topic is not blank if they want to save
    func checkAtLeastOne() {
        
        if(topicOneInput.text == "" && topicTwoInput.text == "" && topicThreeInput.text == "") {
            
            saveChanges.enabled = false
        }
        else {
            saveChanges.enabled = true
        }
    }
    
    //MARK: Data Source set up for UIPicker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    //MARK: Delegate methods for UIPicker
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attributedString: NSAttributedString!
        
        attributedString = NSAttributedString(string: pickerData[component][row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])

        
        return attributedString
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
            
        case 0 :
            
            currentHourSelected = pickerData[component][row]
            
        case 1 :
            currentMinuteSelected = pickerData[component][row]
            
        case 2 :
            currentAmPmSelected = pickerData[component][row]
            
        default :
            break
        }
        
        //print(currentHourSelected + currentMinuteSelected + " " + currentAmPmSelected)
    }
    
    
    // MARK: Delegate Methods for UITextView and UITextField
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        checkAtLeastOne()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if saveChanges.enabled {
            saveChanges.enabled = false
        }
    }
    
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
       
        // If User presses save button, send off request to server to update all the newly changed information...
        // Need to send off all info listed below, especially the _id. Send in POST format.
        if saveChanges === sender {
            
            updatedUserInfo = [String : String]()
            updatedUserInfo?["userWords"] = self.userWords.text
            updatedUserInfo?["topicOne"] = self.topicOneInput.text
            updatedUserInfo?["topicTwo"] = self.topicTwoInput.text
            updatedUserInfo?["topicThree"] = self.topicThreeInput.text
            updatedUserInfo?["leavingAt"] = currentHourSelected + currentMinuteSelected + " " + currentAmPmSelected
            
        }
        
        // Check NSUserDefaults for a "currentToken" to access the server with...
        let prefs = NSUserDefaults.standardUserDefaults()
        
        // Use below line for testing, if you need to remove the current token
        //prefs.removeObjectForKey("currentToken")
        
        if let currentToken = prefs.stringForKey("currentToken"){
            
            let storedID = prefs.stringForKey("_id")
            let urlString = "http://192.81.216.130:8000/api/updateUserInfo"
            
            // Get text input from Login Screen
            let currentToken = "token=" + currentToken
            let _id = "&_id=" + storedID!
            let userWords = "&userWords=" + self.updatedUserInfo!["userWords"]!
            let topicOne = "&topicOne=" + self.updatedUserInfo!["topicOne"]!
            let topicTwo = "&topicTwo=" + self.updatedUserInfo!["topicTwo"]!
            let topicThree = "&topicThree=" + self.updatedUserInfo!["topicThree"]!
            let leavingAt = "&leavingAt=" + self.updatedUserInfo!["leavingAt"]!

            let bodyData = currentToken + _id + userWords + topicOne + topicTwo + topicThree + leavingAt
            
            var message = "foo"
            
            // Get JSON from server
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config, delegate: nil, delegateQueue: nil)
            let url = NSURL(string: urlString)
            let request  = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            
            // Make HTTP request
            session.dataTaskWithRequest(request, completionHandler: { data, response, error in
                
                if (data != nil) {
                    
                    // Parse result JSON
                    let json = JSON(data: data!)

                    let userUpdated = json["userUpdated"].stringValue
                    print("\(userUpdated)")
                    
                    // The current token we have is already valid and not exired! YAY!
                    // We have complete access to the User Information
                    if(userUpdated == "true") {
                        
                        print("Token still valid, and user was found!")
                        
                        // Send off thread to do something async because the update was successful...
                        dispatch_async(dispatch_get_main_queue()) {
                            

                        }
                    }
                        
                        // The current token we have is NOT VALID, most likely expired...
                    else {
                        message = json["message"].stringValue
                        print("\(message)")
                        
                        // Send off a thread to get user off of screen...because they do not have a valid token
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            // Remove cached token and _id because they are outdated now
                            prefs.removeObjectForKey("currentToken")
                            prefs.removeObjectForKey("_id")
                            
                            self.dismissViewControllerAnimated(false, completion: {})
                        }
                        
                    }
                    
                }
                else {
                    print("Data is nil")
                }
                
                if(error != nil) {
                    print("\(error)")
                }
                
            }).resume()
        }
    
    }
    

}
