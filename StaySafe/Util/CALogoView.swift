//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

@IBDesignable
class CALogoView: UIView {
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadAndAddSubviewFromNib()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
//        alpha = 0
//        UIView.animate(withDuration: 1) { [weak self] in
//            self?.alpha = 1
//        }
    }
}
