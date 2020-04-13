//  Copyright © 2019 iProgram. All rights reserved.

import UIKit

class CheckinCell: UITableViewCell {

    @IBOutlet private weak var initialLetterView: InitialsView!
    @IBOutlet private weak var displayNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var createDateLabel: UILabel!

    var checkin: Checkin? {
        didSet {
            guard let checkin = checkin else { return }
            // TODO: add field to Checkin object to support name and address
            guard let array = checkin.merchantName?.split(separator: "\n").map({ String($0) }),
                let title = array.first,
                let subtitle = array.last
                else { return }
            
            initialLetterView.initialsText = String(title.first!)
            displayNameLabel.text = title
            addressLabel.text = subtitle
            createDateLabel.text = DateFormatter.yyyyMMdd.string(from: checkin.createdAt ?? Date())
        }
    }
}
