//
//  AppDelegate.swift
//  StaySafe
//
//  Created by Mazen on 6/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        handlePushNotification(application, withOptions: launchOptions)
        
        handleOpenURLScheme()
        
        try! ValidationRulesRegistry.addRulesToRegistry(ContactUsValidationRule.rules)
        
        return true
    }
    
    // When user allowed push notification and the app has gotten the device token
    // (device token is a unique ID that Apple server use to determine which device to send push notification to)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        UserDefaults.standard.storeDeviceTokenIfNeeded(deviceToken)
        
        // Create a subscription to the 'Notifications' Record Type in CloudKit
        // User will receive a push notification when a new record is created in CloudKit
        // Read more on https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitQuickStart/SubscribingtoRecordChanges/SubscribingtoRecordChanges.html
        
        //         The predicate lets you define condition of the subscription, eg: only be notified of change if the newly created notification start with "A"
        // the TRUEPREDICATE means any new Notifications record created will be notified
        let subscription = CKQuerySubscription(recordType: "Notifications", predicate: NSPredicate(format: "TRUEPREDICATE"), options: .firesOnRecordCreation)
        
        // Here we customize the notification message
        let info = CKSubscription.NotificationInfo()
        
        // this will use the 'title' field in the Record type 'notifications' as the title of the push notification
        info.titleLocalizationKey = "%1$@"
        info.titleLocalizationArgs = ["title"]
        
        // if you want to use multiple field combined for the title of push notification
         info.subtitleLocalizationKey = "%1$@" // if want to add more, the format will be "%3$@" and so on
         info.subtitleLocalizationArgs = ["subtitle"]
        
        // this will use the 'content' field in the Record type 'notifications' as the content of the push notification
        info.alertLocalizationKey = "%1$@"
        info.alertLocalizationArgs = ["content"]
        
        // increment the red number count on the top right corner of app icon
        info.shouldBadge = true
        
        // use system default notification sound
        info.soundName = "default"
        
        subscription.notificationInfo = info
        
        // Save the subscription to Public Database in Cloudkit
        CloudManager.database.save(subscription, completionHandler: { subscription, error in
            if error == nil {
                // Subscription saved successfully
            } else {
                // Error occurred
            }
        })
        
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        checkin(url.absoluteString)
        
        return true
    }

}
