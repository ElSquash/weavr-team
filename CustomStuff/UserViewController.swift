//
//  UserViewController.swift
//  Weavr
//
//  Created by Joshua Peeling on 3/24/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit


// This class is eventually going to show all the information belonging to the User class of type MKAnnotation
// Should look very similar to the ProfileViewController class, maybe even subclass it?
// Right now using the Artwork class instead, need to wait until a JSON file is written containing some User Profiles
// Also need to finish the User class...then we can finish this View Controller.

class UserViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    
    var pieceOfArt : Artwork?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pieceOfArt != nil {
            
            userName.text? = pieceOfArt!.title!
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
