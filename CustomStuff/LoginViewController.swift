//
//  LoginViewController.swift
//  Weavr
//
//  Created by Joshua Peeling on 4/20/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        password.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func attemptLogin(sender: UIButton) {
        print("Running")
        let urlString = "http://localhost:8000/api/authenticate"
        
        // Get text input from Login Screen
        let userNameInput = userName.text
        let passwordInput = password.text
        let bodyData = "userName=" + userNameInput! + "&password=" + passwordInput!
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
                let success = json["success"].stringValue
                print("\(success)")
                
                // The login was sucessful and we got a token!!! WOW!
                if(success == "true") {
                    
                    let token = json["token"].stringValue
                    let _id = json["_id"].stringValue
                    
                    // Send off a thread to set the NSUserDefaults currentToken to the token we just got, and dismiss the login screen
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorMessage.text = "Got Token!"
                        
                        let prefs = NSUserDefaults.standardUserDefaults()
                        prefs.setValue(token, forKey:"currentToken")
                        prefs.setValue(_id, forKey:"_id")
                        
                        print("Got the ID on login")
                        
                        // Use the reference to the ProfileViewController that was passed in on the segue
                        // and set the _id variable to the _id that was recieved on login
                        // Then dismiss the LoginViewController
                        // This is probably not the best way to do this...but is working for now
                        
                        self.dismissViewControllerAnimated(true, completion: {})
                        
                    }
                }
                    
                // The login was not successful, and either the name was wrong, password was wrong, or both was wrong...
                else {
                    message = json["message"].stringValue
                    print("\(message)")
                    
                    // Send off a thread to update the error message for the user
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorMessage.text = message
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true

    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("Login Segue is getting called")
        
    }
    

}
