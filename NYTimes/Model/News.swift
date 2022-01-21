//
//  News.swift
//  NYTimes
//
//  Created by melaabd on 20/01/2022.
//

import Foundation
import RealmSwift

// MARK: - News
class News: Object, Codable {
    
    @objc dynamic var id = 0
    let articles = List<Article>()
    
    enum CodingKeys: String, CodingKey {
        case articles = "results"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let articlesArray = try container.decode([Article].self, forKey: .articles)
            articles.append(objectsIn: articlesArray)
        } catch let jsonError as NSError {
            print("parsing issue with News Model: - \(jsonError.localizedDescription)")
        }
    }
}

// MARK: - Article
class Article: Object, Codable {
    
    @objc dynamic var title: String?
    @objc dynamic var byline: String?
    @objc dynamic var abstract: String?
    @objc dynamic var publishedDate: String?
    let media = List<ArticleMedia>()
    
    enum CodingKeys: String, CodingKey {
        case title, byline, abstract, media
        case publishedDate = "published_date"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode(String.self, forKey: .title)
            byline = try container.decode(String.self, forKey: .byline)
            abstract = try container.decode(String.self, forKey: .abstract)
            publishedDate = try container.decode(String.self, forKey: .publishedDate)
            let mediaArray = try container.decode([ArticleMedia].self, forKey: .media)
            media.append(objectsIn: mediaArray)
        } catch let jsonError as NSError {
            print("parsing issue with Article Model: - \(jsonError.localizedDescription)")
        }
    }
    
}

class ArticleMedia: Object, Codable {
    var mediaMetadata = List<ArticleMediaMetaData>()
    
    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let mediaMetadataArray = try container.decode([ArticleMediaMetaData].self, forKey: .mediaMetadata)
            mediaMetadata.append(objectsIn: mediaMetadataArray)
        } catch let jsonError as NSError {
            print("parsing issue with ArticleMedia Model: - \(jsonError.localizedDescription)")
        }
    }
    
}

class ArticleMediaMetaData: Object, Codable {
    @objc dynamic var url: String?
    @objc dynamic var format: String?
    
    enum CodingKeys: String, CodingKey {
        case url, format
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            url = try container.decode(String.self, forKey: .url)
            format = try container.decode(String.self, forKey: .format)
        } catch let jsonError as NSError {
            print("parsing issue with ArticleMediaMetaData Model: - \(jsonError.localizedDescription)")
        }
    }
}
