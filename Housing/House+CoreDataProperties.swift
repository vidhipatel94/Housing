//
//  House+CoreDataProperties.swift
//  Housing
//
//  Created by Vidhi Patel on 11/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//
//

import Foundation
import CoreData


extension House {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<House> {
        return NSFetchRequest<House>(entityName: "House")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var size: String?
    @NSManaged public var address: String?
    @NSManaged public var cityId: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var price: Double
    @NSManaged public var onSale: Bool
    @NSManaged public var onRent: Bool
    @NSManaged public var contactNo: String?
    @NSManaged public var amenities: [NSString]
    @NSManaged public var photos: [NSString]
    @NSManaged public var city: City?

}
