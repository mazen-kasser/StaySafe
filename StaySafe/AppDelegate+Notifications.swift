//
//  AppDelegate+Notifications.swift
//  StaySafe
//
//  Created by Mazen on 10/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate {
    
    func handlePushNotification(_ application: UIApplication, withOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // let AppDelegate handle push notification
        UNUserNotificationCenter.current().delegate = self
        
        // Ask user permission for sending push notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { authorized, error in
            if authorized {
                DispatchQueue.main.async(execute: {
                    application.registerForRemoteNotifications()
                })
            }
        })
        
        // When the app launch after user tap on notification (originally was not running / not in background)
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if UIApplication.shared.applicationState == .active {
            print("app received notification while in foreground")
        }
        
        // show the notification alert (banner), and with sound
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        
        if application.applicationState == .active {
            print("user tapped the notification bar when the app is in foreground")
        }
        
        if application.applicationState == .inactive {
            print("user tapped the notification bar when the app is in background")
        }
        
        // tell the app that we have finished processing the user’s action / response
        completionHandler()
    }
}
