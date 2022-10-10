//
//  EbookRequest.swift
//  iTunes Client App
//
//  Created by Abdullah Genc on 10.10.2022.
//

import Foundation

struct MediaRequest: DataRequest {

    var searchText: String
    var media: String

    var baseURL: String {
        "https://itunes.apple.com"
    }

    var url: String {
        "/search"
    }

    var queryItems: [String : String] {
        ["term": searchText,
         "media" : media]
    }

    var method: HTTPMethod {
        .get
    }

    func decode(_ data: Data) throws -> MediaResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(MediaResponse.self, from: data)
        return response
    }
}
