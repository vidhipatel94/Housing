//
//  House.swift
//  Housing
//
//  Created by Vidhi Patel on 29/11/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import Foundation

class House : Codable{
    
    var id: Int
    var title: String!
    var type: String!
    var size: String!
    var address: String!
    var city: String!
    var latitude: Double!
    var longitude: Double!
    var price: Double!
    var onSale: Bool!
    var onRent: Bool!
    var contactNo: String!
    var amenities: [String]!
    var photos: [String]!
    
    init(id: Int, title: String!, type: String!, size: String!, address: String!, city: String!,
         latitude: Double!, longitude: Double!, price: Double!, onSale: Bool!, onRent: Bool!,
         contactNo: String!, amenities: [String]!, photos: [String]!){
        self.id = id
        self.title = title
        self.type = type
        self.size = size
        self.address = address
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        self.price = price
        self.onSale = onSale
        self.onRent = onRent
        self.contactNo = contactNo
        self.amenities = amenities
        self.photos = photos
    }
    
    func toString()->String {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            return ""
        }
    }
    
}
