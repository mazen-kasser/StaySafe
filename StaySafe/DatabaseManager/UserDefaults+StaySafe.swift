//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum Key {
        static let deviceToken = "deviceToken"
        static let isRegistered = "isRegistered"
    }
    
    var isDeviceRegistered: Bool {
        guard UserDefaults.standard.deviceToken != nil else {
            #if targetEnvironment(simulator)
            UserDefaults.standard.set("simulator_token", forKey: Key.deviceToken)
            #endif
            
            return false
        }
        return true
    }
    
    var isBusinessRegistered: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Key.isRegistered)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Key.isRegistered)
        }
    }
    
    var deviceToken: String? {
        return UserDefaults.standard.string(forKey: Key.deviceToken)
    }
    
    /// Send the contents of the deviceToken parameter to the server that you use to generate remote notifications. Never cache the device token locally on the user's device. Device tokens can change periodically, so caching the value risks sending an invalid token to your server. If the device token hasn't changed, registering with APNs and returning the token happens quickly.
    func storeDeviceTokenIfNeeded(_ data: Data) {
        if deviceToken == nil {
            UserDefaults.standard.set(data.deviceTokenString, forKey: Key.deviceToken)
        } else {
            if data.deviceTokenString != deviceToken {
                // TODO: update the device token field for all the cloud records!!!
                UserDefaults.standard.set(data.deviceTokenString, forKey: Key.deviceToken)
            }
        }
    }
}

fileprivate extension Data {
    var deviceTokenString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
