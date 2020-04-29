//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation
import CloudKit

class CloudManager {
    
    private static let database = CKContainer.default().publicCloudDatabase
    
    static func checkin(merchantName: String) {
        let checkinRecord = CKRecord(recordType: "Checkins")
        checkinRecord["merchantName"] = merchantName as CKRecordValue
        
        save(checkinRecord)
    }
    
    static func report(fullName: String, mobileNumber: String) {
        let reportRecord = CKRecord(recordType: "Reports")
        reportRecord["fullName"] = fullName as CKRecordValue
        reportRecord["mobileNumber"] = mobileNumber as CKRecordValue
        
        save(reportRecord)
    }
    
    private static func save(_ record: CKRecord) {
        // TODO: save offline only at this stage
        guard let deviceToken = UserDefaults.standard.deviceToken else { return }
        
        record["deviceID"] = deviceToken as CKRecordValue
        database.save(record) { record, error in
            // TODO: retry again when you have internet connection by flagging the checkin with `offline`
            // or return pass or error status to notify the user accordingly
        }
    }

}
