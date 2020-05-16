//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class BusinessCheckinViewModel {
    
    private var managedContext: NSManagedObjectContext {
        DataModelManager.shared.managedContext
    }
    
    var checkins: [Checkin] {
        let fetchRequest: NSFetchRequest<Checkin> = Checkin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return try! managedContext.fetch(fetchRequest)
    }
    
}
