//
//  ViewController.swift
//  ApiCall
//
//  Created by Kishore B on 11/6/24.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var docDetailsArray: [Doc] = []
    private let articleService: ArticleService = ArticleService()
    private let connectivityManager: ConnectivityService = ConnectivityManager()
    private let articleSorter: ArticleSorter = ArticleSorter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectivityManager.startMonitoring { [weak self] isConnected in
            if !isConnected {
                print("Internet not connected")
                self?.docDetailsArray = self?.articleService.loadFromCache() ?? []
                self?.reloadTableView()
            } else {
                print("Internet connected")
                self?.fetchArticles()
            }
        }
    }
    
    private func fetchArticles() {
        articleService.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                let sortedData = self?.articleSorter.sort(items: data) ?? []
                self?.docDetailsArray = sortedData
                self?.articleService.saveToCache(items: sortedData)
                self?.reloadTableView()
                
            case .failure(let error):
                print("Failed to fetch articles: \(error.localizedDescription)")
            }
        }
    }

    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleDetailsTableViewCell", for: indexPath) as? ArticleDetailsTableViewCell else { return UITableViewCell() }
        let rowData = docDetailsArray[indexPath.row]
        cell.configureData(with: rowData)
        cell.img.downloadImage(from: rowData.multimedia?.first?.url ?? "", placeholder: UIImage(named: "image-not-available"))
        
        return cell
    }
}


