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
    
    
    /// search for photos by inout keyword
    /// - Parameter text: `String`
    func getNews(section:String = "all-sections", period:Int = 7 ) {
        showLoading?()
        if router == nil {
            router = Router()
        }
        router?.getNews(section: section, period: period) { [weak self] news, errorMsg in
            self?.hideLoading?()
            guard errorMsg == nil else {
                guard self?.router?.requestCancelStatus == false else { return }
                self?.bindingDelegate?.notifyFailure(msg: errorMsg!)
                return
            }
            guard let articles = news?.articles else { return }
            self?.prepareDataSource(articles: articles)
        }
    }
    
    /// handle data in viewmodel
    /// - Parameter photos: `Photo` Model
    func prepareDataSource(articles: [Article]) {
        articlesCellVMs = articles.map{ArticleVM(article: $0)}
        bindingDelegate?.reloadData()
    }
}
