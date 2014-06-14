//
//  TClone_Tests.swift
//  TClone Tests
//
//  Created by nma on 2014-06-14.
//
//

import XCTest


class TClone_Tests: XCTestCase {
    
    //Put setup code here. This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let playerBoard = Board()
        let field = Field(name: "MainField", tileSize: 32, height: 640, width: 320, board: playerBoard)
        let addLine = AddLine()        

        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
