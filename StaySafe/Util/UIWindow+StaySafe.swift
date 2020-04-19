//
//  UIWindow+StaySafe.swift
//  StaySafe
//
//  Created by Mazen on 19/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func setInitialFlow() {
        let storyboard: Storyboard
        switch UserDefaults.standard.userType {
        case .person:
            storyboard = Storyboard.person
        default:
            storyboard = Storyboard.onboarding
        }
        
        rootViewController = storyboard.instance.instantiateInitialViewController()
        makeKeyAndVisible()
    }
    
}
