//
//  DetailViewController.swift
//  iTunes Client App
//
//  Created by Pazarama iOS Bootcamp on 2.10.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    
    var media: Media? {
        didSet {
            title = media?.trackName
            detailView.imageView.downloadImage(from: media?.artworkLarge)
            detailView.releaseDate = media?.releaseDate
            detailView.artistName = media?.artistName
            detailView.country = media?.country
            detailView.genres = media?.genres?.reduce("") { $1 + ", " + $0 }
        }
    }
    
    private let detailView = DetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
    }
}
