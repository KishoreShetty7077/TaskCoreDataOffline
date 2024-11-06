//
//  Model.swift
//  ApiCall
//
//  Created by Kishore B on 11/6/24.
//

import Foundation
import CoreData

struct DocResponseModel: Codable {
    let response: Response?
}

struct Response: Codable {
    let docs: [Doc]?
}

struct Doc: Codable {
    let abstract: String?
    let multimedia: [Multimedia]?
    let headline: Headline?
    let pubDate: String?

    enum CodingKeys: String, CodingKey {
        case abstract, multimedia, headline
        case pubDate = "pub_date"
    }
}

struct Headline: Codable {
    let main: String?
}

struct Multimedia: Codable {
    let url: String?
}

struct Doc2: Codable {
    let title: String?
    let description: String?
    let pubDate: String?
    let imageUrl: Data?
}
