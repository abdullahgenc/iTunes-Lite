//
//  DetailViewController.swift
//  iTunes Client App
//
//  Created by Pazarama iOS Bootcamp on 2.10.2022.
//

import UIKit
import CoreData

final class DetailViewController: UIViewController {
    
    var media: ApiMedia? {
        didSet {
            title = media?.trackName
            detailView.trackId = media?.trackID
            detailView.artwork = media?.artwork
            detailView.imageView.downloadImage(from: detailView.artwork)
            detailView.kind = media?.kind
            detailView.releaseDate = media?.releaseDate
            detailView.artistName = media?.artistName
            detailView.genre = media?.primaryGenreName
            detailView.country = media?.country
            detailView.price = media?.trackPrice
            detailView.contentAdvisoryRating = media?.contentAdvisoryRating
            detailView.currency = media?.currency
            detailView.isFavorited = false
        }
    }
    
    //kind - release -  artistname - genre - country - price - contentad
    private let detailView = DetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        if detailView.currency != "-" {
            updateRighBarButton(detailView.isFavorited)
        }
    }
    
    private func updateRighBarButton(_ isFavorite : Bool) {
        let btnFavorite = UIButton(frame: CGRectMake(0,0,30,30))
        btnFavorite.addTarget(self, action: #selector(self.btnFavoriteDidTap), for: .touchUpInside)
        
        if detailView.isFavorited {
            btnFavorite.setImage(UIImage(systemName: "star.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal), for: [])
        } else {
            btnFavorite.setImage(UIImage(systemName: "star"), for: [])
        }
        let rightButton = UIBarButtonItem(customView: btnFavorite)
        self.navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }

    private func favorite() -> Bool {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMedia")
        fetchRequest.predicate = NSPredicate(format: "trackId = %@", String(detailView.trackId!))
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let _ = result.value(forKey: "trackId") as? Int {
                    print("track id exist")
                    return false
                }
            }
        } catch {
            print("favorite fetch error")
        }
        
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "FavMedia", into: context)
        
        saveData.setValue(detailView.isFavorited, forKey: "isFavorited")
        saveData.setValue(detailView.trackId, forKey: "trackId")
        saveData.setValue(detailView.artistName, forKey: "artistName")
        saveData.setValue(title, forKey: "trackName")
        if let artwork = detailView.artwork { saveData.setValue(artwork.description, forKey: "artwork" ) }
        saveData.setValue(detailView.releaseDate, forKey: "releaseDate")
        saveData.setValue(detailView.country, forKey: "country")
        saveData.setValue(detailView.genre, forKey: "genre")
        saveData.setValue(detailView.price, forKey: "price")
        saveData.setValue(detailView.kind, forKey: "kind")
        saveData.setValue(detailView.contentAdvisoryRating, forKey: "contentAdvisoryRating")
        
        do {
            try context.save()
        } catch {
            print("favorite save error")
        }
        NotificationCenter.default.post(name: NSNotification.Name.init("newData"), object: nil)
        return true
    }
    
    @objc private func btnFavoriteDidTap() {

        detailView.isFavorited = !detailView.isFavorited
        if detailView.isFavorited {
            detailView.isFavorited = favorite()
        }
        updateRighBarButton(detailView.isFavorited)
    }
}
