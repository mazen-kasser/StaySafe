//  Copyright © 2019 iProgram. All rights reserved.

import UIKit

class CheckinCell: UITableViewCell {

    @IBOutlet private weak var displayNameLabel: UILabel!
    @IBOutlet private weak var createDateLabel: UILabel!

    var checkin: Checkin? {
        didSet {
            guard let checkin = checkin else { return }
            
            displayNameLabel.text = checkin.merchantName
            createDateLabel.text = DateFormatter.yyyyMMdd.string(from: checkin.createdAt ?? Date())
        }
    }
}
