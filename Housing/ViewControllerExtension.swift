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
    
    // Util Function to Show Alert
    func showAlert(_ message:String)  {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: "Button"), style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

}
