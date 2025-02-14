//
//  NewsLoader.swift
//  ShortNewsApp
//
//  Created by Vinod Supnekar on 17/10/24.
//

public protocol NewsLoader {
    
    typealias Result = Swift.Result<[NewsFeed], Error>
    
    func loadNewsFeed(completion: @escaping(Result) -> Void)
}
