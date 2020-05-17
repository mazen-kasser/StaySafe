//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTarget(self, action: .touchDown, for: .touchDown)
    }
    
    deinit {
        removeTarget(self, action: .touchDown, for: .touchDown)
    }
    
    @objc func touchDown(_ sender: UIButton) {
        Device.Vibration.selection.vibrate()
    }
    
}

private extension Selector {
    static let touchDown = #selector(Button.touchDown(_:))
}
