//
//  Copyright © 2020 iProgram. All rights reserved.
//

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
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return try! managedContext.fetch(fetchRequest)
    }
    
    @objc func add(_ qrCode: String) {

        // check if already checked-in within 1min
        guard safeToAdd(qrCode) else { return }
        
        let checkin = Checkin(context: managedContext)
        checkin.merchantName = qrCode
        checkin.createdAt = Date()
        DataModelManager.shared.saveContext()
        
        // send record to CloudKit
        let checkinRecord = CKRecord(recordType: "Checkins")
        checkinRecord["deviceID"] = UserDefaults.standard.deviceToken! as CKRecordValue
        checkinRecord["merchantName"] = qrCode as CKRecordValue
        
        CloudManager.database.save(checkinRecord) { record, error in
            // TODO: retry again when you have internet connection by flagging the checkin with `offline`
        }
    }
    
    func delete(_ checkin: Checkin) {
        let fetchRequest: NSFetchRequest<Checkin> = Checkin.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "merchantName = %@ AND createdAt = %@", checkin.merchantName!, checkin.createdAt! as CVarArg)
        
        let places = try! managedContext.fetch(fetchRequest)
        let objectToDelete = places[0]
        
        managedContext.delete(objectToDelete)
        DataModelManager.shared.saveContext()
    }
    
    /// Safe to add a checkin if greater than the grace period i.e 5 min
    private func safeToAdd(_ merchantName: String) -> Bool {
        let fetchRequest: NSFetchRequest<Checkin> = Checkin.fetchRequest()
        let sinceDate = Date().addingTimeInterval(-300) // 5 min ago
        fetchRequest.predicate = NSPredicate(format: "merchantName = %@ AND createdAt > %@", merchantName, sinceDate as CVarArg)
        
        let places = try! managedContext.fetch(fetchRequest)
        
        return places.isEmpty
    }
    
}

private extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
