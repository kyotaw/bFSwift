//
//  Order.swift
//  Pods
//
//  Created by 渡部郷太 on 2/25/17.
//
//

import Foundation


public class Order {
    internal init(productCode: ProductCode, side: Side, price: Double?, size: Double) {
        self.productCode = productCode
        self.side = side
        self.price = price
        self.size = size
    }
    
    internal func valid() throws {
        if let p = self.price {
            if p <= 0.0 {
                throw BFErrorCode.invalidOrderPrice
            }
        }
        if self.size <= 0 {
            throw BFErrorCode.invalidOrderSize
        }
    }
    
    open var priceString: String {
        if let p = self.price {
            return p.description
        } else {
            return ""
        }
        
    }
    open var sizeString: String { get { return self.size.description } }
    
    open var orderType: String {
        if self.price == nil {
            return "MARKET"
        } else {
            return "LIMIT"
        }
    }
    
    public let productCode: ProductCode
    public let side: Side
    public let price: Double?
    public let size: Double
}

public class BtcJpyOrder : Order {
    public init(side: Side, price: Int?, size: Double) {
        super.init(productCode: .btcJpy, side: side, price: price == nil ? nil : Double(price!), size: size)
    }
    
    internal override func valid() throws {
        let size1000 = self.size * 1000
        if size1000 - Double(Int(size1000)) != 0 || self.size <= 0 {
            throw BFErrorCode.invalidOrderSize
        }
    }
    
    open override var sizeString: String {
        get {
            let str = self.size.description
            let pos = str.characters.enumerated().filter{ (index, c) in c == "."}.first?.0
            guard let p = pos else {
                return str
            }
            var end = p + 4
            let len = str.characters.count
            if len < end {
                end = len
            }
            return str.substring(to: str.index(str.startIndex, offsetBy: end))
        }
    }
    
    open override var priceString: String {
        get {
            if let p = self.price {
                return Int(p).description
            } else {
                return ""
            }
        }
    }
}


public class BuyBtcInJpyOrder : BtcJpyOrder {
    public init(price: Int?, size: Double) {
        super.init(side: .buy, price: price, size: size)
    }
}


public class SellBtcForJpyOrder : BtcJpyOrder {
    public init(price: Int?, size: Double) {
        super.init(side: .sell, price: price, size: size)
    }
}
