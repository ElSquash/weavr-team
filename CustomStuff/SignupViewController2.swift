//
//  SignupViewController2.swift
//  Weavr
//
//  Created by Joshua Peeling on 6/1/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

class SignupViewController2: UIViewController {
    
    
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var userNameInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var confirmPasswordInput: UITextField!
    
    @IBOutlet weak var previousBtn: UIButton!
    
    
    var signUpInfo1Saved = [String : String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = .CrossDissolve
        
            
            print("displaying saved data")
            
        emailInput.text = signUpInfo1Saved["email"]
        passwordInput.text = signUpInfo1Saved["password"]
        userNameInput.text = signUpInfo1Saved["username"]
        confirmPasswordInput.text = signUpInfo1Saved["confirmPassword"]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if sender === previousBtn {
            
            print("Going to previous signup page")
            
            if let signUp1Vc = segue.destinationViewController as?SignupViewController {
                
                
    
                print("Storing values now from signup 2")
                print("Stored email: " + emailInput.text!)
                signUp1Vc.signUp2InfoSaved["email"] = emailInput.text!
                signUp1Vc.signUp2InfoSaved["username"] = userNameInput.text!
                signUp1Vc.signUp2InfoSaved["password"] = passwordInput.text!
                signUp1Vc.signUp2InfoSaved["confirmPassword"] = confirmPasswordInput.text!
                
            }

        }
        
    }
    

}
