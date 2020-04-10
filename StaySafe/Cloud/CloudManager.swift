//
//  CloudManager.swift
//  StaySafe
//
//  Created by Mazen on 10/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation
import CloudKit

class CloudManager {
    
    static let shared = CKContainer.default().publicCloudDatabase

}
