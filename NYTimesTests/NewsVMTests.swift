//
//  NewsVMTests.swift
//  NYTimesTests
//
//  Created by melaabd on 1/21/22.
//

import XCTest
@testable import NYTimes

class NewsVMTests: XCTestCase {

    var newsVM: NewsVM!
    
    override func setUp() {
        super.setUp()
        
        newsVM = NewsVM()
    }
    
    override func tearDown() {
        
        newsVM = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertNotNil(newsVM, "The view model should not be nil.")

    }
    
    func testFunctionality() {
        
        // Convert NewsJson.json to Data
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "NewsJson", ofType: "json")
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped) else {
            fatalError("Data is nil")
        }
        
        // Provie any Codable struct
        let newsResponse = try! JSONDecoder().decode(News.self, from: data)
        
        XCTAssertNotNil(newsResponse.articles)
        XCTAssertEqual(newsResponse.articles.first?.title, "Melatonin Isn’t a Sleeping Pill. Here’s How to Use It.")
        
        newsVM.prepareDataSource(articles: Array(newsResponse.articles))
        XCTAssertNotNil(newsVM.articlesCellVMs)
        
        let abstract = newsVM.articlesCellVMs?.first?.abstract
        XCTAssertNotNil(abstract)
        XCTAssertEqual(abstract, "The “vampire hormone” can act like a dose of sunset, tricking your body into feeling like it’s time to sleep.")
        
    }

}
