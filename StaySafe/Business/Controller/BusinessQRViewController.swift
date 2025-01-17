//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class BusinessQRViewController: UIViewController, ShareableScreen {
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emailAddress = Auth.auth().currentUser?.email ?? ""
        Firestore.firestore().collection("businessAccounts").document(emailAddress).getDocument { [weak self] (documentSnapshot, err) in
            guard let self = self else { return }
            
            if let err = err {
                print("Error getting documents: \(err)")
                self.presentAlert(title: "Error",
                                  message: "Sorry, we failed to retrieve your badge",
                                  style: .alert)
            } else {
                guard let data = documentSnapshot!.data(),
                    let businessAddress = data["businessAddress"] as? String,
                    let businessName = data["businessName"] as? String
                    else { assertionFailure(); return }
                
                let qrInfo = businessName + "\n" + businessAddress + "\n" + emailAddress
                self.qrImageView.image = QRGenerator.generateQRCode(from: qrInfo)
                self.businessNameLabel.text = businessName
                self.businessAddressLabel.text = businessAddress
                
                if !UserDefaults.standard.isBusinessRegistered {
                    UserDefaults.standard.isBusinessRegistered = true
                    Alert.showLoading(title: "", message: "") { [weak self] in
                        Alert.hideLoading()
                        
                        self?.presentAlert(title: "Your badge has been created",
                                           message: "Please check the details to match your place and print",
                                           style: .actionSheet)
                    }
                }
            }
            
        }
    }
    
    @IBAction func sharePage(_ sender: Any) {
        // ugly way to revert colors when dark mode is on
        let color1 = view.backgroundColor
        let color2 = noteLabel.textColor
        let color3 = businessNameLabel.textColor
        let color4 = businessAddressLabel.textColor
        let color5 = titleLabel.textColor
        
        printableColors(.white, .black, .black, .black, .black)
        displayShareOptions(popoverDelegate: self)
        printableColors(color1, color2, color3, color4, color5)
    }
    
    
    private func printableColors(_ color1: UIColor?, _ color2: UIColor?, _ color3: UIColor?, _ color4: UIColor?, _ color5: UIColor?) {
        if #available(iOS 12.0, *) {
            if view.traitCollection.userInterfaceStyle == .dark {
                view.backgroundColor = color1
                noteLabel.textColor = color2
                businessNameLabel.textColor = color3
                businessAddressLabel.textColor = color4
                titleLabel.textColor = color5
            }
        }
    }
    
}

extension BusinessQRViewController: UIPopoverPresentationControllerDelegate {
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.barButtonItem = navigationItem.rightBarButtonItem
    }
}
