//
//  CourseDetailTableViewController.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/26/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import UIKit

class CourseDetailTableViewController : UITableViewController {
    
    var course: Course!
    var headerView: UIView!
    let tableHeaderHeight: CGFloat = 164.0
    
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var overallAvg: UILabel!
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var quarterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        updateHeaderView()
        
        courseName.text = course.name
        teacher.text = course.teacher
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let screenSize = UIScreen.main.bounds.size
        let terms = ["Quarter 1", "Quarter 2", "Quarter 3", "Quarter 4"]
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let sizePicker = SelectorView.show(selections: terms, bounceUpTo: screenSize.height - headerImg.frame.height, topText: "Select Term")
            sizePicker.completionHandler = { result in
                self.quarterLabel.text = result
            }
        }
        
    }
}
