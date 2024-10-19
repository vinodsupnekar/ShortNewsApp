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
    
    
    func test_loadNewsFeedCompletion_rendersSuccessfullyLoadedFeed() {
        
        let image0 = makeNewsFeed(source: "aas", title: "assasas", description: "wewesd sdsd", publishedDate: "Thu, 17 Oct 2024 20:35:05 -0400")
                
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfRenderedNewsFeed(), 0)
        loader.completeFeedLoading(with: [image0], at: 0)
        
        XCTAssertEqual(sut.numberOfRenderedNewsFeed(), 1)

        assertThat(sut, hasViewConfiguredFor: image0, at: 0)
    }
    
    private func makeNewsFeed(source: String, title: String, description: String, publishedDate: String) -> NewsFeed {
        
        NewsFeed(source: source,
                 title: title,
                 description: description,
                 publishedDate: publishedDate)
        
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
    
    func assertThat(_ sut: ViewController, hasViewConfiguredFor news: NewsFeed, at index: Int, file: StaticString = #file, line: UInt = #line) {
        
        let view = sut.newsFeedView(at: index)
        
        guard let cell = view as? NewsFeedCell else {
                    return XCTFail("Expected \(NewsFeedCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        
        XCTAssertEqual(cell.title.text, news.title, "Expected title text to be \(String(describing: news.title)) for view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.descriptionLabel.text, news.description, "Expected description text to be \(String(describing: news.description)) for view at index (\(index)", file: file, line: line)
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
    
    func completeFeedLoading(with feed: [NewsFeed] = [], at index: Int = 0) {
        feedRequests[index](.success(feed))
    }
}


extension ViewController {
    
    func numberOfRenderedNewsFeed() -> Int {
        
        return tableView.numberOfRows(inSection: 0)
    }
    
    func newsFeedView(at row:Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: 0)
        
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    
}
