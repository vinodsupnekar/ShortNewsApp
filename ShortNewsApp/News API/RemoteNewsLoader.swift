//
//  RemoteNewsLoader.swift
//  ShortNewsApp
//
//  Created by Vinod Supnekar on 18/10/24.
//

public final class RemoteNewsLoader: NewsLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public typealias Result = NewsLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func loadNewsFeed(completion: @escaping (Result) -> Void) {
        
    }
}
