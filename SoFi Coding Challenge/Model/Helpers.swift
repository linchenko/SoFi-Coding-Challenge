//
//  Helpers.swift
//  SoFi Coding Challenge
//
//  Created by Levi Linchenko on 20/11/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

// Custom Image View to assure images are being displayed in the currect cells

class CustomImageView: UIImageView {
    
    var urlString: String?
    
    func loadImage(with url: URL){
        
        urlString = url.absoluteString
        
        image = nil
        
        //If image has already been loaded, pull from cache instead of loading twice
        if let image = imageCache.object(forKey: NSString(string: url.absoluteString)) as? UIImage {
            self.image = image
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                guard let data = data,
                    let imageToCache = UIImage(data: data) else {return}
                
                if self.urlString == url.absoluteString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache, forKey: NSString(string: url.absoluteString))
                if let error = error {
                    print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                }
            }
        }.resume()
    }
}
