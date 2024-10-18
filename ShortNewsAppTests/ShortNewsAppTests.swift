//
//  ShortNewsAppTests.swift
//  ShortNewsAppTests
//
//  Created by Vinod Supnekar on 17/10/24.
//

import XCTest
@testable import ShortNewsApp

class ShortNewsAppTests: XCTestCase {

   func test_init_doesNotRequestDataFromURL() async throws {

       let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteNewsLoader(url: url, client: client)
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    class HTTPClientSpy: HTTPClient {
        
        private var messages = [(url: URL, completion:  (HTTPClient.Result) -> Void)]()
        
        var requestedURLs: [URL] {
            
            return messages.map {
                $0.url
            }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error :Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            
            messages[index].completion(.success((data, response)))
        }
        
    }

}
