//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation
import Firebase

struct CheckinItem {
    
    let key: String
    let name: String
    let addedByUser: String
    let ref: DatabaseReference?
    
    init(name: String, addedByUser: String, key: String = "") {
      self.key = key
      self.name = name
      self.addedByUser = addedByUser
      self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
      key = snapshot.key
      let snapshotValue = snapshot.value as! [String: AnyObject]
      name = snapshotValue["name"] as! String
      addedByUser = snapshotValue["addedByUser"] as! String
      ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
      return [
        "name": name,
        "addedByUser": addedByUser,
      ]
    }
}
