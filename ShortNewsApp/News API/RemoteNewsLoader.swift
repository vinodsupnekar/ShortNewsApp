//
//  RemoteNewsLoader.swift
//  ShortNewsApp
//
//  Created by Vinod Supnekar on 18/10/24.
//

struct RemoteNewsItem: Decodable {
    let source: String
    let title: String
    let description: String
    let publishedDate: String
}

public final class RemoteNewsLoader: NewsLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = NewsLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func loadNewsFeed(completion: @escaping (Result) -> Void) {
        
        client.get(from: url) { [weak self]  result in
            
            guard let self else { return }
            
            switch result {
            case .success((let data, let response)):
                
                let res = self.mapData(data, from: response)
                completion(res)
            
            case .failure(_):
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private struct Root: Decodable {
        let data: [RemoteNewsItem]
    }
    
    private func mapData(_ data: Data, from response: HTTPURLResponse)
    -> RemoteNewsLoader.Result {
        
        do {
            guard response.statusCode == 200 else {
                throw Error.invalidData
            }
            let root = try JSONDecoder().decode(Root.self, from: data)
            
            return .success(root.data.map({ remoteItem in
                NewsFeed(
                    source: remoteItem.source,
                    title: remoteItem.title,
                    description: remoteItem.description,
                    publishedDate: remoteItem.publishedDate)
            }))
            
        } catch _ {
            return .failure(Error.invalidData)
        }
    }
}
