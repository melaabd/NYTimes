//
//  NewsVM.swift
//  NYTimes
//
//  Created by melaabd on 1/21/22.
//

import Foundation


typealias CompletionVoid = (()->Void)

class NewsVM {
    
    weak var bindingDelegate: BindingVVMDelegate?
    
    var articlesCellVMs:[ArticleVM]?
    var showLoading: CompletionVoid?
    var hideLoading: CompletionVoid?
    private var router:Router?
    
    func loadNewsData() {
        
        // check for placeholder data in DB
        if let localData = DBManager.shared.fetchData() {
            prepareDataSource(articles: Array(localData.articles))
            getNews(showIndicator: false)
        } else {
            getNews()
        }
    }
    
    /// load news for particular section and period
    /// - Parameter showIndicator: `Bool`
    /// - Parameter section: `String`
    /// - Parameter period: `Int`
    func getNews(showIndicator:Bool = true, section:String = "all-sections", period:Int = 7 ) {
        showIndicator ? showLoading?() : nil
        if router == nil {
            router = Router()
        }
        router?.getNews(section: section, period: period) { [weak self] news, errorMsg in
            showIndicator ? self?.hideLoading?() : nil
            guard errorMsg == nil else {
                guard self?.router?.requestCancelStatus == false else { return }
                self?.bindingDelegate?.notifyFailure(msg: errorMsg!)
                return
            }
            guard let articles = news?.articles else { return }
            self?.prepareDataSource(articles: Array(articles))
            GCD.onMain {
                DBManager.shared.replaceData(news: news!)
            }
        }
    }
    
    /// handle data in viewmodels
    /// - Parameter articles: `[Article]`
    func prepareDataSource(articles: [Article]) {
        articlesCellVMs = articles.map{ArticleVM(article: $0)}
        bindingDelegate?.reloadData()
    }
}
