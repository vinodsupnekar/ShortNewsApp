//
//  NewsFeed.swift
//  ShortNewsApp
//
//  Created by Vinod Supnekar on 17/10/24.
//

public struct NewsFeed: Equatable {
    public let source: String
    public let title: String
    public let desctiption: String
    public let punlishedDate: String
    
    public init(source: String, title: String, desctiption: String, punlishedDate: String) {
        self.source = source
        self.title = title
        self.desctiption = desctiption
        self.punlishedDate = punlishedDate
    }
}
