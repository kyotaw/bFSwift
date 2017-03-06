//
//  Error.swift
//  bFSwift
//
//  Created by 渡部郷太 on 2/11/17.
//  Copyright © 2017 watanabe kyota. All rights reserved.
//


public enum BFErrorCode: Int, Error {
    case connectionError = 10
    case cryptionError = 11
    case invalidRequest = 90
    case incalidResponse = 91
    case invalidOrderPrice = 100
    
    case invalidProduct = -100
    case invalidOrderSize = -110
    case orderNotFound = -111
    case emptyRequestBody = -122
    case insufficientFunds = -200
    case invalidSignature = -500
    case unknownError = 0
}


public struct BFError {
    init(errorCode: BFErrorCode = .unknownError, message: String = "") {
        self.errorCode = errorCode
        self.message = message
    }
    public let errorCode: BFErrorCode
    public let message: String
}
