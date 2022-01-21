//
//  EndPoint.swift
//  NYTimes
//
//  Created by melaabd on 20/01/2022.
//

import Foundation

enum EndPoint {
    
    /// static property for base url
    static let baseUrl = "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/"
    
    /// static property for apiKey
    static let apiKey = "GHcdymda81NGkD5Aq4cdR0Gp1YLSveSV"
    
    case news(section:String, period:Int)
    
    private var keyPath: String {
       return "api-key=" + EndPoint.apiKey
    }
    /// return router's path `String`
    private var path : String {
        switch self {
        case .news(let section, let period):
            return "\(section)/\(period).json?"
        }
    }
    
    /// url for the endPoint
    var url:URL {
        guard let url = URL(string: EndPoint.baseUrl + path + keyPath ) else {fatalError("Invalid Base URL.")}
        return url
    }
}
