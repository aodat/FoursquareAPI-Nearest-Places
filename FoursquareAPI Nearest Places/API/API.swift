//
//  API.swift
//  FoursquareAPI Nearest Places
//
//  Created by souq on 10/15/16.
//  Copyright © 2016 Odat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class API: UIViewController {
    
    // Forsqueare API request params
    static let BaseURL          = "https://api.foursquare.com/v2/venues/search?"
    static let clientID         = "JVX0WZ1PIYQJICIMZUJQGIA5L2JTCUEVIDCETZVZYYRMNUJD"
    static let clientSecret     = "SNMRVYAOMS421JEMERMRIKBKRC0MMZWGF1CDF3AN1JCDPGIV"
    static var lattidue         = ""
    static var longitude        = ""
    static var searchQuery  = ""
    
    // Full API request
    static var serverRequest:String {
        return  BaseURL + "client_id=" + clientID +
                          "&client_secret=" + clientSecret +
                          "&v=20130815&query=" + searchQuery +
                          "&ll=" + lattidue +
                          "," + longitude
    }
    
    // Get Data method to collect data from server using Alamofire + SwiftyJSON
    class func getData(completion:( success: Bool, response: [Restaurent]) -> ()) {
        var restaurantsList = [Restaurent]()
        var success = false
        
        Alamofire.request(.GET, serverRequest).responseJSON { (response) -> Void in
            if((response.result.value) != nil) {
                let jsonResponseValue = JSON(response.result.value!)
                if let restaurentArray = jsonResponseValue["response"]["venues"].array {
                    success = true
                    for restDictinary in restaurentArray {
                        let restaurent = Restaurent(json: restDictinary)
                        restaurantsList.append(restaurent)
                    }
                }
            }
            completion(success: success, response: restaurantsList)
        }
    }
    
}
