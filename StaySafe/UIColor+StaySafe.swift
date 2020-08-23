//
//  Copyright © 2020 iProgram. All rights reserved.
//
import UIKit

typealias Color = UIColor
extension Color {
    
    enum Primary {
        static let buttonColor = UIColor(red: 253.0/255, green: 204.0/255, blue: 4.0/255, alpha: 1.0)
        static let disabledButtonColor = UIColor.separator
        static let buttonTitleColor = UIColor.darkGray
        static let buttonTitleSelectedColor = UIColor.lightText
    }
    
    enum Secondary {
        static let buttonColor = UIColor.darkGray
        static let disabledButtonColor = UIColor.separator
        static let buttonTitleColor = UIColor.white
        static let buttonTitleSelectedColor = UIColor.white
    }

}
