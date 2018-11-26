//
//  ResultTableViewController.swift
//  SoFi Coding Challenge
//
//  Created by Levi Linchenko on 20/11/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchOutlet: UISearchBar!
    
    var results: [Result] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var searchText: String?
    var pageNumber: Int?
    var result: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchOutlet.delegate = self
        ResultController.shared.fetchViral { (results) in
            DispatchQueue.main.async {
                self.navigationItem.title = "Viral"
                self.results = results?.results ?? []
            }
        }
    }
    
    //MARK: - Search Functionality
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            self.searchText = searchText
            self.pageNumber = 1
            imageCache.removeAllObjects()
            if searchText == "" {
                ResultController.shared.fetchViral(completion: { (results) in
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Viral"
                        self.results = results?.results ?? []
                    }
                })
            } else {
                ResultController.shared.fetchResults(with: searchText, atPage: 1) { (results) in
                    DispatchQueue.main.async {
                        self.navigationItem.title = searchText
                        self.results = results?.results ?? []
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultTableViewCell else {return UITableViewCell()}

        let result = results[indexPath.row]
        cell.titleOutlet.text = result.title
        if let url = result.imageURLS?.first {
            DispatchQueue.main.async {
                cell.imageOutlet.loadImage(with: url)
            }
        }
        return cell
    }
    
    //MARK: - Handle First Responder
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchOutlet.resignFirstResponder()
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        
        if indexPath.row == results.count - 1{
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
            self.tableView.tableFooterView = spinner;
            guard let searchText = searchText,
                let pageNumber = pageNumber else {return}
            
            ResultController.shared.fetchResults(with: searchText, atPage: pageNumber+1) { (results) in
                if let results = results {
                    DispatchQueue.main.async {
                        self.pageNumber = pageNumber+1
                        self.results.append(contentsOf: results.results)
                        tableView.reloadData()
                    }
                } else {
                    let label = UILabel()
                    label.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
                    label.text = "Sorry Nothing More"
                    self.tableView.tableFooterView = label
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        result = results[indexPath.row]
        return indexPath
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? DetailTableViewController else {return}
        destVC.result = self.result
    }

}
