//
//  City+CoreDataClass.swift
//  Housing
//
//  Created by Vidhi Patel on 11/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//
//

import Foundation
import CoreData


public class City: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = 0
        name = ""
        photo = ""
    }
    
    convenience init(id: Int, name:String, photo:String, context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entity(forEntityName: "City", in:context)!
        self.init(entity: entity, insertInto: context)
        self.id = Int16(id)
        self.name = name
        self.photo = photo
    }

}
