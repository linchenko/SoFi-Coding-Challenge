//
//  DetailTableViewController.swift
//  SoFi Coding Challenge
//
//  Created by Levi Linchenko on 20/11/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = result?.title
    }
    
    var result: Result?

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.imageURLS?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        guard let imageView = cell.viewWithTag(1) as? CustomImageView,
            let imageURL = result?.imageURLS?[indexPath.row] else {return cell}
        imageView.loadImage(with: imageURL)
        return cell
    }
 
}
