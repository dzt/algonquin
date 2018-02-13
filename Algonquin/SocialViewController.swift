//
//  SocialViewController.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 2/12/18.
//  Copyright © 2018 Peter Soboyejo. All rights reserved.
//

import UIKit
import TwitterKit

class SocialViewController: TWTRTimelineViewController, ScrollUpController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let client = TWTRAPIClient()
        dataSource = TWTRUserTimelineDataSource(screenName: "ARHSAthletics", apiClient: client)
        self.showTweetActions = false
        
    }
    
    func scrollUp() {
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
}


