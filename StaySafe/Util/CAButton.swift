//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class CAButton: Button {
    
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
        let screenWidth = UIScreen.main.bounds.width
        let buttonSize = CGSize(width: screenWidth - 40, height: 50)
        let backgroundImage = UIImage(color: Color.buttonColor, size: buttonSize)
        let disabledBackgroundImage = UIImage(color: Color.disabledButtonColor, size: buttonSize)
        setBackgroundImage(backgroundImage, for: .normal)
        setBackgroundImage(disabledBackgroundImage, for: .disabled)
        setTitleColor(Color.buttonTitleColor, for: .normal)
        setTitleColor(Color.buttonTitleSelectedColor, for: .disabled)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
    }
    
}
