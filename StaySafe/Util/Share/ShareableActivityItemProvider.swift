//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Photos
import UIKit

 // For more information, see [The StackOverflow discussion.] (https://stackoverflow.com/questions/46566972/request-nsphotolibraryaddusagedescription-permission)
 class ShareableActivityItemProvider: UIActivityItemProvider {

    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(placeholderItem: image)
    }
    
    override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        if activityType == UIActivity.ActivityType.saveToCameraRoll {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus) in
                    if status == .authorized {
                        self.saveToCameraRoll()
                    }
                })
            }
            
            if status == .authorized {
                self.saveToCameraRoll()
            }
            
            // avoid save image twice as we already called UIImageWriteToSavedPhotosAlbum
            return nil
        }
        
        return self.placeholderItem
    }
    
    private func saveToCameraRoll() {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
}
