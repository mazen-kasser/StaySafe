//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

class ContactUsViewModel {
    
    func submitReport(fullName: String?, mobileNumber: String?) {
        guard let name = fullName,
            let mobile = mobileNumber else {
            assertionFailure()
            return
        }
        
        CloudManager.report(fullName: name, mobileNumber: mobile)
    }
}
