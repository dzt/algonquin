//
//  ParserRoutes.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/23/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParserRoutes {
    
    func getSummary(userid: String, password: String,completion: ((_ summary: Summary?, _ error: String?) -> Void)?) {
        var params = [String: String]()
        let body = [
            "userid": userid,
            "password": password
        ] as [String: Any]
        
        Request.request("/api/courses", requestType: "POST", body: body) { json, error in
            guard let courses = json?["courses"].array else {
                completion?(nil, error)
                return
            }
            completion?(Summary(json: json!), error)
        }
    }
    
}
