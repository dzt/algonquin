//
//  Utils.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/26/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import UIKit

class Utils {
    class func decodeBase64(encodedData : String) -> Data{
        
        let imageData = Data(base64Encoded: encodedData, options: .ignoreUnknownCharacters)
        return imageData!
        
    }
}
