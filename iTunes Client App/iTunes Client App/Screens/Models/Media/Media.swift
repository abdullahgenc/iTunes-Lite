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
    let artwork: URL?
    let releaseDate: String?
    let country: String?
    let primaryGenreName: String?
    let currency: String?
    let trackPrice: Double?
    let kind: String?
    let contentAdvisoryRating: String?
    var isFavorited: Bool?
    
    
    init(trackID: Int? = nil, artistName: String? = nil,trackName: String? = nil, artwork: URL? = nil,
         releaseDate: String? = nil, country: String? = nil, currency: String? = nil, primaryGenreName: String? = nil,
         trackPrice: Double? = nil, kind: String? = nil, contentAdvisoryRating: String? = nil, isFavorited: Bool? = nil) {
        
        self.trackID = trackID
        self.artistName = artistName
        self.trackName = trackName
        self.artwork = artwork
        self.releaseDate = releaseDate
        self.country = country
        self.currency = currency
        self.primaryGenreName = primaryGenreName
        self.trackPrice = trackPrice
        self.kind = kind
        self.contentAdvisoryRating = contentAdvisoryRating
        self.isFavorited = isFavorited
    }
    
    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case artistName
        case trackName
        case artwork = "artworkUrl100"
        case releaseDate
        case country
        case currency
        case primaryGenreName
        case trackPrice
        case kind
        case contentAdvisoryRating
        case isFavorited
    }
}
