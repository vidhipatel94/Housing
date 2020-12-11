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
