//
//  ScrollUpTabBarController.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/26/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollUpController {
    func scrollUp()
}

class ScrollUpTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        self.delegate = self
        super.viewWillAppear(animated)
    }
    
    var lastViewController : UIViewController?
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let controller = viewController as? UINavigationController {
            // for navigation controller, pick out the first VC and call scroll up.
            if controller.viewControllers.count == 1 {
                if let scrollController = controller.viewControllers[0] as? ScrollUpController {
                    scrollController.scrollUp()
                }
            }
        }
        
    }
    
}
