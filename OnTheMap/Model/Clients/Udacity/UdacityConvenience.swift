//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/23/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func authenticateUser(email: String, password: String, _ completionHandlerForAuth: @escaping(_ success: Bool, _ errorString: String?) -> Void){
        let mutableMthod = Methods.Session
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        let _ = taskForPostMethod(mutableMthod, nil, jsonBody) { (results, error) in
            if let error = error {
                completionHandlerForAuth(false, error.localizedDescription)
            }else {
                guard let account = results![JSONResponseKeys.Account] as? [String: AnyObject] else {
                    completionHandlerForAuth(false, "No account")
                    return
                }
                guard let userID = account[JSONResponseKeys.Key] as? String else {
                    completionHandlerForAuth(false, "No account")
                    return
                }
                //Storing userId in constants
                NewStudentLocation.Constants.UserId = userID
                
                //Getting user data using user-id
                self.getUserData(userID: userID){(success, error) in
                    if let error = error {
                        completionHandlerForAuth(false, error)
                        
                    }else{
                        completionHandlerForAuth(true, nil)
                    }
                }
            }
            
        }
    }
    
    //Getting single user data using ID
    func getUserData(userID: String, _ completionHandlerForGettingUser: @escaping(_ success:Bool , _ errorString: String?)->Void){
        var mutableMethod: String = Methods.UserData
        mutableMethod = substituteKeyWithValueInUrl(method: Methods.UserData, key: URLKeys.UserID, value: userID)!
        
        let _ = taskForGetMethod(nil, mutableMethod) { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForGettingUser(false, "Unable to find User")
            }else{
                guard let user = results?[JSONResponseKeys.User] as? [String: AnyObject] else{
                    completionHandlerForGettingUser(false, "Unable to find User")
                    return
                }
                
                guard let firstName = user[JSONResponseKeys.FirstName] as? String, let lastName = user[JSONResponseKeys.LastName] as? String else {
                    completionHandlerForGettingUser(false, "Unable to find User")
                    return
                }
                
                //Storing First and Last name in Constants
                NewStudentLocation.Constants.FirstName = firstName
                NewStudentLocation.Constants.LastName = lastName
                
                completionHandlerForGettingUser(true, nil)
            }
            
        }
        
    }
    
    //Logging out User
    func deleteUserSession(_ completionHandlerForDeleteSession: @escaping(_ success: Bool, _ errorString: String?) -> Void){
        let mutableMethod = Methods.Session
        let _ = taskForDeleteMethod(nil, mutableMethod) { (results, error) in
            if let error = error {
                completionHandlerForDeleteSession(false, error.localizedDescription)
            }else{
                guard let _ = results?[JSONResponseKeys.Session] as? [String: AnyObject] else{
                    completionHandlerForDeleteSession(false, "Error in Logout")
                    return
                }
                completionHandlerForDeleteSession(true, nil)
            }
        }
        
    }
    
    
    
}
