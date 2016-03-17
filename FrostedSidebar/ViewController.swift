//
//  ViewController.swift
//  CustomStuff
//
//  Created by Evan Dekhayser on 7/9/14.
//  Copyright (c) 2014 Evan Dekhayser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
    @IBOutlet weak var scrollView: UIScrollView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
        scrollView.contentSize.height = 1000
	}
	
	@IBAction func onBurger() {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }
}

