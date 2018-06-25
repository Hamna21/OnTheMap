//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/23/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation

struct StudentLocation {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let createdAt: String?
    let updatedAt: String?
    
    init(dictionary: [String: AnyObject]){
        objectId = dictionary[ParseClient.JSONResponseKeys.objectId] as? String ?? ""
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as? String ?? ""
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as? String ?? "Empty"
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as? String ?? "Empty"
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as? String ?? ""
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as? String ?? ""
        createdAt = dictionary[ParseClient.JSONResponseKeys.createdAt] as? String ?? ""
        updatedAt = dictionary[ParseClient.JSONResponseKeys.updatedAt] as? String ?? ""
        if let latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as? Double {
            self.latitude = latitude
        }else{
            latitude = 28.1461248        }
        if let longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as? Double {
            self.longitude = longitude
        }else{
            self.longitude = -82.75676799999999
        }
    }
    
    static func studentLocationsFromResult(_ results:[[String: AnyObject]]) -> [StudentLocation]{
        var locations = [StudentLocation]()
        
        for result in results{
            locations.append(StudentLocation(dictionary: result))
        }
        return locations
    }
}
