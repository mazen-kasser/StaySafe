//
//  UIViewController+Alert.swift
//  StaySafe
//
//  Created by Mazen on 8/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func presentAlert(withTitle title: String, message : String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
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
        hud.backgroundView.color = UIColor(white: 0.0, alpha: 0.4)
        hud.bezelView.color = .white
        hud.label.text = title
        hud.label.numberOfLines = 0
        hud.detailsLabel.text = message
        hud.detailsLabel.textColor = .black
        hud.customView = UIImageView(image: #imageLiteral(resourceName: "success") )
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




