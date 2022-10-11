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
    private var artistNameArray = [String]()
    private var trackIdArray = [Int]()
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
        artistNameArray.removeAll(keepingCapacity: true)
        trackIdArray.removeAll(keepingCapacity: true)
        mediaList.removeAll(keepingCapacity: true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMedia")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                guard let name = result.value(forKey: "artistName") as? String,
                      let id = result.value(forKey: "trackId") as? Int else  {
                    return
                }
                artistNameArray.append(name)
                trackIdArray.append(id)
                mediaList.append(ApiMedia(trackID: id, artistName: name, currency: "-"))
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
        trackIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = artistNameArray[indexPath.row]
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
                    artistNameArray.remove(at: indexPath.row)
                    trackIdArray.remove(at: indexPath.row)
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
