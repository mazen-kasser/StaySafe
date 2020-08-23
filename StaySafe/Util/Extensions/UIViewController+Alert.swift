//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func presentAlert(title: String,
                      message : String,
                      actionTitle: String = "OK",
                      isCancellable: Bool = false,
                      style: UIAlertController.Style = .alert,
                      handler: ((UIAlertAction) -> Void)? = nil) {
        
        let deviceCompatibleStyle = UIDevice.current.userInterfaceIdiom == .pad ? .alert : style
        let alertController = UIAlertController(title: title, message: message, preferredStyle: deviceCompatibleStyle)
        let okAction = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        alertController.addAction(okAction)
        
        if isCancellable {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

class Alert {
    
    private static func keyWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    static func showLoading(title: String? = "Checked In", message: String? = nil, dismissAfter: TimeInterval = 2, completion: @escaping (() -> Void)) {
        guard
            let keyWindow = keyWindow(),
            MBProgressHUD(for: keyWindow) == nil // No existing HUD is displayed.
        else {
            return
        }
        
        let hud = MBProgressHUD(view: keyWindow)
        hud.removeFromSuperViewOnHide = true
        keyWindow.addSubview(hud)
        hud.show(animated: true)
        
        hud.backgroundView.blurEffectStyle = .regular
        hud.label.text = title
        hud.label.numberOfLines = 0
        hud.detailsLabel.text = message
        hud.detailsLabel.textColor = .black
        
        let imageView = UIImageView(image:#imageLiteral(resourceName: "loading-spinner-1"))
        imageView.animationImages = [#imageLiteral(resourceName: "loading-spinner-1.png"), #imageLiteral(resourceName: "loading-spinner-2.png"), #imageLiteral(resourceName: "loading-spinner-3.png"), #imageLiteral(resourceName: "loading-spinner-4.png")]
        imageView.animationDuration = 2
        imageView.startAnimating()

        hud.customView = imageView
        hud.mode = .customView
        
        UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged,
                             argument: hud.detailsLabel)
        
        hud.completionBlock = {
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged,
                                            argument: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
            completion()
        }
    }
    
    static func hideLoading() {
        guard let keyWindow = keyWindow() else { return }

        MBProgressHUD.hide(for: keyWindow, animated: true)
    }
}




