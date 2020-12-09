//
//  FilterTableViewCell.swift
//  Housing
//
//  Created by Aman Gupta on 08/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var view_Outer: UIView!
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_City: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var imgView_Image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_Outer.layer.cornerRadius = 10.0
        view_Outer.layer.borderColor = UIColor.lightGray.cgColor
        view_Outer.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
