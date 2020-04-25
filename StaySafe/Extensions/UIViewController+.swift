//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Instantiates a view controller from within a storyboard where the nib name is the same as the custom view controller class name.
    ///
    /// Returns a strongly typed object of the correct type.
    class func instantiate(from storyboard: Storyboard) -> Self {
        return instantiateFromStoryboard(from: storyboard)
    }
    
    private class func instantiateFromStoryboard<T: UIViewController>(from storyboard: Storyboard) -> T {
        let identifier = String(describing: self)
        guard let viewController = storyboard.instance.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Couldn’t instantiate view controller with identifier \(identifier)")
        }
        return viewController
    }
}
