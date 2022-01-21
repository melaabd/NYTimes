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
        if let localData = DBManager.shared.fetchData() {
            prepareDataSource(articles: Array(localData.articles))
            getNews(showIndicator: false)
        } else {
            getNews()
        }
    }
    
    /// search for photos by inout keyword
    /// - Parameter text: `String`
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
    
    /// handle data in viewmodel
    /// - Parameter photos: `Photo` Model
    func prepareDataSource(articles: [Article]) {
        articlesCellVMs = articles.map{ArticleVM(article: $0)}
        bindingDelegate?.reloadData()
    }
}
