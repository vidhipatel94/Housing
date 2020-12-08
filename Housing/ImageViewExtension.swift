//
//  ImageViewExtension.swift
//  Housing
//
//  Created by Vidhi Patel on 08/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadUrl(url:String, spinner: UIActivityIndicatorView?){
        guard let imgURL = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imgURL)
                else {
                    //failed
                    if spinner != nil {
                        spinner?.stopAnimating()
                    }
                    return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                // success
                self.image = image
                if spinner != nil {
                    spinner?.stopAnimating()
                }
            }
        }
    }
}
