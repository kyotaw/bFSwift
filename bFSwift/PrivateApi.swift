//
//  PrivateApi.swift
//  Pods
//
//  Created by 渡部郷太 on 2/19/17.
//
//

import Foundation

public struct ApiKeys {
    internal init(apiKey: String, secretKey: String) {
        self.apiKey = apiKey
        self.secretKey = secretKey
    }
    
    internal let apiKey: String
    internal let secretKey: String
}

public enum PermissionType : String {
    case getboard = "/v1/getboard"
    case board = "/v1/board"
    case getticker = "/v1/getticker"
    case ticker = "/v1/ticker"
    case getchats = "/v1/getchats"
    case gethealth = "/v1/gethealth"
    case getexecutions = "/v1/getexecutions"
    case executions = "/v1/executions"
    
    case getpermissions = "/v1/me/getpermissions"
    case getbalance = "/v1/me/getbalance"
    case getcollateral = "/v1/me/getcollateral"
    case getaddresses = "/v1/me/getaddresses"
    case getcoinins = "/v1/me/getcoinins"
    case sendcoin = "/v1/me/sendcoin"
    case getcoinouts = "/v1/me/getcoinouts"
    case getbankaccounts = "/v1/me/getbankaccounts"
    case getdeposits = "/v1/me/getdeposits"
    case withdraw = "/v1/me/withdraw"
    case getwithdrawals = "/v1/me/getwithdrawals"
    case sendchildorder = "/v1/me/sendchildorder"
    case cancelchildorder = "/v1/me/cancelchildorder"
    case sendparentorder = "/v1/me/sendparentorder"
    case cancelparentorder = "/v1/me/cancelparentorder"
    case cancelallchildorders = "/v1/me/cancelallchildorders"
    case getchildorders = "/v1/me/getchildorders"
    case getparentorders = "/v1/me/getparentorders"
    case getparentorder = "/v1/me/getparentorder"
    case privgetexecutions = "/v1/me/getexecutions"
    case privexecutions = "/v1/me/executions"
    case getpositions = "/v1/me/getpositions"
}

public enum ChildOrderState : String {
    case active = "ACTIVE"
    case completed = "COMPLETED"
    case canceled = "CANCELED"
    case expired = "EXPIRED"
    case rejected = "REJECTED"
}

public enum Side : String {
    case buy = "BUY"
    case sell = "SELL"
}


public class PrivateApi {
    
    public init(apiKey: String, secretKey: String) {
        self.keys = ApiKeys(apiKey: apiKey, secretKey: secretKey)
    }
    
    public func getPermissions(_ callback: @escaping BFCallback) {
        PrivateResource.getPermissions(apiKeys: self.keys, callback)
    }
    
    public func hasPermissions(permissions: [PermissionType], callback: @escaping (BFError?, [PermissionType]) -> Void) {
        PrivateResource.hasPermissions(apiKeys: self.keys, permissions: permissions, callback: callback)
    }
    
    public func getBalance(_ callback: @escaping BFCallback) {
        PrivateResource.getBalance(apiKeys: self.keys, callback: callback)
    }
    
    public func getTradingCommission(productCode: ProductCode, _ callback: @escaping BFCallback) {
        PrivateResource.getTradingCommission(apiKeys: self.keys, productCode: productCode, callback)
    }
    
    public func getChildOrders(productCode: ProductCode, childOrderState: ChildOrderState, count: Int = 100, _ callback: @escaping BFCallback) {
        PrivateResource.getChildOrders(apiKeys: self.keys, productCode: productCode, childOrderState: childOrderState, count: count, callback)
    }
    
    public func sendChildOrder(order: Order, _ callback: @escaping BFCallback) {
        PrivateResource.sendChildOrder(apiKeys: self.keys, order: order, callback)
    }
    
    public func cancelChildOrder(productCode: ProductCode, childOrderAcceptanceId: String, _ callback: @escaping BFCallback) {
        PrivateResource.cancelChildOrder(apiKeys: self.keys, productCode: productCode, childOrderAcceptanceId: childOrderAcceptanceId, callback)
    }
    
    public var apiKey: String {
        get { return self.keys.apiKey }
    }
    
    public var secretKey: String {
        get { return self.keys.secretKey }
    }

    fileprivate let keys: ApiKeys
}
