//
//  AppDelegate+TextFieldRules.swift
//  StaySafe
//
//  Created by Mazen on 28/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

extension AppDelegate {
    
    func handleValidationRules() {
        try! ValidationRulesRegistry.addRulesToRegistry(BusinessValidationRule.rules)
    }
}
