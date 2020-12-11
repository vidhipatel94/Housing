//
//  House+CoreDataClass.swift
//  Housing
//
//  Created by Vidhi Patel on 11/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//
//

import Foundation
import CoreData


public class House: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = 0
        title = ""
        type = ""
        size = ""
        address = ""
        cityId = 0
        latitude = 0
        longitude = 0
        price = 0
        onSale = false
        onRent = false
        contactNo = ""
        amenities = [NSString]()
        photos = [NSString]()
    }
    
    convenience init(id: Int, title:String, type:String, size:String, address:String, cityId:Int,
                     latitude:Double, longitude:Double, price:Double, onSale:Bool, onRent:Bool, contactNo:String,
                     amenities:[NSString], photos:[NSString], context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entity(forEntityName: "House", in:context)!
        self.init(entity: entity, insertInto: context)
        self.id = Int16(id)
        self.title = title
        self.type = type
        self.size = size
        self.address = address
        self.cityId = Int16(cityId)
        self.latitude = latitude
        self.longitude = longitude
        self.price = price
        self.onSale = onSale
        self.onRent = onRent
        self.contactNo = contactNo
        self.amenities = amenities
        self.photos = photos
    }
}
