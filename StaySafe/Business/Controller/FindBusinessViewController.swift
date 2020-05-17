//
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseFirestore

class FindBusinessViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var infoPage: UIStackView!
    
    enum SegueID {
        static let showQRBadge = "showBusinessQRViewController"
    }
    
    var placemarks: [Placemark] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var addressSearchField: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PlacemarkCell.self)
        tableView.tableFooterView = UIView()
    }
    
    func getPlaces(searchString: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchString
        searchRequest.pointOfInterestFilter = .includingAll
//        searchRequest.region = mapView.region
        
        let search = MKLocalSearch(request: searchRequest)

        search.start { [weak self] response, error in
            guard let response = response else {
                self?.placemarks.removeAll()
                return
            }

            self?.placemarks = response.mapItems.compactMap { Placemark.transform($0) }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let segueID = segue.identifier else { return }

        switch segueID {
        case SegueID.showQRBadge:
            let vc = segue.destination as! BusinessQRViewController

            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            vc.placemark = placemarks[indexPath.row]

        default:
            break
        }
    }
    
}

extension FindBusinessViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        infoPage.isHidden = !searchText.isEmpty
        getPlaces(searchString: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension FindBusinessViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placemarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PlacemarkCell.self)
        cell.placemark = placemarks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let placemark = placemarks[indexPath.row]
        
        let deviceToken = UserDefaults.standard.deviceToken ?? ""
        let fullName = UserDefaults.standard.fullName ?? ""
        let mobileNumber = UserDefaults.standard.mobileNumber ?? ""
        let emailAddress = Auth.auth().currentUser?.email ?? ""
        
        Firestore.firestore().collection("businessAccounts").document(emailAddress).setData([
            "ownerFullName": fullName,
            "ownerMobileNumber": mobileNumber,
            "deviceToken": deviceToken,
            "businessAddress": placemark.businessAddress,
            "businessName": placemark.businessName,
            "createdAt": Date().formatted
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: SegueID.showQRBadge, sender: self)
            }
        }
        
    }
    
}
