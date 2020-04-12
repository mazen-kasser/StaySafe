//
//  UIResponder+.swift
//  StaySafe
//
//  Created by Mazen on 12/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

extension UIResponder {
    
    func presentCheckinAlert(_ text: String) {
        guard let message = QRGenerator.decode(text) else { return }
        
        let alertController = UIAlertController(title: "Would you like to checkin?", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            NotificationCenter.default.post(name: .openUrlSchemeNotification, object: message)
        })
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
