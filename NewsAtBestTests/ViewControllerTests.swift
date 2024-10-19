//
//  NewsAtBestTests.swift
//  NewsAtBestTests
//
//  Created by Vinod Supnekar on 19/10/24.
//

import XCTest
@testable import NewsAtBest
@testable import ShortNewsApp

final class ViewControllerTests: XCTestCase {

    func test_loadNewsFeedActions_requestFeedFromLoader() {
        
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadFeedCallCount, 0)
        
        sut.loadViewIfNeeded()
                
        XCTAssertEqual(loader.loadFeedCallCount, 1)
    }
    
    private func makeSUT() ->
    (sut: ViewController, loader: LoaderSpy) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let sut = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            
        let spyLoader = LoaderSpy()
        let viewModel = NewsFeedViewModel(newsLoader: spyLoader)
        sut.inject(viewModel: viewModel)
        
        return (sut, spyLoader)
    }
}
class LoaderSpy: NewsLoader {
    
    private var feedRequests = [(NewsLoader.Result) -> Void]()

    
    func loadNewsFeed(completion: @escaping (NewsLoader.Result) -> Void) {
        feedRequests.append(completion)
    }
    
    var loadFeedCallCount: Int {
        feedRequests.count
    }
    
    }
}
