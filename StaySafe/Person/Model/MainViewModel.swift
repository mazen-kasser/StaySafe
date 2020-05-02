//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

class MainViewModel {
    
    var userIsNotRegistered: Bool {
        return UserDefaults.standard.fullName == nil ||
            UserDefaults.standard.mobileNumber == nil
    }
}
