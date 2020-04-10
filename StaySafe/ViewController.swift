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
        static let showCheckins = "showCheckins"
        static let addCheckin = "addCheckin"
    }
    
    var checkinMessage: String!
    
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    @IBOutlet weak var deviceTokenLabel: UILabel!
    
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
        checkinMessage = str ?? "Checked In" + "✅"
        showToast(message: checkinMessage) { [weak self] in
            self?.performSegue(withIdentifier: SegueID.addCheckin, sender: self)
        }
    }
    
}
