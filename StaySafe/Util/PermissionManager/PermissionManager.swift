//
//  PermissionManager.swift
//  StaySafe
//
//  Created by Mazen on 15/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation
import AVFoundation

class PermissionManager {
    
    static var cameraPermission: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    static func requestCameraAccess(completion: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: .video) { status in
            DispatchQueue.main.async {
                completion(status)
            }
        }
    }

}
