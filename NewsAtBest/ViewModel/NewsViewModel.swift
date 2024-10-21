//
//  NewsViewModel.swift
//  ShortNewsApp
//
//  Created by Vinod Supnekar on 19/10/24.
//
import ShortNewsApp

struct NewsFeedModel {
    
    let title: String
    let description: String
}

final class NewsFeedViewModel {
    
    var model: [NewsFeedModel]?
    let newsLoader : NewsLoader!
    weak var delegate: NewsFeedRefreshDelegate?
    
    var count: Int {
        model?.count ?? 0
    }
    
    init(newsLoader: NewsLoader) {
        self.newsLoader = newsLoader
    }
    
    func getNewsFeed() {
        self.newsLoader.loadNewsFeed { [weak self] result in
            
            guard let self else {
                return
            }
            
            switch result {
            case .success(let feeds):
                self.model = feeds.map{
                    NewsFeedModel(title: $0.title,
                                  description: $0.description)
                }
               
                    if let model = model {
                        Task {
                            await self.delegate?.didRequestFeedRefresh(model)
                    }
                }
            case .failure(let error):
                Task {
                    await self.delegate?.didReceiveError(error)
            }
                break
                
            }
        }
    }
}
