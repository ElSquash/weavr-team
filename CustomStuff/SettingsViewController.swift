//
//  SettingsViewController.swift
//  Weavr
//
//  Created by Joshua Peeling on 4/26/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onBurger() {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
    // Need to remove the cached token and _id and auto-click on the ProfileViewController
    @IBAction func logoutUser(sender: UIButton) {
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        prefs.removeObjectForKey("currentToken")
        prefs.removeObjectForKey("_id")

        
        if let myTabBar = tabBarController as? TabBarController {
            myTabBar.sidebar.selectItemAtIndex(0)
        }
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
