//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import Foundation

extension Notification.Name {
    static let willEnterForegroundNotification = Notification.Name(rawValue: "willEnterForegroundNotification")
    static let willEnterBackgroundNotification = Notification.Name(rawValue: "willEnterBackgroundNotification")
}

class MainViewController: UIViewController {
    
    enum SegueID {
        static let showCheckins = "showCheckins"
        static let addCheckin = "addCheckin"
    }
    
    var checkinMessage: String!
    private let checkinViewModel = CheckinViewModel()
    
    private let viewModel = MainViewModel()
    
    var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    @IBOutlet weak var qrFrame: UIView!
    @IBOutlet weak var scanQRCodeLabelView: UIVisualEffectView!
    
    private var isTorchOn: Bool = false
    
    @IBOutlet weak var torchBlurBackground: UIVisualEffectView!
    @IBOutlet weak var torchButton: Button!
    @IBOutlet weak var showMyQrCodeButton: Button!
    
    @IBAction func showMyQrCode(_ sender: Any) {
        let storyboard = Storyboard.business
        let vc = storyboard.instance.instantiateInitialViewController()!
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func toggleTorch(_ sender: UIButton) {
        isTorchOn.toggle()
        torchBlurBackground.effect = UIBlurEffect(style: isTorchOn ? .light : .dark)
        torchButton.isSelected = isTorchOn
        torchButton.tintColor = isTorchOn ? .systemBlue : .white
        Device.Torch.toggle(on: isTorchOn)
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
            vc.config(checkinViewModel)
            
        case SegueID.addCheckin:
            let vc = segue.destination as! CheckinViewController
            checkinViewModel.add(checkinMessage)
            vc.config(checkinViewModel)
            
        default:
            break
        }
    }
    
    deinit {
        removeApplicationNotificationObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let midScreenWidth = view.bounds.width / 2 - qrFrame.bounds.width / 2
        let midScreenHeight = view.bounds.height / 2 - qrFrame.bounds.height / 2
        let margin: CGFloat = 8
        let scanningRect = CGRect(x: midScreenWidth, y: midScreenHeight, width: qrFrame.bounds.width - margin, height: qrFrame.bounds.height - margin)
        scannerView = QRScannerView(frame: view.bounds, rectOfInterest: scanningRect)
        view.insertSubview(scannerView, at: 0)
        
        showOnboardingIfRequired()
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

        handleCameraAccess()
        
        addApplicationNotificationObservers()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let userHasCheckedin = checkinViewModel.checkins.count > 0
        scanQRCodeLabelView.isHidden = userHasCheckedin
        
        showMyQrCodeButton.setTitle(viewModel.createQRCodeText, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeApplicationNotificationObservers()
        stopScanning()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

extension MainViewController {
    
    private func handleCameraAccess() {
        
        let showCameraPermission: () -> Void = {
            self.presentAlert(title: "Error", message: "Please enable the Camera permission to be able to scan QR codes", isCancellable: true) { _ in
                // take them to camera settings menu
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        switch PermissionManager.cameraPermission {
        case .authorized:
            startScanning()
            
        case .denied, .restricted:
            showCameraPermission()
            
        default:
            PermissionManager.requestCameraAccess { [weak self] status in
                if status {
                    self?.startScanning()
                } else {
                    showCameraPermission()
                }
            }
        }
    }
}

extension MainViewController: QRScannerViewDelegate {
    
    func qrScanningDidStop() {
        
    }
    
    func qrScanningDidFail() {
        presentAlert(title: "Error", message: "Try to scan `QR Tracer` QR code") { [weak self] _ in
            self?.scannerView.startScanning()
        }
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        guard let message = str else { return }
        
        checkinMessage = message
        
        Alert.showLoading() { [weak self] in
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

extension MainViewController {
    
    func showOnboardingIfRequired() {
        guard !UserDefaults.standard.isDeviceRegistered else { return }
        
        let vc = Storyboard.onboarding.instance.instantiateInitialViewController()!
        present(vc, animated: true)
    }
}

private extension Selector {
    static let willEnterForeground = #selector(MainViewController.startScanning)
    static let willEnterBackground = #selector(MainViewController.stopScanning)
}
