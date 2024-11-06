//
//  ApiManager.swift
//  ApiCall
//
//  Created by Kishore B on 11/6/24.
//

import Foundation
import CoreData
import Network

// MARK: - APIError Enum
enum APIError: Error {
    case invalidURL
    case decodingError
    case networkError(String)
    case unknownError
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .decodingError:
            return "Decoding error."
        case .networkError(let message):
            return "Network error: \(message)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

// MARK: - HTTPMethod Enum
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - APIManagerProtocol
protocol APIManagerProtocol {
    func request<T: Decodable>(urlString: String, method: HTTPMethod, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
}

// MARK: - ApiManager
class ApiManager: APIManagerProtocol {
    
    static let shared = ApiManager() // Singleton instance
    
    private init() {}
    
    func request<T: Decodable>(urlString: String, method: HTTPMethod, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))

            }
        }.resume()
    }
}
