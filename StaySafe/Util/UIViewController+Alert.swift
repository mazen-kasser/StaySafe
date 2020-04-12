//
//  UIViewController+Alert.swift
//  StaySafe
//
//  Created by Mazen on 8/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(withTitle title: String, message : String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showToast(message : String, seconds: Double = 2.0, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            alert.dismiss(animated: true, completion: completion)
        }
    }
}
