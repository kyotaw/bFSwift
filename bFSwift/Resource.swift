//
//  Resource.swift
//  Pods
//
//  Created by 渡部郷太 on 2/19/17.
//
//

import Foundation

import CryptoSwift
import Alamofire
import SwiftyJSON


class Resource {
    
    static func get(_ url: String, headers: Dictionary<String, String>, callback: @escaping ((_ err: BFError?, _ res: JSON?) -> Void)) {
        Alamofire.request(url, method: .get, headers: headers).responseJSON() { response in
            switch response.result {
            case .failure(_):
                callback(BFError(errorCode: .connectionError), nil)
                return
            case .success:
                let data = JSON(response.result.value! as AnyObject)
                //print(data)
                if let status = data.dictionary?["status"]?.int {
                    if let code = BFErrorCode(rawValue: status) {
                        callback(BFError(errorCode: code), nil)
                    } else {
                        callback(BFError(), nil)
                    }
                } else {
                    callback(nil, data)
                }
            }
        }
    }
    
    static func post(
        url: String,
        params: Dictionary<String, String>,
        headers: Dictionary<String, String>,
        callback: @escaping ((_ err: BFError?, _ res: JSON?) -> Void)) {
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default
            )) {
                response in
                
                switch response.result {
                case .failure(_):
                    callback(BFError(errorCode: .connectionError), nil)
                    return
                case .success:
                    let data = JSON(response.result.value! as AnyObject)
                    if let status = data["status"].int {
                        print(data)
                        if let errorCode = BFErrorCode(rawValue: status) {
                            callback(BFError(errorCode: errorCode), nil)
                        } else {
                            callback(BFError(), nil)
                        }
                    } else {
                        callback(nil, data)
                    }
                    
                    /*
                     if status == 0 {
                     let message = data["error"].stringValue
                     switch message {
                     default:
                     callback(ZSError(errorType: .PROCESSING_ERROR, message: message), data)
                     }
                     } else {
                     callback(nil, data)
                     }
                     */
                }
        }
    }
    
    static func addQueryParameters(url: String, params: [String:String]) -> String {
        guard params.count > 0 else {
            return url
        }
        var queryUrl = url + "?"
        for (key, val) in params {
            queryUrl += "\(key)=\(val)&"
        }
        queryUrl.characters.removeLast()
        return queryUrl
    }
}
