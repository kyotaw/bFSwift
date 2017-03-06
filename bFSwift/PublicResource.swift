//
//  PublicResource.swift
//  bFSwift
//
//  Created by 渡部郷太 on 2/11/17.
//  Copyright © 2017 watanabe kyota. All rights reserved.
//

import SwiftyJSON
import Alamofire


internal class PublicResource : Resource {
    
    static func getBoard(productCode: ProductCode, callback: @escaping BFCallback) {
        let url = [PublicResource.endPointUrl, "board"].joined(separator: "/")
        let params = [
            "product_code": productCode.rawValue,
        ]
        let queryUrl = self.addQueryParameters(url: url, params: params)
        let headers = Dictionary<String, String>()
        self.get(queryUrl, headers: headers, callback: callback)
    }
    
    static func getTicker(productCode: ProductCode, callback: @escaping BFCallback) {
        let url = [PublicResource.endPointUrl, "ticker"].joined(separator: "/")
        let params = [
            "product_code": productCode.rawValue,
            ]
        let queryUrl = self.addQueryParameters(url: url, params: params)
        let headers = Dictionary<String, String>()
        self.get(queryUrl, headers: headers, callback: callback)
    }
    
    static func getExcutions(productCode: ProductCode, count: Int, callback: @escaping BFCallback) {
        let url = [PublicResource.endPointUrl, "executions"].joined(separator: "/")
        let params = [
            "product_code": productCode.rawValue,
            "count": count.description
            ]
        let queryUrl = self.addQueryParameters(url: url, params: params)
        let headers = Dictionary<String, String>()
        self.get(queryUrl, headers: headers) { err, data in
            if let message = data?.dictionary?["Message"]?.string {
                callback(BFError(errorCode: .invalidRequest, message: message), nil)
            } else {
                callback(nil, data)
            }
        }
    }
    
    static func getHealth(callback: @escaping BFCallback) {
        let url = [PublicResource.endPointUrl, "gethealth"].joined(separator: "/")
        let headers = Dictionary<String, String>()
        self.get(url, headers: headers, callback: callback)
    }
    
    
    static let endPointUrl = "https://api.bitflyer.jp/v1"
}
