//
//  CityCellView.swift
//  Housing
//
//  Created by Waqas Basir on 07/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import Foundation
import UIKit

class CityCellView : UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinnerView: UIActivityIndicatorView!
    
    @IBOutlet var titleView: UILabel!
    
    func updateView(image: UIImage?){
        if let image1 = image {
            spinnerView.stopAnimating()
            imageView.image = image1
        } else {
            spinnerView.startAnimating()
            imageView.image = nil
        }
    }
}

