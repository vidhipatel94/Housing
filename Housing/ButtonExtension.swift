//
//  ButtonExtension.swift
//  Housing
//
//  Created by Vidhi Patel on 07/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let color = newValue else { return }
            layer.borderColor = color.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var paddingHorizontal: CGFloat {
        set {
            contentEdgeInsets.left = newValue
            contentEdgeInsets.right = newValue
        }
        get {
            return 5
        }
    }
    
    @IBInspectable var paddingVerticle: CGFloat {
        set {
            contentEdgeInsets.top = newValue
            contentEdgeInsets.bottom = newValue
        }
        get {
            return 5
        }
    }
}
