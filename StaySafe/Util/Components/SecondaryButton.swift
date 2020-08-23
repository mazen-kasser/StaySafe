//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class SecondaryButton: Button {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        clipsToBounds = true
        cornderRadius = 12
        let buttonSize = frame.size
        let backgroundImage = UIImage(color: Color.Secondary.buttonColor, size: buttonSize)
        let disabledBackgroundImage = UIImage(color: Color.Secondary.disabledButtonColor, size: buttonSize)
        setBackgroundImage(backgroundImage, for: .normal)
        setBackgroundImage(disabledBackgroundImage, for: .disabled)
        setTitleColor(Color.Secondary.buttonTitleColor, for: .normal)
        setTitleColor(Color.Secondary.buttonTitleSelectedColor, for: .disabled)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
    }
    
}
