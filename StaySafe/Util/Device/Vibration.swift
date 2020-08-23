//
//  Copyright © 2020 iProgram. All rights reserved.
//

import AVFoundation
import UIKit

enum Device {
    
    // MARK: Flash light
    enum Torch {
        
        static func toggle(on: Bool) {
            guard
                let device = AVCaptureDevice.default(for: AVMediaType.video),
                device.hasTorch
            else { return }

            do {
                try device.lockForConfiguration()
                device.torchMode = on ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        }
    }
    
    // MARK: Vibration
    enum Vibration {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
        case selection

        func vibrate() {

          switch self {
          case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)

          case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

          case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)

          case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

          case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

          case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()

          case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
          }

        }

    }

}

