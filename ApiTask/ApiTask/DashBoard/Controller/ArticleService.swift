//
//  ArticleService.swift
//  ApiTask
//
//  Created by Kishore B on 11/7/24.
//

import Foundation

protocol DataSource {
    associatedtype Item
    func fetchData(completion: @escaping (Result<[Item], Error>) -> Void)
    func loadFromCache() -> [Item]
    func saveToCache(items: [Item])
}

protocol ConnectivityService {
    func startMonitoring(completion: @escaping (Bool) -> Void)
}

protocol Sortable {
    associatedtype T
    func sort(items: [T]) -> [T]
}

// MARK: - ArticleService

final class ArticleService: DataSource {
    typealias Item = Doc

    func fetchData(completion: @escaping (Result<[Doc], Error>) -> Void) {
        let urlString = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM"
        ApiManager.shared.request(urlString: urlString, method: .get, responseType: DocResponseModel.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data.response?.docs ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadFromCache() -> [Doc] {
        return CoreDataManager.shared.fetchArticles().compactMap {
            Doc(abstract: $0.description ?? "",
                multimedia: [Multimedia(url: String(data: $0.imageUrl ?? Data(), encoding: .utf8) ?? "")],
                headline: Headline(main: $0.title ?? ""),
                pubDate: $0.pubDate ?? "")
        }
    }

    func saveToCache(items: [Doc]) {
        items.forEach { CoreDataManager.shared.saveArticle($0) }
    }
}

// MARK: - ArticleSorter

struct ArticleSorter: Sortable {
    typealias T = Doc

    func sort(items: [Doc]) -> [Doc] {
        return items.sorted {
            let date1 = formatDate($0.pubDate ?? "")
            let date2 = formatDate($1.pubDate ?? "")
            return date1 > date2
        }
    }

    private func formatDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateString) ?? Date.distantPast
    }
}
