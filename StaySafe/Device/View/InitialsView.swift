//  Copyright © 2019 iProgram. All rights reserved.

import UIKit

class InitialsView: UIView {

    var initialsText: String? {
        didSet {
            initialsLabel.text = initialsText
        }
    }

    private var initialized = false

    @IBOutlet weak private var circleView: UIView!
    @IBOutlet var initialsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        initialsText = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !initialized {
            initializeCircleView()
        }
    }

    private func initializeCircleView() {
        circleView.layer.cornerRadius = circleView.frame.width / 2

        initialized = true
    }
}
