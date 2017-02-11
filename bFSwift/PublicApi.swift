//
//  PublicApi.swift
//  bFSwift
//
//  Created by 渡部郷太 on 2/11/17.
//  Copyright © 2017 watanabe kyota. All rights reserved.
//

import SwiftyJSON


public typealias BFCallback = ((_ err: BFError?, _ data: JSON?) -> Void)

public class PublicApi {
    
    static func getBoard(productCode: ProductCode, callback: @escaping BFCallback) {
        PublicResource.getBoard(productCode: productCode, callback: callback)
    }
    
    static func getTicker(productCode: ProductCode, callback: @escaping BFCallback) {
        PublicResource.getTicker(productCode: productCode, callback: callback)
    }
    
    static func getExcutions(productCode: ProductCode, count: Int = 100, callback: @escaping BFCallback) {
        PublicResource.getExcutions(productCode: productCode, count: count, callback: callback)
    }
    
    static func getHealth(callback: @escaping BFCallback) {
        PublicResource.getHealth(callback: callback)
    }
    
}
