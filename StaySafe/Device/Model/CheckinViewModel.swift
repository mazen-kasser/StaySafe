//  Copyright © 2019 iProgram. All rights reserved.

import UIKit
import Foundation
import CoreData

import CloudKit

class CheckinViewModel {
    
    private var managedContext: NSManagedObjectContext {
        DataModelManager.shared.managedContext
    }
    
    var checkins: [Checkin] {
        let fetchRequest: NSFetchRequest<Checkin> = Checkin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateOfCreation", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return try! managedContext.fetch(fetchRequest)
    }
    
    func add(_ qrCode: String) {
        let checkin = Checkin(context: managedContext)
        checkin.ownerDisplayName = qrCode
        checkin.dateOfCreation = Date()
        
        DataModelManager.shared.saveContext()
        
        // send record to CloudKit
        let checkinRecord = CKRecord(recordType: "Checkins")
        checkinRecord["deviceID"] = UserDefaults.standard.deviceToken! as CKRecordValue
        checkinRecord["ownerDisplayName"] = qrCode as CKRecordValue
        
        CloudManager.shared.save(checkinRecord) { record, error in
            // TODO: retry again when you have internet connection by flagging the checkin with `offline`
        }
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
