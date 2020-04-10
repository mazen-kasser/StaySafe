//
//  Checkin+CoreDataProperties.swift
//  
//
//  Created by Mazen on 10/04/20.
//
//

import Foundation
import CoreData


extension Checkin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Checkin> {
        return NSFetchRequest<Checkin>(entityName: "Checkin")
    }

    @NSManaged public var dateOfCreation: Date
    @NSManaged public var ownerDisplayName: String

}
