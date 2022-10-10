//
//  MediaResponse.swift
//  iTunes Client App
//
//  Created by Abdullah Genc on 10.10.2022.
//

import Foundation

struct MediaResponse: Decodable {
    let results: [Media]?
}
