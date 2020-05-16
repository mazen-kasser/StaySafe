//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

enum UserType: String {
    case business
    case person
}

extension UserDefaults {
    
    enum Key {
        static let deviceToken = "deviceToken"
        static let userType = "userType"
        static let fullName = "fullName"
        static let mobileNumber = "mobileNumber"
        static let emailAddress = "emailAddress"
        static let password = "password"
        static let isRegistered = "isRegistered"
        static let businessName = "businessName"
        static let businessAddress = "businessAddress"
    }
    
    var isUserRegistered: Bool {
        return UserDefaults.standard.fullName != nil &&
            UserDefaults.standard.mobileNumber != nil
    }
    
    var isBusinessRegistered: Bool {
        return UserDefaults.standard.businessName != nil &&
            UserDefaults.standard.businessAddress != nil
    }
    
    var businessName: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.businessName)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Key.businessName)
        }
    }
    
    var businessAddress: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.businessAddress)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Key.businessAddress)
        }
    }
    
    var emailAddress: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.emailAddress)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Key.emailAddress)
        }
    }
    
    var password: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.password)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Key.password)
        }
    }
    
    var fullName: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.fullName)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Key.fullName)
        }
    }
    
    var mobileNumber: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.mobileNumber)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Key.mobileNumber)
        }
    }
    
    var userType: UserType? {
        get {
            guard let value = UserDefaults.standard.string(forKey: Key.userType) else { return nil }
            switch value {
            case "business": return .business
            case "person": return .person
            default:
                return nil
            }
        }
        set(value) {
            UserDefaults.standard.set(value?.rawValue, forKey: Key.userType)
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
