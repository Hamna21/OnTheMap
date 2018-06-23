//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/23/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation

extension UdacityClient{
    func authenticateUser(email: String, password: String, _ completionHandlerForAuth: @escaping(_ success: String?, _ error: NSError?) -> Void){
        let mutableMthod = Methods.Session
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"

        let _ = taskForPostMethod(mutableMthod, nil, jsonBody) { (results, error) in
            if let error = error {
                completionHandlerForAuth(nil, error)
            }else {
                guard let session = results![JSONResponseKeys.Session] as? [String: AnyObject] else {
                    let userInfo = [NSLocalizedDescriptionKey : "No Session Id"]
                    completionHandlerForAuth(nil, NSError(domain: "authenticateUser", code: 1, userInfo: userInfo))
                    return
                }
                self.sessionID = session[JSONResponseKeys.SessionID] as? String
                completionHandlerForAuth(self.sessionID, nil)
            }
            
        }
    }
}
