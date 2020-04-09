//  Copyright © 2019 iProgram. All rights reserved.

import Foundation

class CheckinViewModel {
    
    var checkins: [Checkin] = []
    
    func add(_ checkin: Checkin) {
        checkins.append(checkin)
    }
}
