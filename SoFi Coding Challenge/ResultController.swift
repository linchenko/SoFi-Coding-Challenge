//
//  ResultController.swift
//  SoFi Coding Challenge
//
//  Created by Levi Linchenko on 20/11/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import Foundation

class ResultController {
    
    static let shared = ResultController()
    private init () {}
    
    func fetchResults(with searchText: String, atPage: Int, completion: @escaping (_ success: Results?)->Void){
        
        guard let baseURL = URL(string: "https://api.imgur.com/3/gallery/search/time") else {completion(nil);return}
        let pageNumber = String(atPage)
        var components = URLComponents(url: baseURL.appendingPathComponent(pageNumber), resolvingAgainstBaseURL: true)
        let queryItem = URLQueryItem(name: "q", value: searchText)
        components?.queryItems = [queryItem]
        guard let url = components?.url else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data else {completion(nil);return}
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(results)
                if let error = error { throw error }
            } catch {
                print("💩💩error fetching results \(error.localizedDescription), \(error)💩💩")
                completion(nil)
                return
            }
        }.resume()
    }
}
