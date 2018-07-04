//
//  ParseConvenience .swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/23/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation

extension ParseClient{
    func getStudentLocations(_ completionHandlerForGettingPins: @escaping(_ success: Bool?, _ errorString: String?)->Void){
        let paramters = [
            ParameterKeys.Limit : ParameterValues.Limit,
            ParameterKeys.Order:ParameterValues.Order
        ]
        let _ = taskForGetMethod(paramters as [String: AnyObject],nil){ (results, error) in
            if let error = error {
                completionHandlerForGettingPins(false, error.localizedDescription)
            }else{
                if let resultsArray = results![JSONResponseKeys.Results] as? [[String: AnyObject]]{
                    
                    //Storing student locations in Array Model
                    StudentLocations.studentLocationsFromResult(resultsArray)
                    completionHandlerForGettingPins(true, nil)
                }else{
                   completionHandlerForGettingPins(false, "No Data. Try again!")
                }
            }
        }
    }
    
    func addNewStudentLocation(_ completionHandlerForNewLocation: @escaping(_ success: Bool, _ errorString : String?) -> Void){
        let jsonBody : String = "{\"uniqueKey\": \"\(NewStudentLocation.Constants.UserId)\", \"firstName\": \"\(NewStudentLocation.Constants.FirstName)\", \"lastName\": \"\(NewStudentLocation.Constants.LastName)\",\"mapString\": \"\(NewStudentLocation.Constants.Location)\", \"mediaURL\": \"\(NewStudentLocation.Constants.Link)\",\"latitude\": \(NewStudentLocation.Constants.Latitude), \"longitude\": \(NewStudentLocation.Constants.Longitude)}"
        
        let _ = taskForPostMethod(nil, nil, jsonBody) { (results, error) in
            if let error = error {
                completionHandlerForNewLocation(false, error.localizedDescription)
            }else {
                guard let objectId = results?[JSONResponseKeys.objectId] as? String else{
                    completionHandlerForNewLocation(false, "Error in insertion")
                    return
                }
                //Saving value in Constants
                NewStudentLocation.Constants.ObjectId = objectId
                
                completionHandlerForNewLocation(true,nil )
                
            }
            
        }
        
    }
}
