//
//  MessagesTableViewController.swift
//  Weavr
//
//  Created by Joshua Peeling on 4/14/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {
    
    var currentConvos = [UserConvo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleConvos()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        
        
        return currentConvos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "messageCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! MessagesTableViewCell
        
        // Configure the cell...
        let convo = currentConvos[indexPath.row]
        
        cell.userName.text = convo.userName
        
        
        // Change the image from a square to a circle
        cell.userPic.layer.borderWidth = 1
        cell.userPic.layer.masksToBounds = false
        cell.userPic.layer.borderColor = UIColor.whiteColor().CGColor
        cell.userPic.layer.cornerRadius = cell.userPic.frame.width/2
        cell.userPic.clipsToBounds = true
        
        
        cell.userPic.image = UIImage(named: convo.userPic)
        cell.lastMessage.text = convo.lastMessage
        cell.lastSent.text = convo.lastSent
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
    
    func loadSampleConvos() {
        
        let userConvo1 = UserConvo(userName: "John Doe", userPic: "no-profile-pic", lastMessage: "Hey, that sounds like a great idea!!! What time do you want to meet there?", lastSent: "2:55pm")
        
        let userConvo2 = UserConvo(userName: "Marry Hill", userPic: "no-profile-pic", lastMessage: "Meet me at the table near the front of the store :) ", lastSent: "9:13pm")
        
        let userConvo3 = UserConvo(userName: "Michael Jordanson", userPic: "no-profile-pic", lastMessage: "Hey man, it's cool you reached out! ", lastSent: "Yesterday")
        
        currentConvos += [userConvo1]
        currentConvos += [userConvo2]
        currentConvos += [userConvo3]
    }

}
