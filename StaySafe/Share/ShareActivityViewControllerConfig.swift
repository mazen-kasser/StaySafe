//
//  ShareActivityViewControllerConfig.swift
//  StaySafe
//
//  Created by Mazen on 7/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import Photos
import UIKit

class ShareActivityViewControllerConfig: NSObject {
	
    private let activityItemProvider: UIActivityItemProvider
    
    init(provider: UIActivityItemProvider) {
        self.activityItemProvider = provider
    }
    
    var viewController: UIActivityViewController {
        
        let printInfo = UIPrintInfo.printInfo()
		printInfo.outputType = UIPrintInfo.OutputType.photo
        let activityItems: [Any] = [activityItemProvider, printInfo]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.excludedActivityTypes = excludedActivityTypes()
        
        return activityVC
    }
    
	private func excludedActivityTypes() -> [UIActivity.ActivityType] {
        if isAllowedToAccessPhoto() {
            return [.postToTwitter, .postToWeibo, .assignToContact]
        }
        return [.postToTwitter, .postToWeibo, .assignToContact, .saveToCameraRoll]
    }
    
    private func isAllowedToAccessPhoto() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        return status == .notDetermined || status == .authorized
    }
}

