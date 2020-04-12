//
//  AppDelegate+OpenURLScheme.swift
//  StaySafe
//
//  Created by Mazen on 12/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func handleOpenURLScheme() {
        NotificationCenter.default.addObserver(self,
                                               selector: .openUrlScheme,
                                               name: .openUrlSchemeNotification,
                                               object: nil)
    }
    
    @objc func openUrlScheme(_ notification: Notification) {
        guard let object = notification.object as? String else { return }
        
        let vm = CheckinViewModel()
        vm.add(object)
        
        Alert.showLoading() {
            Alert.hideLoading()
        }
    }
}

extension Notification.Name {
    static let openUrlSchemeNotification = Notification.Name(rawValue: "openUrlScheme")
}

private extension Selector {
    static let openUrlScheme = #selector(AppDelegate.openUrlScheme(_:))
}

extension UIResponder {
    
    func checkin(_ text: String) {
        guard let message = QRGenerator.decode(text) else { return }
        
        NotificationCenter.default.post(name: .openUrlSchemeNotification, object: message)
    }
}
