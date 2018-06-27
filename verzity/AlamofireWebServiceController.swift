//
//  AlamofireWebServiceController.swift
//  verzity
//
//  Created by Jossue Betancourt on 21/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class AlamofireWebServiceController {
    
    var request: Alamofire.Request?
    
    static let REQUEST_METHOD_POST = "POST"
    static let REQUEST_METHOD_GET = "GET"
    
    func sendRequest(url: String,  requestMethod: String,  jsonObject: String, completionHandler: @escaping (Any?, Error?) -> () ){
        
        let json_parameters: Parameters = ["json": jsonObject]
        
        if requestMethod == "GET" {
            Alamofire.request(url, method: .get, parameters: json_parameters)
                .validate()
                .responseJSON { response in
                    if let value = response.value {
                        completionHandler(value, response.error)
                    }
            }
        }
        else if requestMethod == "POST" {
            Alamofire.request(url, method: .post, parameters: json_parameters)
                .validate()
                .responseJSON { response in
                    if let value = response.value {
                        completionHandler(value, response.error)
                    }
            }
        }
    }
    
    func load_data(){
        let url = "http://avicolasanjosemx.com.mx/webmin/login/login_auth"
        Alamofire.request(url,
                          method: .get)
            .validate()
            .responseJSON { response in
                //debugPrint(response)
                if let value = response.value {
                    let json = JSON(value)
                    debugPrint(json)
                }
                
        }
    }
}

