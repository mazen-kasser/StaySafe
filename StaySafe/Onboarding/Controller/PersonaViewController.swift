//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class PersonaViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show onboarding page
        let vc = SlideViewController.instantiate(from: .onboarding)
        present(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
