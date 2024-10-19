//
//  NewsFeed.swift
//  ShortNewsApp
//
//  Created by Vinod Supnekar on 17/10/24.
//

public struct NewsFeed: Equatable {
    public let source: String
    public let title: String
    public let description: String
    public let publishedDate: String
    
    public init(source: String, title: String, description: String, publishedDate: String) {
        self.source = source
        self.title = title
        self.description = description
        self.publishedDate = publishedDate
    }
}
