//
//  SignupViewController.swift
//  Weavr
//
//  Created by Joshua Peeling on 4/26/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var alertMessage: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cancelSignUp: UIButton!
    
    @IBOutlet weak var firstNameInput: UITextField!
    
    @IBOutlet weak var lastNameInput: UITextField!
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var dateOfBirth: UIDatePicker!
    
    @IBOutlet weak var userNameInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var confirmPasswordInput: UITextField!
    
    @IBOutlet weak var male_female_input: UISegmentedControl!
    
    var userDateChoice = ""
    var createdUser : [String : String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.contentSize.height = 800
        
        firstNameInput.delegate = self
        lastNameInput.delegate = self
        emailInput.delegate = self
        userNameInput.delegate = self
        passwordInput.delegate = self
        confirmPasswordInput.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dateOfBirthAction(sender: UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.stringFromDate(dateOfBirth.date)
        
        userDateChoice = strDate
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func userSignup(sender: AnyObject) {
        
        var message = ""
        
        // Check first name, last name, and email for not empty
        if firstNameInput.text != "" && lastNameInput.text != "" && emailInput.text != ""{
            
            if userNameInput.text != "" {
                
                // Reached the golden state, try to insert User
                if passwordInput.text != "" && confirmPasswordInput.text == passwordInput.text {
                    
                    let urlString = "http://localhost:8000/api/registerUser"
                    var message = "foo"
                    
                    
                    // Get JSON from server
                    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                    let session = NSURLSession(configuration: config, delegate: nil, delegateQueue: nil)
                    let url = NSURL(string: urlString)
                    let request  = NSMutableURLRequest(URL: url!)
                    request.HTTPMethod = "POST"
                    
                    let firstName = "firstName=" + firstNameInput.text!
                    let lastName = "&lastName=" + lastNameInput.text!
                    let email = "&email=" + emailInput.text!
                    let dateOfBirth = "&dateOfBirth=" + userDateChoice
                    let userName = "&userName=" + userNameInput.text!.lowercaseString
                    let password = "&password=" + passwordInput.text!
                    
                    let gender = "&gender=" + male_female_input.titleForSegmentAtIndex(male_female_input.selectedSegmentIndex)!
                    
                    let bodyData = firstName + lastName + email + dateOfBirth + userName + password + gender
                    
                    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                    
                    
                    // Make HTTP request
                    session.dataTaskWithRequest(request, completionHandler: { data, response, error in
                        
                        if (data != nil) {
                            
                            // Parse result JSON
                            let json = JSON(data: data!)
                            print(json)
                            let success = json["success"].stringValue
                            print("The query was \(success)")
                            
                            // At this point we know the user was inserted successfully
                            // We can now redirect the user to the ProfileViewController
                            // Need to pass in the token that was generated, and the ID?
                            if(success == "true") {
                                
                                //Set the username and password to a dictionary, and unwind the segue to Login page
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.createdUser = [String : String]()
                                    self.createdUser!["userName"] = self.userNameInput.text!
                                    self.createdUser!["password"] = self.passwordInput.text!
                                    self.alertMessage.textColor = UIColor.greenColor()
                                    self.alertMessage.text = message

                                    self.cancelSignUp.sendActionsForControlEvents(.TouchUpInside)
                                }
                            }
                                
                            else {
                                message = json["message"].stringValue
                                print("\(message)")
                                
                                //
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.alertMessage.text = message
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
                else {
                    
                    message = "Password empty/don't match"
                }
            }
            else {
                message = "Username not valid"
            }
        }
        else {
            message = "Please fill out all fields"
            
        }
        
        alertMessage.text = message
        
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if cancelSignUp === sender {
            
            print("Sign up was cancelled")
        }
    }
    

}
