//
//  DetailPhotoCellView.swift
//  Housing
//
//  Created by Vidhi Patel on 02/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import Foundation
import UIKit

class DetailPhotoCellView: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinnerView: UIActivityIndicatorView!
    
    func updateView(_ image: UIImage?){
        if let image1 = image {
            spinnerView.stopAnimating()
            imageView.image = image1
        } else {
            spinnerView.startAnimating()
            imageView.image = nil
        }
    }
}
