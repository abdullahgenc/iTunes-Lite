//
//  DetailView.swift
//  iTunes Client App
//
//  Created by Pazarama iOS Bootcamp on 2.10.2022.
//

import UIKit

final class DetailView: UIView {
    var kind: String? {
        didSet {
            kindKeyLabel.text = "Kind:"
            kindKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            kindLabel.text = kind?.capitalized ?? "-"
        }
    }
    var releaseDate: String? {
        didSet {
            releaseDateKeyLabel.text = "Release Date:"
            releaseDateKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            releaseDateLabel.text = String((ISO8601DateFormatter().date(from: (releaseDate)!)?.description.dropLast(6))!) 
        }
    }
    
    var artistName: String? {
        didSet {
            artistNameKeyLabel.text = "Artist Name:"
            artistNameKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            artistNameLabel.text = artistName ?? "-"
        }
    }
    
    var genre: String? {
        didSet {
            genreKeyLabel.text = "Genre:"
            genreKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            genreLabel.text = genre ?? "-"
        }
    }
    
    var country: String? {
        didSet {
            countryKeyLabel.text = "Country:"
            countryKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            countryLabel.text = country ?? "-"
        }
    }
    
    var price: Double? {
        didSet {
            priceKeyLabel.text = "Price:"
            priceKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            priceLabel.text = price?.description ?? "-"
            if priceLabel.text == price?.description {
                priceLabel.text! += "$"
            }
        }
    }
    
    var contentAdvisoryRating: String? {
        didSet {
            contentAdvisoryRatingKeyLabel.text = "Content Advisory Rating:"
            contentAdvisoryRatingKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            contentAdvisoryRatingLabel.text = contentAdvisoryRating ?? "-"
        }
    }
    
    var isFavorited = Bool()
    var artwork: URL?
    var currency: String?
    var trackId: Int?
    
    private(set) var imageView = UIImageView()
    
    private let kindKeyLabel = UILabel()
    private let kindLabel = UILabel()
    private lazy var kindStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [kindKeyLabel, UIView(), kindLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let releaseDateKeyLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private lazy var releaseDateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [releaseDateKeyLabel, UIView(), releaseDateLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var artistNameKeyLabel = UILabel()
    private var artistNameLabel = UILabel()
    private lazy var artistNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artistNameKeyLabel, UIView(), artistNameLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var genreKeyLabel = UILabel()
    private var genreLabel = UILabel()
    private lazy var genreStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [genreKeyLabel, UIView(), genreLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var countryKeyLabel = UILabel()
    private var countryLabel = UILabel()
    private lazy var countryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countryKeyLabel, UIView(), countryLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var priceKeyLabel = UILabel()
    private var priceLabel = UILabel()
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceKeyLabel, UIView(), priceLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var contentAdvisoryRatingKeyLabel = UILabel()
    private var contentAdvisoryRatingLabel = UILabel()
    private lazy var contentAdvisoryRatingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [contentAdvisoryRatingKeyLabel, UIView(), contentAdvisoryRatingLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        kindLabel.numberOfLines = .zero
        releaseDateLabel.numberOfLines = .zero
        artistNameLabel.numberOfLines = .zero
        genreLabel.numberOfLines = .zero
        countryLabel.numberOfLines = .zero
        priceLabel.numberOfLines = .zero
        contentAdvisoryRatingLabel.numberOfLines = .zero
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: .screenWidth)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [kindStackView,
                                                       releaseDateStackView,
                                                       artistNameStackView,
                                                       genreStackView,
                                                       countryStackView,
                                                       priceStackView,
                                                       contentAdvisoryRatingStackView])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32.0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
