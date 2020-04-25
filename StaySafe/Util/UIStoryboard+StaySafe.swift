//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

// TODO: use swiftgen template to automate this?
enum Storyboard: String {
    case onboarding = "Onboarding"
    case business = "Business"
    case person = "Person"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

extension UIStoryboard {
    convenience init(name: Storyboard, bundle: Bundle? = nil) {
        self.init(name: name.rawValue, bundle: bundle)
    }
}
