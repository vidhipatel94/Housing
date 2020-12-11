//
//  City+CoreDataProperties.swift
//  Housing
//
//  Created by Vidhi Patel on 11/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var houses: NSSet?

}

// MARK: Generated accessors for houses
extension City {

    @objc(addHousesObject:)
    @NSManaged public func addToHouses(_ value: House)

    @objc(removeHousesObject:)
    @NSManaged public func removeFromHouses(_ value: House)

    @objc(addHouses:)
    @NSManaged public func addToHouses(_ values: NSSet)

    @objc(removeHouses:)
    @NSManaged public func removeFromHouses(_ values: NSSet)

}
