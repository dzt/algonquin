//
//  Course.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/23/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import SwiftyJSON

class Course {
    
    var id: String?
    var name: String?
    var credits: String?
    var comments: String?
    var teacher: String?
    
    init(json: JSON) {
        
        id = json["id"].string
        name = json["name"].string
        credits = json["credits"].string
        comments = json["comments"].string
        teacher = json["teacher"].string
        
    }
    
}
