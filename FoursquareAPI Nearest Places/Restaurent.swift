//
//  Restaurent.swift
//  FoursquareAPI Nearest Places
//
//  Created by souq on 10/15/16.
//  Copyright © 2016 Odat. All rights reserved.
//

import UIKit
import SwiftyJSON

class Restaurent:NSObject{
    var name: String?
    var latitude: Double?
    var longitude: Double?
    
    init(json:JSON) {
        self.name = json["name"].string
        self.latitude = json["location"]["lat"].double
        self.longitude = json["location"]["lng"].double
        
    }
}
