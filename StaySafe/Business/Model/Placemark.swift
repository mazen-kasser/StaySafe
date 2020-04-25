//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation
import MapKit

struct Placemark {
    let businessName: String
    let businessAddress: String
    
    static func transform(_ mapKitItem: MKMapItem) -> Placemark? {
        
        guard let name = mapKitItem.name,
            let address = mapKitItem.placemark.title
            else { return nil }
        
        return Placemark(businessName: name, businessAddress: address)
    }
}

extension Placemark: CustomStringConvertible {
    
    var description: String {
        return """
                \(businessName)
                \(businessAddress)
                """
    }
}
