//
//  Board.swift
//  bFSwift
//
//  Created by 渡部郷太 on 2/11/17.
//  Copyright © 2017 watanabe kyota. All rights reserved.
//


enum QuoteSide {
    case bid
    case ask
}


struct Quote {
    let side: QuoteSide
    let price: Double
    let size: Double
}


struct Board {
    let midPrice: Double
    let bids: [Quote]
    let asks: [Quote]
}
