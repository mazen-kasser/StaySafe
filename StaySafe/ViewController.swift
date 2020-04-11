//
//  ViewController.swift
//  StaySafe
//
//  Created by Mazen on 6/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    enum SegueID {
        static let showCheckins = "showCheckins"
        static let addCheckin = "addCheckin"
    }
    
    var checkinMessage: String!
    
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    @IBAction func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            performSegue(withIdentifier: SegueID.showCheckins, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let segueID = segue.identifier else { return }
        
        switch segueID {
        case SegueID.showCheckins:
            let vc = segue.destination as! CheckinViewController
            let vm = CheckinViewModel()
            vc.config(vm)
            
        case SegueID.addCheckin:
            let vc = segue.destination as! CheckinViewController
            let vm = CheckinViewModel()
            vm.add(checkinMessage)
            vc.config(vm)
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !scannerView.isRunning {
            scannerView.startScanning()
        }
        
        // check if the user coming from a deep link
        if let address = UserDefaults.standard.checkinAddress {
            if !scannerView.isRunning {
                scannerView.stopScanning()
            }
            qrScanningSucceededWithCode(address)
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
        presentAlert(withTitle: "Error", message: "Try to scan COVID-Alert QR code") { [weak self] _ in
            self?.scannerView.startScanning()
        }
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        if UserDefaults.standard.checkinAddress != nil {
            UserDefaults.standard.checkinAddress = nil
        }
        
        checkinMessage = str ?? "Checked In" + "✅"
        showToast(message: checkinMessage) { [weak self] in
            self?.performSegue(withIdentifier: SegueID.addCheckin, sender: self)
        }
    }
    
}
