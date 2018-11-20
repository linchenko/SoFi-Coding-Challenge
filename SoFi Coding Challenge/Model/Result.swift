//
//  Result.swift
//  SoFi Coding Challenge
//
//  Created by Levi Linchenko on 20/11/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import Foundation

struct Results: Decodable {
    
    let results: [Result]
    
    private enum CodingKeys: String, CodingKey {
        case results = "data"
    }
    
}

struct Result: Decodable {
    
    let title: String
    var imageURLS: [URL]? {
        return images?.compactMap{$0.imageURL}
    }
    
    let images: [Images]?
    
}

struct Images: Decodable {
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "link"
    }
}


