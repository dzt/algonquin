//
//  NavigationController.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 2/12/18.
//  Copyright © 2018 Peter Soboyejo. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = UIColor.white
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

