//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

class MainViewModel {
    
    var createQRCodeText: String {
        return UserDefaults.standard.isBusinessRegistered ? "My code" : "How to request a QR code?"
    }
}
