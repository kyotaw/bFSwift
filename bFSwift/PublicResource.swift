//
//  PublicResource.swift
//  bFSwift
//
//  Created by 渡部郷太 on 2/11/17.
//  Copyright © 2017 watanabe kyota. All rights reserved.
//

import SwiftyJSON
import Alamofire


internal class PublicResource {
    
    static func getBoard(productCode: ProductCode, callback: @escaping BFCallback) {
        let url = [PublicResource.url, "board"].joined(separator: "/")
        let params = [
            "product_code": productCode.rawValue,
        ]
        let queryUrl = self.addQueryParameters(url: url, params: params)
        self.get(queryUrl, callback: callback)
    }
    
    static func getTicker(productCode: ProductCode, callback: @escaping BFCallback) {
        let url = [PublicResource.url, "ticker"].joined(separator: "/")
        let params = [
            "product_code": productCode.rawValue,
            ]
        let queryUrl = self.addQueryParameters(url: url, params: params)
        self.get(queryUrl, callback: callback)
    }
    
    static func getExcutions(productCode: ProductCode, count: Int, callback: @escaping BFCallback) {
        let url = [PublicResource.url, "executions"].joined(separator: "/")
        let params = [
            "product_code": productCode.rawValue,
            "count": count.description
            ]
        let queryUrl = self.addQueryParameters(url: url, params: params)
        self.get(queryUrl) { err, data in
            if let message = data?.dictionary?["Message"]?.string {
                callback(BFError(errorCode: .invalidRequest, message: message), nil)
            } else {
                callback(nil, data)
            }
        }
    }
    
    static func getHealth(callback: @escaping BFCallback) {
        let url = [PublicResource.url, "gethealth"].joined(separator: "/")
        self.get(url, callback: callback)
    }
    
    static fileprivate func addQueryParameters(url: String, params: [String:String]) -> String {
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
    
    static fileprivate func get(_ url: String, callback: @escaping ((_ err: BFError?, _ res: JSON?) -> Void)) {
        Alamofire.request(url).responseJSON() { response in
            switch response.result {
            case .failure(_):
                callback(BFError(errorCode: .connectionError), nil)
                return
            case .success:
                let data = JSON(response.result.value! as AnyObject)
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
    
    static let url = "https://api.bitflyer.jp/v1"
}
