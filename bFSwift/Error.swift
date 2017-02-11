//
//  Error.swift
//  bFSwift
//
//  Created by 渡部郷太 on 2/11/17.
//  Copyright © 2017 watanabe kyota. All rights reserved.
//


public enum BFErrorCode: Int {
    case connectionError = 10
    case invalidRequest = 90
    case invalidProduct = -100
    case unknownError = 0
}


public struct BFError {
    init(errorCode: BFErrorCode = .unknownError, message: String = "") {
        self.errorCode = errorCode
        self.message = message
    }
    let errorCode: BFErrorCode
    let message: String
}
