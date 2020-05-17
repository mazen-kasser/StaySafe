//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import Firebase

class BusinessCheckinViewController: UITableViewController {

    private var viewModel = BusinessCheckinViewModel()
    @IBOutlet weak var checkinTitleLabel: UILabel!
    @IBOutlet weak var checkinHeader: UIView!
    @IBOutlet weak var checkinFooter: UIView!
    
    var items: [BusinessCheckin] = []
    
    @IBAction func signoutPressed(_ sender: Any) {
        try? Auth.auth().signOut()
        
        navigationController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(BusinessCheckinCell.self)
        reloadHeaderFooterData()
        
        let businessEmail = Auth.auth().currentUser?.email ?? ""
        
        Firestore.firestore().collection("businessAccounts/\(businessEmail)/checkins").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    guard
                        let userMobileNumber = data["userMobileNumber"] as? String,
                        let userFullName = data["userFullName"] as? String,
                        let deviceToken = data["deviceToken"] as? String,
                        let createdAt = data["createdAt"] as? String
                        else { continue }
                    
                    let checkin = BusinessCheckin(deviceToken: deviceToken,
                                                  userFullName: userFullName,
                                                  userMobileNumber: userMobileNumber,
                                                  createdAt: createdAt)
                    
                    self.items.append(checkin)
                }
                self.reloadData()
            }
        }
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
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(BusinessCheckinCell.self)
        cell.businessCheckin = items[indexPath.row]
        return cell
    }

}

extension BusinessCheckinViewController {
    @objc func reloadData() {
        reloadHeaderFooterData()
        tableView.reloadData()
    }
    
    func reloadHeaderFooterData() {
        let count = items.count
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
