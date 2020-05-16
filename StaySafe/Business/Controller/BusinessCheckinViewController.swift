//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class BusinessCheckinViewController: UITableViewController {

    private var viewModel: BusinessCheckinViewModel!
    @IBOutlet weak var checkinTitleLabel: UILabel!
    @IBOutlet weak var checkinHeader: UIView!
    @IBOutlet weak var checkinFooter: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CheckinCell.self)
        reloadHeaderFooterData()
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

}

extension BusinessCheckinViewController {
    
    func config(_ viewModel: BusinessCheckinViewModel) {
        self.viewModel = viewModel
    }
}

extension BusinessCheckinViewController {
    @objc func reloadData() {
        reloadHeaderFooterData()
        tableView.reloadData()
    }
    
    func reloadHeaderFooterData() {
        let count = viewModel.checkins.count
        let plural = count > 1 ? "s" : ""
        let showHeader = count > 0
        let showFooter = !showHeader
        
        checkinTitleLabel.text = "You have \(count) check-in\(plural)"
        checkinHeader.frame.size.height = showHeader ? 230 : 0
        checkinFooter.frame.size.height = showFooter ? 320 : 0
        checkinHeader.isHidden = showFooter
        checkinFooter.isHidden = showHeader
    }
}

private extension Selector {
    static let willEnterForeground = #selector(BusinessCheckinViewController.reloadData)
}
