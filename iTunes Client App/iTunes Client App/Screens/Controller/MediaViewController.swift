//
//  MediaViewController.swift
//  iTunes Client App
//
//  Created by Pazarama iOS Bootcamp on 1.10.2022.
//

import UIKit

final class MediaViewController: UIViewController {
    
    // MARK: - Properties
    var mediaType: String = ""
    private let mainView = MediaView()
    private let networkService = BaseNetworkService()
    private var mediaResponse: MediaResponse? {
        didSet {
            mainView.refresh()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        mainView.setCollectionViewDelegate(self, andDataSource: self)
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Education, Fun..."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        fetchMedias(searchText: mediaType, media: mediaType)
    }
    
    // MARK: - Methods
    private func fetchMedias(searchText: String, media: String) {
        networkService.request(MediaRequest(searchText: searchText, media: media)) { result in
            switch result {
            case .success(let response):
                self.mediaResponse = response
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MediaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.media = mediaResponse?.results?[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension MediaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaResponse?.results?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MediaCollectionViewCell
        let media = mediaResponse?.results?[indexPath.row]
        cell.title = media?.trackName
        cell.imageView.downloadImage(from: media?.artworkLarge)
        return cell
    }
    
}

// MARK: - UISearchResultsUpdating
extension MediaViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 1 {
            fetchMedias(searchText: text, media: mediaType)
        } else {
            fetchMedias(searchText: mediaType, media: mediaType)
        }
    }
}
