//
//  UserViewController.swift
//  Weavr
//
//  Created by Joshua Peeling on 3/24/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit


// This class is eventually going to show all the information belonging to the User class of type MKAnnotation

class UserViewController: ProfileViewController {
    
    override func viewDidAppear(animated: Bool) {
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Just testing this information, really need to actually implement the rest of the user's data that was selected
        
        if userDetails != nil {
            
            name.text? = userDetails!.userName
            
            metStarsBlocked.setTitle("Met " + userDetails!.metNumber, forSegmentAtIndex: 0)
            metStarsBlocked.setTitle("Stars " + userDetails!.starsNumber, forSegmentAtIndex: 1)
            metStarsBlocked.setTitle("Blocked " + userDetails!.blockedNumber, forSegmentAtIndex: 2)
            
            // Need to add profile picture here eventually
            
            print("\(userDetails!.topicOne)")
            
            topicOneLabel.text? = userDetails!.topicOne
            topicTwoLabel.text? = userDetails!.topicTwo
            topicThreeLabel.text? = userDetails!.topicThree
            
            
            locationLabel.text? = "At: " + userDetails!.locationName
            
            leavingLabel.text? = "Until: " + userDetails!.leavingAt
            
            userWords.text? = userDetails!.userWords
            
            print("Implement rest of details here")
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func reachOut(sender: UIButton) {
        
        
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
