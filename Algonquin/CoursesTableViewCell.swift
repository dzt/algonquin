//
//  CoursesTableViewCell.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/24/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import Foundation
import UIKit


class CoursesTableViewCell : UITableViewCell
{
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var gradeNumber: UILabel!
    
    var course: Course! {
        didSet {
            self.setNeedsLayout()
            updateUI()
        }
    }
    
    func updateUI() {
        className.text = course.name
        teacher.text = course.teacher
        gradeNumber.text = course.credits
    }
    
    
}

