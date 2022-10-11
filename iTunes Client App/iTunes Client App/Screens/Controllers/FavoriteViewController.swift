//
//  FavoriteViewController.swift
//  iTunes Client App
//
//  Created by Abdullah Genc on 10.10.2022.
//

import UIKit
import CoreData

final class FavoriteViewController: UIViewController {
    
    // MARK: - Properties
    private var mediaList = [ApiMedia]()
    private let mainView = FavoriteView()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        mainView.setTableViewDelegate(self, andDataSource: self)
        loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(loadFavorites), name: NSNotification.Name("newData"), object: nil)
    }
    
    // MARK: - Methods
    @objc private func loadFavorites() {
        mediaList.removeAll(keepingCapacity: true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMedia")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                guard let id = result.value(forKey: "trackId") as? Int else {
                    return
                }
                let artistName = result.value(forKey: "artistName") as? String
                let trackName = result.value(forKey: "trackName") as? String
                let artworkString = result.value(forKey: "artwork") as? String
                let releaseDate = result.value(forKey: "releaseDate") as? String
                let country = result.value(forKey: "country") as? String
                let genre = result.value(forKey: "genre") as? String
                let price = result.value(forKey: "price") as? Double
                let kind = result.value(forKey: "kind") as? String
                let contentAdvisoryRating = result.value(forKey: "contentAdvisoryRating") as? String
                let artwork = URL(string: artworkString!)

                mediaList.append(ApiMedia(trackID: id, artistName: artistName, trackName: trackName, artwork: artwork, releaseDate: releaseDate, country: country,
                                          currency: "-", primaryGenreName: genre, trackPrice: price, kind: kind, contentAdvisoryRating: contentAdvisoryRating))
                mainView.refresh()
            }
            
        } catch {
            print("load error")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.media = mediaList[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mediaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = mediaList[indexPath.row].trackName
        cell.imageView?.image = UIImage(systemName: "star.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        return cell
    }
    
}
extension FavoriteViewController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMedia")
        fetchRequest.predicate = NSPredicate(format: "trackId = %@", String(mediaList[indexPath.row].trackID!))
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let _ = result.value(forKey: "trackId") as? Int {
                    context.delete(result)
                    mediaList.remove(at: indexPath.row)
                    tableView.reloadData()
                    do {
                        try context.save()
                    } catch {
                        print("save error")
                    }
                }
            }
        } catch {
            print("fetch error")
        }
    }
}
