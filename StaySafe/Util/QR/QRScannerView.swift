//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

/// Delegate callback for the QRScannerView.
protocol QRScannerViewDelegate: class {
    func qrScanningDidFail()
    func qrScanningSucceededWithCode(_ str: String?)
    func qrScanningDidStop()
}

class QRScannerView: UIView {
    
    weak var delegate: QRScannerViewDelegate?
    
    /// capture settion which allows us to start and stop scanning.
    var session = AVCaptureSession()
    
    required init(frame: CGRect, rectOfInterest: CGRect) {
        super.init(frame: frame)
        doInitialSetup(rectOfInterest)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // overriding the layerClass to return `AVCaptureVideoPreviewLayer`
    override class var layerClass: AnyClass  {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
}
extension QRScannerView {
    
    var isRunning: Bool {
        return session.isRunning
    }
    
    func startScanning() {
        session.startRunning()
    }
    
    func stopScanning() {
        session.stopRunning()
        delegate?.qrScanningDidStop()
    }
    
    /// Does the initial setup for captureSession
    private func doInitialSetup(_ rectOfInterest: CGRect) {
        clipsToBounds = true
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        let input: AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error {
            print(error)
            return
        }
        
        session.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
        
        self.layer.session = session
        self.layer.videoGravity = .resizeAspectFill
        
        session.commitConfiguration()
        session.startRunning()
        
        // set scanning rect
        output.rectOfInterest = layer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    func found(code: String) {
        if let decoded = QRGenerator.decode(code) {
            delegate?.qrScanningSucceededWithCode(decoded)
        } else {
            delegate?.qrScanningDidFail()
        }
    }
    
}

extension QRScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        stopScanning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            Device.Vibration.success.vibrate()
            found(code: stringValue)
        }
    }
    
}
