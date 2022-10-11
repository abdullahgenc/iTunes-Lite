//
//  Media.swift
//  iTunes Client App
//
//  Created by Pazarama iOS Bootcamp on 1.10.2022.
//

import Foundation

struct ApiMedia: Decodable {
    let trackID: Int?
    let artistName: String?
    let trackName: String?
    let artworkLarge: URL?
    let releaseDate: String?
    let country: String?
    let genres: [String]?
    let currency: String?
    var isFavorited: Bool?
    
    init(trackID: Int? = nil, artistName: String? = nil,trackName: String? = nil, artworkLarge: URL? = nil,
         releaseDate: String? = nil, country: String? = nil, currency: String? = nil, genres: [String]? = nil, isFavorited: Bool? = nil) {
        
        self.trackID = trackID
        self.artistName = artistName
        self.trackName = trackName
        self.artworkLarge = artworkLarge
        self.releaseDate = releaseDate
        self.country = country
        self.currency = currency
        self.genres = genres
        self.isFavorited = isFavorited
    }
    
    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case artistName
        case trackName
        case artworkLarge = "artworkUrl100"
        case releaseDate
        case country
        case currency
        case genres
        case isFavorited
    }
}
