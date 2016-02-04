//
//  Network.swift
//  Astute
//
//  Created by Ulises Giacoman on 2/4/16.
//  Copyright © 2016 DeHacks. All rights reserved.
//

import Foundation
import SwiftyJSON

// hostname of server
let HOSTNAME = ""
//let HOSTNAME = "http://localhost:5000/"

// api url routes
let REGISTER_ROUTE = "register"
let LOGIN_ROUTE = "login"

// complete api route strings
let REGISTER_URL_STRING = HOSTNAME + REGISTER_ROUTE
let LOGIN_URL_STRING = HOSTNAME + LOGIN_ROUTE

class Network: NSObject {
    
    
    /*
    register
    --------
    Attempts to register a new user into the system
    
    :username:              W&M username string
    :password:              W&M password string
    :phone:                 User phone number (e.x. 1xxxyyyzzzz) NOTE: there is no plus sign
    :completionHandler:     Callback function called when response is gotten. Function that takes a boolean stating
    whether the register request succeeded or not. If the request failed, the :message: parameter
    will contain an error message
    */
    class func register(username: String, password: String, phone: String, completionHandler: (success: Bool, message: String) -> ()) {
        
        // create register url
        let registerUrl = NSURL(string: REGISTER_URL_STRING)
        
        // initialize url request object
        let request = NSMutableURLRequest(URL: registerUrl!)
        
        // set http method to POST and encode form parameters
        request.HTTPMethod = "POST"
        request.HTTPBody = NSMutableData(data:
            "username=\(username)&password=\(password)&phone=%2B1\(phone)".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // initialize session object create http request task
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error -> Void in
            
            // if there was an error, request failed
            if(error != nil) {
                completionHandler(success: false, message: "There was a network error while registering")
                return
            }
            
            // if there is no response, request failed
            if(response == nil) {
                completionHandler(success: false, message: "No response from server. Please try again later.")
                return
            }
            
            // else check the request status code to see if registering succeeded
            let httpResponse = response as! NSHTTPURLResponse
            switch(httpResponse.statusCode) {
            case 200:
                completionHandler(success: true, message: "Registered!")
            case 409:
                completionHandler(success: false, message: "The username or phone you specified already exists")
            case 400:
                completionHandler(success: false, message: "The username, password, or phone number were entered incorrectly")
            default:
                print("Status Code received: \(httpResponse.statusCode)")
                completionHandler(success: false, message: "There was an error while registering")
            }
        })
        
        // start task
        task.resume()
    }
    
    
    /*
    checkCookie
    ----------
    Checks whether a cookie has been saved. A cookie is saved when registering and when logging in. It is cleared on logout.
    
    */
    class func checkCookie(completionHandler: (success: Bool, message: String) -> ()) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let data: NSData? = defaults.objectForKey("sessionCookies") as? NSData
        
        switch(data) {
        case nil:
            print("User not logged in, defaults empty")
            completionHandler(success: false, message: "User not logged in, defaults empty")
        default:
            print("Cookies found")
            completionHandler(success: true, message: "Cookies found")
        }
    }
    
    /*
    login
    -----
    Attempts to log the user in
    
    :username:          the username string of the user attempting to login
    :password:          the password string of the user attempting to login
    :completionHandler: the function to call when the response is recieved. Takes a
    boolean flag signifying if the request succeeded and a message string
    */
    class func login(username: String, password: String, completionHandler: (success: Bool, message: String) -> ()) {
        // create login url
        let loginUrl = NSURL(string: LOGIN_URL_STRING)
        
        // initialize url request object
        let request = NSMutableURLRequest(URL: loginUrl!)
        
        // set http method to POST and encode form parameters
        request.HTTPMethod = "POST"
        request.HTTPBody = NSMutableData(data:
            "username=\(username)&password=\(password)".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // initialize session object create http request task
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request, completionHandler: {
//            data, response, error -> Void in
//            
//            // if there was an error, request failed
//            if(error != nil) {
//                completionHandler(success: false, message: "There was a network error while logging in")
//                return
//            }
//            
//            // if there is no response, request failed
//            if(response == nil) {
//                completionHandler(success: false, message: "No response from server.")
//                return
//            }
            
            // else check the request status code to see if login succeeded
//            let httpResponse = response as! NSHTTPURLResponse
            let fake = 200
            
            switch(fake) {
            case 200:
                
                completionHandler(success: true, message: "Logged in!")
//            case 400:
//                completionHandler(success: false, message: "Invalid username or password.")
            default:
//                print("Status Code received: \(httpResponse.statusCode)")
                completionHandler(success: false, message: "There was an error while logging in.")
            }
//        })
        
        // start task
//        task.resume()
    }
    
    
    class func getDateInfo(today:String)->[Int]? {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH"
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components([.Weekday, .Hour], fromDate: todayDate)
            let dateInfo = [myComponents.weekday, myComponents.hour]
            return dateInfo
        } else {
            return nil
        }
    }
    
    
    
}