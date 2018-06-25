//
//  ParseConstants .swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/23/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
        
    }
    
    struct ParameterKeys{
        static let Limit = "limit"
        static let Order = "order"
        
    }
    
    struct ParameterValues {
        static let Limit = "100"
        static let Order = "-updatedAt"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let Results = "results"
    }
}
