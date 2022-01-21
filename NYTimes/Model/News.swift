//
//  News.swift
//  NYTimes
//
//  Created by melaabd on 20/01/2022.
//

import Foundation

// MARK: - News
struct News: Codable {
    var articles: [Article]?
    
    enum CodingKeys: String, CodingKey {
        case articles = "results"
    }
}

// MARK: - Article
struct Article: Codable {
    var title: String?
    var byline: String?
    var abstract: String?
    var publishedDate: String?
    var media: [ArticleMedia]?
    
    enum CodingKeys: String, CodingKey {
        case title, byline, abstract, media
        case publishedDate = "published_date"
    }
}

struct ArticleMedia: Codable {
    var mediaMetadata: [ArticleMediaMetaData]?

    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
    
    init(mediaMetaData: [ArticleMediaMetaData]) {
        self.mediaMetadata = mediaMetaData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mediaMetadata = try container.decode([ArticleMediaMetaData].self, forKey: .mediaMetadata)
    }
    
    
}

struct ArticleMediaMetaData: Codable {
    var url: String?
    var format: String?
}
