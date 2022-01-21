//
//  ArticleVM.swift
//  NYTimes
//
//  Created by melaabd on 1/21/22.
//

import Foundation

struct ArticleVM {
    
    var title: String
    var byline: String
    var publishedDate: String
    var abstract: String
    var thumbnailUrlString: String?
    var imageUrlString: String?
    
    init(article: Article) {
        
        title = article.title ?? ""
        byline = article.byline ?? ""
        publishedDate = article.publishedDate ?? ""
        abstract = article.abstract ?? ""
        let mediaMetaData = article.media?.first?.mediaMetadata
        thumbnailUrlString = mediaMetaData?.filter {$0.format == "Standard Thumbnail"}.first?.url
        imageUrlString = mediaMetaData?.filter{$0.format == "mediumThreeByTwo440"}.first?.url
    }
}
