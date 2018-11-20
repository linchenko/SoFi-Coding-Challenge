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
    
    var results: [Result] = []
    var searchText: String?
    var pageNumber: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchOutlet.delegate = self
    }
//
//    func loadImages(){
//        let imagesURLs = results.compactMap({$0.imageURLS?.first})
//        for imageURL in imagesURLs {
//            ResultController.shared.fetchImage(imageURL: imageURL) { (image) in
//                if let image = image {
//                    self.imageCache.setObject(image, forKey: imageURL.absoluteString as AnyObject)
//
//                }
//            }
//        }
//    }
    
    
    //MARK: - Search Functionality
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else {return}
        results = []
        self.searchText = searchText
        self.pageNumber = 1
        imageCache.removeAllObjects()
        ResultController.shared.fetchResults(with: searchText, atPage: 1) { (results) in
            DispatchQueue.main.async {
                self.results = results?.results ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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


    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
