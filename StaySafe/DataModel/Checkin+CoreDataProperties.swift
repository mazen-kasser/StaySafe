//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation
import CoreData


extension Checkin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Checkin> {
        return NSFetchRequest<Checkin>(entityName: "Checkin")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var merchantName: String

}
