//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

class ContactUsViewModel {
    
    func save(fullName: String?, mobileNumber: String?) {
        UserDefaults.standard.fullName = fullName
        UserDefaults.standard.mobileNumber = mobileNumber
    }
}
