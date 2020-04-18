//
//  PersonaViewController.swift
//  StaySafe
//
//  Created by Mazen on 15/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class PersonaViewController: UITableViewController {
    
    @IBOutlet private weak var nextButton: UIButton!
    
    @IBAction func nextButtonSelected(_ sender: Any) {
        let persona: UserType = tableView.indexPathForSelectedRow?.row == 0 ? .business : .person
        UserDefaults.standard.userType = persona
        
        showNextFlow(persona, animated: true)
    }
    
    private func showNextFlow(_ persona: UserType?, animated: Bool) {
        let storyboard: UIStoryboard
        switch persona {
        case .business:
            storyboard = Storyboard.business.instance
        case .person:
            storyboard = Storyboard.person.instance
        default:
            return
        }
        
        let rootViewController = storyboard.instantiateInitialViewController()!
        rootViewController.modalPresentationStyle = .fullScreen
        present(rootViewController, animated: animated)
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
