//  Copyright © 2019 iProgram. All rights reserved.

import UIKit

class CheckinViewController: UITableViewController {

    private var viewModel: CheckinViewModel!
    @IBOutlet weak var checkinTitleLabel: UILabel!
    @IBOutlet weak var checkinSubtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CheckinCell.self)
        tableView.tableFooterView = UIView()
        reloadHeaderData()
    }
    
    private func addApplicationNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: .willEnterForeground,
                                               name: .willEnterForegroundNotification,
                                               object: nil)
    }
    
    private func removeApplicationNotificationObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addApplicationNotificationObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeApplicationNotificationObservers()
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

extension CheckinViewController {
    @objc func reloadData() {
        tableView.reloadData()
        reloadHeaderData()
    }
    
    func reloadHeaderData() {
        let count = viewModel.checkins.count
        let plural = count > 1 ? "s" : ""
        checkinTitleLabel.text = "You have \(count) check-in\(plural)"
        checkinSubtitleLabel.isHidden = count == 0
    }
}

private extension Selector {
    static let willEnterForeground = #selector(CheckinViewController.reloadData)
}
