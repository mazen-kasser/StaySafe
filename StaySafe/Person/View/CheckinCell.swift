//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class CheckinCell: UITableViewCell {

    @IBOutlet private weak var initialLetterLabel: UILabel!
    @IBOutlet private weak var displayNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var createDateLabel: UILabel!

    var checkin: Checkin? {
        didSet {
            guard let checkin = checkin else { return }
            
            guard let array = checkin.merchantName?.qrComponents,
                array.count > 2
            else { return }
            
            let title = array[0]
            let subtitle = array[1]
            
            initialLetterLabel.text = String(title.first!)
            displayNameLabel.text = title
            addressLabel.text = subtitle
            createDateLabel.text = checkin.createdAt?.formatted ?? Date().formatted
        }
    }

}
