//
//  UserDefaults+.swift
//  StaySafe
//
//  Created by Mazen on 10/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum Key {
        static let deviceToken = "deviceToken"
    }
    
    var deviceToken: String? {
        return UserDefaults.standard.string(forKey: Key.deviceToken)
    }
    
    func storeDeviceToken(_ data: Data) {
        UserDefaults.standard.set(data.deviceTokenString, forKey: Key.deviceToken)
    }
}

fileprivate extension Data {
    var deviceTokenString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
