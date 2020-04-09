//
//  ViewController.swift
//  StaySafe
//
//  Created by Mazen on 6/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum SegueID {
        static let checkins = "CheckinsViewController"
    }
    
    var checkinMessage: String?
    
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    @IBOutlet weak var deviceTokenLabel: UILabel!
    
    @IBAction func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            performSegue(withIdentifier: SegueID.checkins, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let segueID = segue.identifier else { return }
        
        switch segueID {
        case SegueID.checkins:
            let vc = segue.destination as! CheckinViewController
            let vm = CheckinViewModel()
            
            if let checkinMessage = checkinMessage {
                let checkin = Checkin(ownerDisplayName: checkinMessage,
                                      dateOfCreation: Date().debugDescription)
                vm.add(checkin)
            }

            vc.config(vm)
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceTokenLabel.text = UserDefaults.standard.string(forKey: "deviceToken")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
    
}

extension ViewController: QRScannerViewDelegate {
    
    func qrScanningDidStop() {
        
    }
    
    func qrScanningDidFail() {
        presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        let message = str ?? "Checked In" + "✅"
        showToast(message: message)
        checkinMessage = message
        
        performSegue(withIdentifier: SegueID.checkins, sender: self)
    }
    
}
