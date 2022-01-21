//
//  GCDTests.swift
//  NYTimesTests
//
//  Created by melaabd on 1/21/22.
//

import XCTest
@testable import NYTimes

class GCDTests: XCTestCase {
    
    func testThreads() {
        
        GCD.onMain {
            XCTAssertTrue(Thread.current.isMainThread)
        }
        
        let downloadQueue = DispatchQueue(label: "Images cache", qos: DispatchQoS.background)
        
        downloadQueue.async(execute: { () -> Void in
            XCTAssertFalse(Thread.current.isMainThread)
        })
        
    }
}
