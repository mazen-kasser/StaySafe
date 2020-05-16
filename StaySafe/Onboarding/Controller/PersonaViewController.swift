//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class PersonaViewController: UITableViewController {
    
    enum SegueID {
        static let login = "showLoginViewController"
        static let contactUs = "showContactUsViewController"
    }
    
    @IBOutlet private weak var nextButton: UIButton!
    
    @IBAction func nextButtonSelected(_ sender: Any) {
        let persona: UserType = tableView.indexPathForSelectedRow?.section == 0 ? .business : .person
        UserDefaults.standard.userType = persona
        
        showNextFlow(persona)
    }
    
    private func showNextFlow(_ persona: UserType?) {
        switch persona {
        case .business:
            performSegue(withIdentifier: SegueID.login, sender: self)
        case .person:
            performSegue(withIdentifier: SegueID.contactUs, sender: self)
        default:
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        nextButton.isEnabled = true
        
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
}
