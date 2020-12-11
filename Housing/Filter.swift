//
//  Filter.swift
//  Housing
//
//  Created by Vidhi Patel on 02/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import Foundation

class Filter {
    var onBuy: Bool
    var onRent: Bool
    var cityId: Int!
    var type: String!
    var minPrice: Double!
    var maxPrice: Double!
    
    init() {
        onBuy = true
        onRent = true
    }
}
