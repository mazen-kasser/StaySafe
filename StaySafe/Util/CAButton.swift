//
//  CAButton.swift
//  StaySafe
//
//  Created by Mazen on 19/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class CAButton: UIButton {
    
    override func awakeFromNib() {
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
        setBackgroundImage(backgroundImage, for: .normal)
        setTitleColor(Color.buttonTitleColor, for: .normal)
        setTitleColor(Color.buttonTitleSelectedColor, for: .disabled)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
    }
    
}
