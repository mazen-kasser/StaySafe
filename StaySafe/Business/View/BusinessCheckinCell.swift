//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class BusinessCheckinCell: UITableViewCell {

    @IBOutlet private weak var displayNameLabel: UILabel!
    @IBOutlet private weak var mobileNumberTextView: UITextView!
    @IBOutlet private weak var createDateLabel: UILabel!
    
    var businessCheckin: BusinessCheckin? {
        didSet {
            guard let businessCheckin = businessCheckin else { return }
            
            displayNameLabel.text = businessCheckin.userFullName
            mobileNumberTextView.text = businessCheckin.userMobileNumber
            createDateLabel.text = Date().formatted
        }
    }

}
