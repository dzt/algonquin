//
//  Summary.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/23/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import SwiftyJSON

class Summary {
    
    var id: String?
    var student: String?
    var grade: String?
    var counselor: String?
    var yog: String?
    var photo: String?
    var courses: [Course]
    
    init(json: JSON) {
        
        id = json["id"].string
        student = json["student"].string
        grade = json["grade"].string
        counselor = json["counselor"].string
        yog = json["yog"].string
        photo = json["photo"].string
        
        courses = [Course]()
        if let courses = json["courses"].array {
            for course in courses {
                self.courses.append(Course(json: course))
            }
        }
        
    }

}

