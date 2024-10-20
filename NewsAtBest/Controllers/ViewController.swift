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
    
    @MainActor
    func didReceiveError(_ errpr: Error)
}


class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noNetworkConnectionView: UIView!
    
    var viewModel : NewsFeedViewModel?
    var cellModels: [NewsFeedModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableView.automaticDimension
        noNetworkConnectionView.isHidden = true
        refresh()
    }
    
    func inject(viewModel: NewsFeedViewModel) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
    }
    
    private func refresh() {
        
        viewModel?.getNewsFeed()
    }
    
    @IBAction func retryNetwork() {
        viewModel?.getNewsFeed()
    }
}

extension ViewController: NewsFeedRefreshDelegate {
    
    func didReceiveError(_ errpr: any Error) {
        noNetworkConnectionView.isHidden = false
        tableView.isHidden = true
    }
    
    func didRequestFeedRefresh(_ cellModels: [NewsFeedModel]) {
        tableView.isHidden = false
        noNetworkConnectionView.isHidden = true
        self.cellModels = cellModels
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell") as! NewsFeedCell
        
        cell.title.numberOfLines = 0
        cell.descriptionLabel.numberOfLines = 0
        
        if let model = cellModels?[indexPath.row] {
            cell.title.text = model.title
            cell.descriptionLabel.text = model.description
        }
        return cell
    }
    

}

