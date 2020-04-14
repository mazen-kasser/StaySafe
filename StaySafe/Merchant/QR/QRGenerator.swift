//
//  QRManager.swift
//  StaySafe
//
//  Created by Mazen on 8/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

enum QRGenerator {
    
    static func generateQRCode(from string: String) -> UIImage? {
        
        // Get data from the string
        let encoded = encode(string)
        
        guard let scaledQrImage = encoded.qrImage,
            let logoImage = UIImage(named: "COVID-19-logo"),
            let logo = CIImage(image: logoImage),
            let mergedQrImage = scaledQrImage.combined(with: logo)
            else { return nil }
        
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(mergedQrImage, from: mergedQrImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
}

// MARK: Base64 encode/decode
extension QRGenerator {
    
    /// Key to encrypt/decyrpt the QR code.
    static let key = "COVID-19Tracer://"
    
    static func encode(_ string: String) -> String {
        return key + (string.toBase64())
    }
    
    static func decode(_ string: String) -> String? {
        guard string.contains(key) else { return nil }
        let text = string.replacingOccurrences(of: key, with: "")
        guard !text.isEmpty else { return nil }
        return text.fromBase64()
    }
}

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(utf8).base64EncodedString()
    }

}

fileprivate extension String {
    
    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        let qrData = data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")

        let qrTransform = CGAffineTransform(scaleX: 10, y: 10)
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
}

fileprivate extension CIImage {
    
    /// Combines the current image with the given image centered.
    func combined(with image: CIImage? = nil) -> CIImage? {
        guard let image = image,
            let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage!
    }
}
