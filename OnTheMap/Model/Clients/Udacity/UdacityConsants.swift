//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/23/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//


extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    
    }
    
    // MARK: Methods
    struct Methods {
        // MARK: Account
        static let Session = "/session"
        static let UserData = "/users/{user_id}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "user_id"
    }

    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let Account = "account"
        static let Key = "key"
        static let User = "user"
        static let Session = "session"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
}
