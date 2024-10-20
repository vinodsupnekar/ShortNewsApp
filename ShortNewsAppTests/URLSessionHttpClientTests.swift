//
//  URLSessionHttpClientTests.swift
//  ShortNewsApp
//
//  Created by Vinod Supnekar on 19/10/24.
//

import XCTest
@testable import ShortNewsApp

class URLSessionHttpClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_getFromURL_performGetRequestWithURL() {
        
        let url =  URL(string: "http://any-url.com")!
        
        let exp = expectation(description: "call back")

        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url!, url)
            XCTAssertEqual(request.httpMethod!, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url, completion: { _ in })
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK:- Helpers
    
    func makeSUT() -> HTTPClient {
        
        let sut = URLSessionHttpClient()
        trackMemeoryLeaks(sut)
        return sut
    }
    
    func trackMemeoryLeaks(_ instance: AnyObject) {
        
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "instance should have been deallocated")
        }
    }
    
    private class URLProtocolStub: URLProtocol {
        
        private static var stubs: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: NSError?
        }
        
        static func observeRequest(observer : @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func stub(data: Data? , response: URLResponse?, error: NSError? = nil) {
            
            stubs = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
            requestObserver = nil
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stubs = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            
            requestObserver?(request)
            
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        
        override func startLoading() {
                         
            if let data = URLProtocolStub.stubs?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let rsp =  URLProtocolStub.stubs?.response {
                client?.urlProtocol(self, didReceive: rsp, cacheStoragePolicy: .notAllowed)
            }
            
            if let error =  URLProtocolStub.stubs?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {
            
        }
        
    }
}
