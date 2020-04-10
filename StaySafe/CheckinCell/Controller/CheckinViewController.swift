//  Copyright © 2019 iProgram. All rights reserved.

import UIKit

class CheckinViewController: UITableViewController {

    private var viewModel: CheckinViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CheckinCell.self)
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.checkins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CheckinCell.self)
        cell.checkin = viewModel.checkins[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let archiveAction = UITableViewRowAction(style: .default, title: "Archive") { (rowAction, indexPath) in
            let deleteCheckin = self.viewModel.checkins[indexPath.row]
            self.viewModel.delete(deleteCheckin)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }

        return [archiveAction]
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }

}

extension CheckinViewController {
    
    func config(_ viewModel: CheckinViewModel) {
        self.viewModel = viewModel
    }
}

