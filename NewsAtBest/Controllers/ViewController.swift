//
//  ViewController.swift
//  NewsAtBest
//
//  Created by Vinod Supnekar on 19/10/24.
//

import UIKit
import ShortNewsApp

protocol NewsFeedRefreshDelegate: AnyObject {
    @MainActor
    func didRequestFeedRefresh(_ cellModel: [NewsFeedModel])
}


class ViewController: UIViewController, NewsFeedRefreshDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    func didRequestFeedRefresh(_ cellModels: [NewsFeedModel]) {
        self.cellModels = cellModels
        tableView.reloadData()
    }
    
    var viewModel : NewsFeedViewModel?
    var cellModels: [NewsFeedModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        tableView.estimatedRowHeight = 100 
        tableView.rowHeight = UITableView.automaticDimension
        refresh()
    }
    
    func inject(viewModel: NewsFeedViewModel) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
    }
    
    private func refresh() {
        
        viewModel?.getNewsFeed()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell") as! NewsFeedCell
        if let model = cellModels?[indexPath.row] {
            cell.title.text = model.title
            cell.descriptionLabel.text = model.description
        }
        return cell
    }
    

}

