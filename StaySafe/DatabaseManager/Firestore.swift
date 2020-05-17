//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation
import Firebase

struct BusinessAccount {
    
    let deviceToken: String
    let ownerFullName: String
    let ownerMobileNumber: String
    let businessName: String
    let businessAddress: String
}

struct CheckinItem {
    
    let deviceToken: String
    let userFullName: String
    let userMobileNumber: String
}
