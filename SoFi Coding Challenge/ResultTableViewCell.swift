//
//  ResultTableViewCell.swift
//  SoFi Coding Challenge
//
//  Created by Levi Linchenko on 20/11/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleOutlet: UILabel!

    @IBOutlet weak var imageOutlet: CustomImageView!
    
    var imageURL: URL?{
        didSet {
            ResultController.shared.fetchImage(imageURL: imageURL) { (image) in
                self.imageOutlet.image = image
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}



