//
//  Utility.swift
//  cruel1in2
//
//  Created by Jerry Huang on 2014/8/9.
//  Copyright (c) 2014年 Jerry Huang. All rights reserved.
//

import Foundation
import UIKit

// Use Reachablity https://github.com/tonymillion/Reachability

class Utility{
    var URL = ""
    
    func checkNetworkConnection() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: NetworkStatus = reachability.currentReachabilityStatus()
        
        println(networkStatus.toRaw())
        
        switch (networkStatus.toRaw()) {
            case 0:
                println("[Network Status]: NotReachable")
            case 1:
                println("[Network Status]: ReachableViaWWAN")
            case 2:
                println("[Network Status]: ReachableViaWiFi")
            default:
                break
        }
        
        return networkStatus.toRaw() != 0
    }
    
    // Return json file path
    func readConfig() -> String {
        let path = NSBundle.mainBundle().pathForResource("config", ofType: "json")
        let jsonData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
        var error: NSError?
        
        let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as NSDictionary
        
        println("url = ", jsonDict["url"])

        return jsonDict["url"] as String!
    }
    
    // Get
    func getJsonData(urlPath: String) -> NSDictionary {
        let url = NSURL.URLWithString(urlPath)
        var error: NSErrorPointer = nil
        var err: NSError?
        
        var jsonData: NSData = NSData.dataWithContentsOfURL(url, options: .DataReadingMappedIfSafe, error: error)
        let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &err) as NSDictionary

        return jsonDict
    }
}