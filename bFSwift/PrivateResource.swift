//
//  PrivateResource.swift
//  Pods
//
//  Created by 渡部郷太 on 2/19/17.
//
//

import Foundation

import SwiftyJSON
import CryptoSwift
import Alamofire


private class URLtoEncoding : URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let URL = Foundation.URL(string: PrivateResource.endPointUrl)!
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        return request
    }
}

private func makeBodyString(_ params: Dictionary<String, String>) -> String {
    let encoding = Alamofire.JSONEncoding.default
    do {
        let request = try encoding.encode(URLtoEncoding(), with: params)
        return NSString(data: request.httpBody!, encoding:String.Encoding.utf8.rawValue)! as String
    } catch {
        return ""
    }
}


class PrivateResource : Resource {
    
    static func getPermissions(apiKeys: ApiKeys, _ callback: @escaping BFCallback) {
        do {
            let path = "/" + PrivateResource.version + "/me/getpermissions"
            let url = PrivateResource.endPointUrl + path
            let params = Dictionary<String, String>()
            let headers = try self.makeHeaders(params: params, path: path, method: "GET", apiKeys: apiKeys)
            self.get(url, headers: headers, callback: callback)
        } catch BFErrorCode.cryptionError {
            callback(BFError(errorCode: .cryptionError), nil)
        } catch {
            callback(BFError(errorCode: .unknownError), nil)
        }
    }
    
    static func hasPermissions(apiKeys: ApiKeys, permissions: [PermissionType], callback: @escaping (BFError?, [PermissionType]) -> Void) {
        PrivateResource.getPermissions(apiKeys: apiKeys) { (err, data) in
            if err != nil {
                callback(err, permissions)
                return
            }
            var perms = [PermissionType]()
            for permData in data!.arrayValue {
                guard let permType = PermissionType(rawValue: permData.stringValue) else {
                    continue
                }
                perms.append(permType)
            }
            
            var noPerms = [PermissionType]()
            for targetPerm in permissions {
                if perms.index(of: targetPerm) == nil {
                    noPerms.append(targetPerm)
                }
            }
            
            callback(err, noPerms)
        }
    }
    
    static func getBalance(apiKeys: ApiKeys, callback: @escaping BFCallback) {
        do {
            let path = "/" + PrivateResource.version + "/me/getbalance"
            let url = PrivateResource.endPointUrl + path
            let params = Dictionary<String, String>()
            let headers = try self.makeHeaders(params: params, path: path, method: "GET", apiKeys: apiKeys)
            self.get(url, headers: headers, callback: callback)
        } catch BFErrorCode.cryptionError {
            callback(BFError(errorCode: .cryptionError), nil)
        } catch {
            callback(BFError(errorCode: .unknownError), nil)
        }
    }
    
    static func getChildOrders(apiKeys: ApiKeys, productCode: ProductCode, childOrderState: ChildOrderState, count: Int, _ callback: @escaping BFCallback) {
        do {
            let path = "/" + PrivateResource.version + "/me/getchildorders"
            let query = [
                "product_code": productCode.rawValue,
                "count": count.description,
                "child_order_state": childOrderState.rawValue,
            ]
            let pathWithQuery = self.addQueryParameters(url: path, params: query)
            let params = Dictionary<String, String>()
            let headers = try self.makeHeaders(params: params, path: pathWithQuery, method: "GET", apiKeys: apiKeys)
            let url = PrivateResource.endPointUrl + pathWithQuery
            self.get(url, headers: headers, callback: callback)
        } catch BFErrorCode.cryptionError {
            callback(BFError(errorCode: .cryptionError), nil)
        } catch {
            callback(BFError(errorCode: .unknownError), nil)
        }
    }
    
    static func sendChildOrder(apiKeys: ApiKeys, order: Order, _ callback: @escaping BFCallback) {
        do {
            let path = "/" + PrivateResource.version + "/me/sendchildorder"
            let url = PrivateResource.endPointUrl + path
            let params = [
                "product_code": order.productCode.rawValue,
                "child_order_type": order.orderType,
                "side": order.side.rawValue,
                "price": order.priceString,
                "size": order.sizeString,
                "time_in_force": "GTC"
            ]
            let headers = try self.makeHeaders(params: params, path: path, method: "POST", apiKeys: apiKeys)
            self.post(url: url, params: params, headers: headers, callback: callback)
        } catch BFErrorCode.cryptionError {
            callback(BFError(errorCode: .cryptionError), nil)
        } catch {
            callback(BFError(errorCode: .unknownError), nil)
        }
    }
    
    static func cancelChildOrder(apiKeys: ApiKeys, productCode: ProductCode, childOrderAcceptanceId: String, _ callback: @escaping BFCallback) {
        do {
            let path = "/" + PrivateResource.version + "/me/cancelchildorder"
            let url = PrivateResource.endPointUrl + path
            let params = [
                "product_code": productCode.rawValue,
                "child_order_acceptance_id": childOrderAcceptanceId,
            ]
            let headers = try self.makeHeaders(params: params, path: path, method: "POST", apiKeys: apiKeys)
            self.post(url: url, params: params, headers: headers, callback: callback)
        } catch BFErrorCode.cryptionError {
            callback(BFError(errorCode: .cryptionError), nil)
        } catch {
            callback(BFError(errorCode: .unknownError), nil)
        }
    }
    
    fileprivate static func makeHeaders(params: Dictionary<String, String>, path: String, method: String, apiKeys: ApiKeys) throws -> Dictionary<String, String> {
        
        let unix = Double(Date().timeIntervalSince1970) * 1000.0
        let timestamp = Int64(unix).description
        
        var headers = [
            "ACCESS-KEY": apiKeys.apiKey,
            "ACCESS-TIMESTAMP": timestamp,
            "Content-Type": "application/json"
        ]
        
        var jsonBody = ""
        if params.count > 0 {
            //let json = try JSONSerialization.data(withJSONObject: params, options: [])
            //jsonBody = NSString(data: json, encoding: String.Encoding.utf8.rawValue)! as String
            jsonBody = makeBodyString(params)
        }
        
        let contents = timestamp + method + path + jsonBody
        
        do {
            let hmac: Array<UInt8> = try HMAC(key: apiKeys.secretKey.utf8.map({$0}), variant: .sha256).authenticate(contents.utf8.map({$0}))
            headers["ACCESS-SIGN"] = hmac.toHexString()
        } catch {
            throw BFErrorCode.cryptionError
        }
        
        return headers
    }
    
    
    
    static let endPointUrl = "https://api.bitflyer.jp"
    static let version = "v1"
}
