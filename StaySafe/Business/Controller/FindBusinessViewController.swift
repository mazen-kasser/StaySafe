//
//  FindBusinessViewController.swift
//  StaySafe
//
//  Created by Mazen on 7/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import MapKit

class FindBusinessViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var infoPage: UIStackView!
    
    var placemarks: [Placemark] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    enum SegueID {
        static let showQRBadge = "showPrintMerchantQR"
    }
    
    @IBOutlet weak var addressSearchField: UISearchBar!
    
    @IBAction func closeGenerateQRCode(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PlacemarkCell.self)
        tableView.tableFooterView = UIView()
    }
    
    func getPlaces(searchString: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchString
//        if #available(iOS 13.0, *) {
//            searchRequest.pointOfInterestFilter = .includingAll
//        }
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
//        tableView.isHidden = searchText.isEmpty
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
        performSegue(withIdentifier: SegueID.showQRBadge, sender: self)
    }
    
}
