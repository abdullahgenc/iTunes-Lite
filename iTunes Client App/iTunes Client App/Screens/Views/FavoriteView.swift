//
//  FavoriteView.swift
//  iTunes Client App
//
//  Created by Abdullah Genc on 10.10.2022.
//

import UIKit

final class FavoriteView: UIView {

    private let tableView = UITableView(frame: .zero, style: UITableView.Style.insetGrouped)
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .blue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupTableViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableViewLayout() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setTableViewDelegate(_ delegate: UITableViewDelegate, andDataSource dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
