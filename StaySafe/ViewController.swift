//
//  ViewController.swift
//  StaySafe
//
//  Created by Mazen on 6/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import Foundation

extension Notification.Name {
    static let willEnterForegroundNotification = Notification.Name(rawValue: "willEnterForegroundNotification")
    static let willEnterBackgroundNotification = Notification.Name(rawValue: "willEnterBackgroundNotification")
}

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
    
    deinit {
        removeApplicationNotificationObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func addApplicationNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: .willEnterForeground,
                                               name: .willEnterForegroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: .willEnterBackground,
                                               name: .willEnterBackgroundNotification,
                                               object: nil)
    }
    
    private func removeApplicationNotificationObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startScanning()
        addApplicationNotificationObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeApplicationNotificationObservers()
        stopScanning()
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
        guard let message = str else { return }
        
        checkinMessage = message
        
        Alert.showLoading(message: "@ \(message)") { [weak self] in
            Alert.hideLoading()
            self?.performSegue(withIdentifier: SegueID.addCheckin, sender: self)
        }
    }
    
    @objc func startScanning() {
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    @objc func stopScanning() {
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
    
}

private extension Selector {
    static let willEnterForeground = #selector(ViewController.startScanning)
    static let willEnterBackground = #selector(ViewController.stopScanning)
}
