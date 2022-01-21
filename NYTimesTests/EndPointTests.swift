//
//  EndPointTests.swift
//  NYTimesTests
//
//  Created by melaabd on 1/21/22.
//

import XCTest
@testable import NYTimes

class EndPointTests: XCTestCase {
    
    func testEndPoint() {
        
        let endpoint = EndPoint.news(section: "all-sections", period: 7)
        XCTAssertEqual(endpoint.url, URL(string: "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=GHcdymda81NGkD5Aq4cdR0Gp1YLSveSV"))
        
    }
}
