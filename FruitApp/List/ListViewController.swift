//
//  ListViewController.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, Storyboarded {
    
    @IBOutlet private var tableView: UITableView!
    
    var presenter: ListViewPresentable!

    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = presenter.sectionTitle
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: Any) {
        presenter.refreshList()
    }

    func reloadList() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetail(for: indexPath.row)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rowCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as? ListViewCell {
         
            cell.fruitName = presenter.text(for: indexPath.row)
           return cell
        }
        return UITableViewCell()
    }
    
    
}
