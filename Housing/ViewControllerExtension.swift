//
//  ViewControllerExtension.swift
//  Housing
//
//  Created by Simranjit Singh on 09/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(_ message:String)  {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

}
