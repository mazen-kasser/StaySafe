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
        guard let scaledQrImage = string.qrImage else { return nil }
        
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
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
