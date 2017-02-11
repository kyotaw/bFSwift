//
//  bFSwiftTests.swift
//  bFSwiftTests
//
//  Created by 渡部郷太 on 2/11/17.
//  Copyright © 2017 watanabe kyota. All rights reserved.
//

import XCTest
@testable import bFSwift

class bFSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBoard() {
        let test = self.expectation(description: "board test")
        PublicApi.getBoard(productCode: .btcJpy) { (err, data) in
            XCTAssertNil(err)
            XCTAssertNotNil(data)
            if let d = data {
                print(d)
            }
            test.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testTicker() {
        let test = self.expectation(description: "ticker test")
        PublicApi.getTicker(productCode: .btcJpy) { (err, data) in
            XCTAssertNil(err)
            XCTAssertNotNil(data)
            if let d = data {
                print(d)
            }
            test.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testExcutions() {
        let test = self.expectation(description: "excutions test")
        PublicApi.getExcutions(productCode: .btcJpy, count: 2) { (err, data) in
            XCTAssertNil(err)
            XCTAssertNotNil(data)
            XCTAssertTrue(data?.arrayValue.count == 2)
            if let d = data {
                print(d)
            }
            test.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testHealth() {
        let test = self.expectation(description: "health test")
        PublicApi.getHealth{ (err, data) in
            XCTAssertNil(err)
            XCTAssertNotNil(data)
            if let d = data {
                print(d)
            }
            test.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
}
