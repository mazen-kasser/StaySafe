//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation
import CloudKit

class CloudManager {
    
    static let database = CKContainer.default().publicCloudDatabase
    
    static func checkin(with deviceToken: String = UserDefaults.standard.deviceToken!, merchantName: String) {
        let checkinRecord = CKRecord(recordType: "Checkins")
        checkinRecord["deviceID"] = deviceToken as CKRecordValue
        checkinRecord["merchantName"] = merchantName as CKRecordValue
        
        save(checkinRecord)
    }
    
    static func report(with deviceToken: String = UserDefaults.standard.deviceToken!, fullName: String, mobileNumber: String) {
        let reportRecord = CKRecord(recordType: "Reports")
        reportRecord["deviceID"] = deviceToken as CKRecordValue
        reportRecord["fullName"] = fullName as CKRecordValue
        reportRecord["mobileNumber"] = mobileNumber as CKRecordValue
        
        save(reportRecord)
    }
    
    private static func save(_ record: CKRecord) {
        database.save(record) { record, error in
            // TODO: retry again when you have internet connection by flagging the checkin with `offline`
            // or return pass or error status to notify the user accordingly
        }
    }

}
