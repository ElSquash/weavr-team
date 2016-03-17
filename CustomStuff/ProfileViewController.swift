//
//  ProfileViewController.swift
//  Weavr
//
//  Created by Joshua Peeling on 3/10/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var profile_pic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        profile_pic.layer.borderWidth = 1
        profile_pic.layer.masksToBounds = false
        profile_pic.layer.borderColor = UIColor.whiteColor().CGColor
        profile_pic.layer.cornerRadius = profile_pic.frame.width/2
        profile_pic.clipsToBounds = true
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
    
    @IBAction func onBurger() {
        
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }


}
