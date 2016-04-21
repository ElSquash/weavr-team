//
//  MessagesTableViewCell.swift
//  Weavr
//
//  Created by Joshua Peeling on 4/14/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var lastSent: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
