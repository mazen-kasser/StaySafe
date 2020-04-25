//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class PlacemarkCell: UITableViewCell {

    @IBOutlet private weak var businessNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    var placemark: Placemark? = nil {
        didSet {
            guard let placemark = placemark else { return }
            
            businessNameLabel.text = placemark.businessName
            addressLabel.text = placemark.businessAddress
        }
    }
}
