//
//  Router.swift
//  NYTimes
//
//  Created by melaabd on 20/01/2022.
//

import Foundation

typealias NewsAPICompletion = ((_ news: News?, _ errorMsg:String?) -> Void)?

protocol RequestNews {}

class Router: RequestNews {
    
    var requestCancelStatus = false
    private var task: URLSessionTask?
    
    //MARK: - Cancel all previous tasks
    func cancelTask(){
        requestCancelStatus = true
        task?.cancel()
    }
    
    /**
     Adding here timeout for cancel current task if any case request not getting success or taking too much time because of internet. Default time out is 15 seconds.
     */
    private func requestTimeOut() {
        GCD.onMain(after: 20) { [weak self] in
            self?.task?.resume()
        }
    }
}

extension Router {
    
    /// get photos task
    /// - Parameters:
    ///   - keyword: `String` search keyword
    ///   - page: `Int` next page
    ///   - completionHandler: `PhotosAPICompletion`
    func getNews(section: String, period: Int, completionHandler: NewsAPICompletion) {
        let session = URLSession.shared
        let endPoint = EndPoint.news(section: section, period: period)
        
        //Set timeout for request
        requestTimeOut()
        
        task = session.newsTask(with: endPoint.url, completionHandler: { newsResult, error in
            GCD.onMain {
                completionHandler?(newsResult, error)
            }
        })
        task?.resume()
    }
}

