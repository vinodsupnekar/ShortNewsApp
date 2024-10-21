//
//  UTLSessionHttpClient.swift
//  ShortNewsApp
//
//  Created by Vinod Supnekar on 19/10/24.
//

public final class URLSessionHttpClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        
        self.session.dataTask(with: url) { data, response, error in

            if let error = error {
                
                completion(.failure(error))
            } else if let data = data,
                      let response = response as? HTTPURLResponse {
                
                completion(.success((data, response)))
            } else if let error = error {
                
                completion(.failure(error))
            }
        }.resume()
    }
    
}
