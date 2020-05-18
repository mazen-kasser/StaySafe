//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class BusinessQRViewController: UIViewController, ShareableScreen {
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    
    enum SegueID {
        static let findBusinessInfo = "showFindBusinessViewController"
    }
    
    var placemark: Placemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaults.standard.isBusinessRegistered {
            Alert.showLoading(title: "", message: "") { [weak self] in
                Alert.hideLoading()
                
                self?.presentAlert(title: "Your badge has been created",
                                   message: "Please check the details to match your place and print",
                                   style: .actionSheet)
            }
        }
        
        let emailAddress = Auth.auth().currentUser?.email ?? ""
        Firestore.firestore().collection("businessAccounts").document(emailAddress).getDocument { (documentSnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                UserDefaults.standard.isBusinessRegistered = true
                
                guard let data = documentSnapshot!.data(),
                    let businessAddress = data["businessAddress"] as? String,
                    let businessName = data["businessName"] as? String
                    else { assertionFailure(); return }
                
                let qrInfo = businessName + "\n" + businessAddress + "\n" + emailAddress
                self.qrImageView.image = QRGenerator.generateQRCode(from: qrInfo)
                self.businessNameLabel.text = businessName
                self.businessAddressLabel.text = businessAddress
            }
            
        }
    }
    
    @IBAction func showScanQR(_ sender: Any) {
        navigationController?.dismiss(animated: true)
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
