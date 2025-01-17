//
//  Copyright © 2020 iProgram. All rights reserved.
//

import DHSmartScreenshot
import Photos
import UIKit

enum Side: Int {
    case left = 0
    case right = 1
}

protocol ShareableScreen {
    func displayShareOptions(popoverDelegate: UIPopoverPresentationControllerDelegate)
    func applyShareButton(for side: Side, selector: Selector)
}

extension ShareableScreen where Self: UIViewController {
    
    func applyShareButton(for side: Side, selector: Selector) {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: selector)
        
        switch side {
        case .left: navigationItem.leftBarButtonItem = button
        case .right: navigationItem.rightBarButtonItem = button
        }
    }
    
    private func createImage(_ view: UIView) -> UIImage {
        let image: UIImage
        if let tableView = view as? UITableView {
            image = tableView.screenshot()
        } else if let scrollView = view as? UIScrollView {
            image = scrollView.screenshotOfVisibleContent()
        } else {
            image = view.screenshot()
        }
        
        return image
    }
    
    
    /// Display the Share Sheet with platform options for sharing an image. The image will be this
    /// View Controller's scroll view content, and if a ReceiptFooterView exists in the view hierirchy
    /// it will be appended below.
    ///
    /// - parameter popoverDelegate: The popover presentation delegate
    func displayShareOptions(popoverDelegate: UIPopoverPresentationControllerDelegate) {
        let image = createImage(view)
        
        let shareableProvider = ShareableActivityItemProvider(image: image)
        let activityVC = ShareActivityViewControllerConfig(provider: shareableProvider).viewController
        
        activityVC.popoverPresentationController?.delegate = popoverDelegate
        
        present(activityVC, animated: true, completion: nil)
    }
}
