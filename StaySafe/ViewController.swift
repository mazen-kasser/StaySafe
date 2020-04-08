//
//  ViewController.swift
//  StaySafe
//
//  Created by Mazen on 6/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    @IBOutlet weak var deviceTokenLabel: UILabel!
    
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
        showToast(message: str ?? "Checked In" + "✅")
    }
    
}
