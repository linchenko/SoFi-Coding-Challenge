//
//  ResultController.swift
//  SoFi Coding Challenge
//
//  Created by Levi Linchenko on 20/11/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import Foundation
import UIKit

class ResultController {
    
    static let shared = ResultController()
    private init () {}
    
    func fetchResults(with searchText: String, atPage: Int, completion: @escaping (_ success: Results?)->Void){
        
        guard let baseURL = URL(string: "https://api.imgur.com/3/gallery/search/time") else {completion(nil);return}
        let pageNumber = String(atPage)
        var components = URLComponents(url: baseURL.appendingPathComponent(pageNumber), resolvingAgainstBaseURL: true)
        let queryItem = URLQueryItem(name: "q", value: searchText.lowercased())
        components?.queryItems = [queryItem]
        guard let url = components?.url else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let clientID = "126701cd8332f32"
        urlRequest.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        
     
        print(urlRequest)
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in

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
    
    func fetchImage(imageURL: URL?, completion: @escaping (_ image: UIImage?)->Void) {
        guard let imageURL = imageURL else {completion(nil);return}
        URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion(nil)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    completion(image)
                }
            }
            
            
        }).resume()
    }
    
}

