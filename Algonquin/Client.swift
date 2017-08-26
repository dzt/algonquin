//
//  Client.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/24/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

class Client {
    
    public class var shared: Client {
        struct Static {
            static let instance = Client()
        }
        return Static.instance
    }
    
    public let parser: ParserRoutes
    
    private init() {
        parser = ParserRoutes()
    }
}
