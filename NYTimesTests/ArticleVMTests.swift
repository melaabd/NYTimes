//
//  ArticleVMTests.swift
//  NYTimesTests
//
//  Created by melaabd on 1/21/22.
//

import XCTest
@testable import NYTimes

class ArticleVMTests: XCTestCase {

    var articleVM: ArticleVM!
    
    override func setUp() {
        super.setUp()
        
        // Convert NewsJson.json to Data
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "NewsJson", ofType: "json")
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped) else {
            fatalError("Data is nil")
        }
        
        // Provie any Codable struct
        let newsResponse = try! JSONDecoder().decode(News.self, from: data)
        articleVM = ArticleVM(article: newsResponse.articles.first!)
    }
    
    override func tearDown() {
        
        articleVM = nil
        super.tearDown()
    }
    
    func testInitialization() {
        
        XCTAssertNotNil(articleVM, "The view model should not be nil.")
    }
    
    func testFunctionality() {
        
        XCTAssertEqual(articleVM.title, "Melatonin Isn’t a Sleeping Pill. Here’s How to Use It.")
        XCTAssertEqual(articleVM.abstract, "The “vampire hormone” can act like a dose of sunset, tricking your body into feeling like it’s time to sleep.")
        XCTAssertEqual(articleVM.byline, "By Amelia Nierenberg")
        XCTAssertEqual(articleVM.publishedDate, "2022-01-11")
        XCTAssertEqual(articleVM.thumbnailUrlString, "https://static01.nyt.com/images/2022/01/18/well/21Well-Melatonin/21Well-Melatonin-thumbStandard.jpg")
        XCTAssertEqual(articleVM.imageUrlString, "https://static01.nyt.com/images/2022/01/18/well/21Well-Melatonin/21Well-Melatonin-mediumThreeByTwo440.jpg")
        
    }
}
