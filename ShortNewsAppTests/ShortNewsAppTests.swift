//
//  ShortNewsAppTests.swift
//  ShortNewsAppTests
//
//  Created by Vinod Supnekar on 17/10/24.
//

import XCTest
import ShortNewsApp

class ShortNewsAppTests: XCTestCase {

   func test_init_doesNotRequestDataFromURL(){

       let url = URL(string: "https://a-given-url.com")!
       let (_, client) = makeSUT(url: url)
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_load_requestDataFromURL() {
        
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.loadNewsFeed{ _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.loadNewsFeed{ _ in }
        sut.loadNewsFeed{ _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    
    func test_load_deliversErrorOnClientError() {
        
        let (sut, client) = makeSUT()
       
        let expectedResult = RemoteNewsLoader.Result.failure(RemoteNewsLoader.Error.connectivity)
        
        expect(sut, expectedResult: expectedResult) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400]

        let expectedResult = RemoteNewsLoader.Result.failure(RemoteNewsLoader.Error.invalidData)

        samples.enumerated().forEach { index, code in
            
            expect(sut, expectedResult: expectedResult) {
                let json = ["data": []]
                let jsonData = try! JSONSerialization.data(withJSONObject: json)
                client.complete(withStatusCode: code, data: jsonData, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HttpResponseWithInvalidJSON() {
        
        let (sut, client) = makeSUT()
        
        let expectedResult = RemoteNewsLoader.Result.failure(RemoteNewsLoader.Error.invalidData)
        
        expect(sut, expectedResult: expectedResult) {
            let json = ["invalid data"]
            let jsonData = try! JSONSerialization.data(withJSONObject: json)
            client.complete(withStatusCode: 200, data: jsonData)
        }
    }
    
    func test_load_deliversNoItemson200HTTPResponseWithEmptyJsonList() {
        
        let (sut, client) = makeSUT()
        
        expect(sut, expectedResult: .success([])) {
            
            client.complete(withStatusCode: 200, data: makeItemJSON([]))
        }
    }
    
    func test_load_deliversItemson200HTTPResponseWithJsonList() {
        let (sut, client) = makeSUT()
        
        let obj = NewsFeed(
            source: "Fox News",
            title: "LAURA INGRAHAM: Kamala Harris missed out on a 'huge opportunity'",
            description: "Fox News host Laura Ingraham says",
            publishedDate: "Thu, 17 Oct 2024 20:35:05 -0400")
        
        let item = [obj]
        
        let json = item.map {
            return ["source": $0.source,
                    "title": $0.title,
                    "description": $0.description,
                    "publishedDate": $0.publishedDate
            ]
        }
        let item1 = ["data": json] as [String : [Any]]
        
        expect(sut, expectedResult: .success([obj])) {
         
            let jsonData = try! JSONSerialization.data(withJSONObject: item1)
            client.complete(withStatusCode: 200, data: jsonData)
            
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTHasBeenDeallocated() {
        
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteNewsLoader? = RemoteNewsLoader(url: url, client: client)
       
        
        var capturedResult = [RemoteNewsLoader.Result]()
        
        sut?.loadNewsFeed { result in
            capturedResult.append(result)
        }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemJSON([]))
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    private func makeItemJSON(_ itemsList: [[String: Any]]) -> Data {
        
        let json = ["data": itemsList]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteNewsLoader ,expectedResult: RemoteNewsLoader.Result, on action: () -> Void) {
                
        let expectation = expectation(description: "wait for completion")

        sut.loadNewsFeed { receivedResult in
            
            switch(receivedResult, expectedResult) {
            case let(.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems)
                
            case let(.failure(expectedError as RemoteNewsLoader.Error), .failure(receivedError as RemoteNewsLoader.Error)):
                XCTAssertEqual(expectedError, receivedError)
             default:
                XCTFail("Expected result \(expectedResult) but got \(receivedResult)")
            }
            expectation.fulfill()
        }
        action()
        wait(for: [expectation], timeout: 3.0)
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (RemoteNewsLoader, HTTPClientSpy) {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteNewsLoader(url: url, client: client)
        
        return (sut, client)
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
