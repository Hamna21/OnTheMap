//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/23/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    var session = URLSession.shared
    var userID: String? = nil
    
    override init(){
        super.init()
    }
    //GET request
    func taskForGetMethod(_ parameters: [String: AnyObject]? = nil, _ method: String, _ completionHandlerForGet: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void)-> URLSessionDataTask{
        let parameters = parameters ?? nil
        let request = URLRequest(url: udacityURLFromParamters(method, parameters))
        
        let task = session.dataTask(with: request){(data, response, error) in
            func sendError(_ error: String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGet(nil, NSError(domain: "taskForPost", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else{
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                sendError("Status Code other than 2xx")
                return
            }
            guard let data = data else{
                sendError("No Data was returned")
                return
            }
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
           
            self.convertDataWithCompletionHandler(data: newData, completionHandlerForData: completionHandlerForGet)
        }
        task.resume()
        return task
    }
    
    //POST request
    func taskForPostMethod(_ method: String, _ parameters: [String: AnyObject]?, _ jsonBody: String?, _ completionHandlerForPost: @escaping(_ result: AnyObject?, _ error: NSError?)->Void) -> URLSessionDataTask {
        
        let parameters = parameters ?? nil
        let request = NSMutableURLRequest(url: udacityURLFromParamters(method, parameters))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody?.data(using: String.Encoding.utf8)
       
        let task = session.dataTask(with: request as URLRequest){(data, response, error) in
            func sendError(_ error: String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPost(nil, NSError(domain: "taskForPost", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else{
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                sendError("Invalid Email/Password")
                return
            }
            guard let data = data else{
                sendError("No Data was returned")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            //print(String(data: newData, encoding: .utf8)!)
            
            self.convertDataWithCompletionHandler(data: newData, completionHandlerForData: completionHandlerForPost)
            
        }
        task.resume()
        
        return task
    }
    //DELETE request
    func taskForDeleteMethod(_ parameters: [String: AnyObject]? = nil, _ method: String, _ completionHandlerForGet: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void)-> URLSessionDataTask{
        let parameters = parameters ?? nil
        let request = NSMutableURLRequest(url: udacityURLFromParamters(method, parameters))
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest){(data, response, error) in
            func sendError(_ error: String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGet(nil, NSError(domain: "taskForPost", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else{
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                sendError("Status Code other than 2xx")
                return
            }
            guard let data = data else{
                sendError("No Data was returned")
                return
            }
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            self.convertDataWithCompletionHandler(data: newData, completionHandlerForData: completionHandlerForGet)
        }
        task.resume()
        return task
    }
    
    
    
    //JSON Deserialization of data reqturned
    private func convertDataWithCompletionHandler(data: Data,completionHandlerForData: @escaping(_ result: AnyObject?, _ error: NSError?)->Void){

        var parsedResult :AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse data"]
            completionHandlerForData(nil, NSError(domain: "taskForPost", code: 1, userInfo: userInfo))
        }
        completionHandlerForData(parsedResult, nil)
    }
    
    //Substituting key with value in url
    func substituteKeyWithValueInUrl(method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
            
        }else{
            return nil
        }
    }
    
    //Creating URL from method name and query parameters
    private func udacityURLFromParamters(_ withPathExtension: String?, _ parameters: [String: AnyObject]?) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for(key, value) in parameters{
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        return components.url!
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static let sharedInstane = UdacityClient()
        }
        return Singleton.sharedInstane
    }
    
}
