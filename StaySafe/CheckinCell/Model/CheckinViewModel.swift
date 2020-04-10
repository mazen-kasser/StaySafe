//  Copyright © 2019 iProgram. All rights reserved.

import UIKit
import Foundation
import CoreData

class CheckinViewModel {
    
    private var managedContext: NSManagedObjectContext {
        DataModelManager.shared.managedContext
    }
    
    var checkins: [Checkin] {
        try! managedContext.fetch(Checkin.fetchRequest())
    }
    
    func add(_ qrCode: String) {
        let checkin = Checkin(context: managedContext)
        checkin.ownerDisplayName = qrCode
        checkin.dateOfCreation = Date()
        
        DataModelManager.shared.saveContext()
    }
    
    func delete(_ checkin: Checkin) {
        let fetchRequest: NSFetchRequest<Checkin> = Checkin.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ownerDisplayName = %@ AND dateOfCreation = %@", checkin.ownerDisplayName!, checkin.dateOfCreation! as CVarArg)
        
        let test = try! managedContext.fetch(fetchRequest)
        let objectToDelete = test[0]
        
        managedContext.delete(objectToDelete)
        DataModelManager.shared.saveContext()
    }
    
}
