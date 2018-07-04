//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 7/4/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation

class StudentLocations {
    static var locations = [StudentInformation]()
    
    class func studentLocationsFromResult(_ results:[[String: AnyObject]]){
        for result in results{
            locations.append(StudentInformation(dictionary: result))
        }
    }
}
