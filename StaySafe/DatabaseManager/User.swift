//
//  Copyright © 2020 iProgram. All rights reserved.
//

import Foundation

struct User {
  
  let uid: String
  let email: String
  
  init(authData: User) {
    uid = authData.uid
    email = authData.email
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
  
}
