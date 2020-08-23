//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import FirebaseFirestore

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
    
    func submitReport() {
        // TODO: report this user to backend
    }
    
    @objc func add(_ qrCode: String) {

        // check if already checked-in within 1min
        guard safeToAdd(qrCode) else { return }
        
        let checkin = Checkin(context: managedContext)
        checkin.merchantName = qrCode
        checkin.createdAt = Date()
        DataModelManager.shared.saveContext()
        
        // Add a new document with a generated id.
        let deviceToken = UserDefaults.standard.deviceToken ?? ""
        let businessEmail = qrCode.qrComponents.count >= 3 ? qrCode.qrComponents[2] : ""
        
        _ = Firestore.firestore().collection("businessAccounts/\(businessEmail)/checkins").addDocument(data: [
            "deviceToken": deviceToken,
            "createdAt": Date().formatted
        ]) { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                
            }
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

extension String {
    
    var qrComponents: [String] {
        return split(separator: "\n").map { String($0) }
    }
}

private extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
