//
//  MerchantViewController.swift
//  StaySafe
//
//  Created by Mazen on 7/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import MapKit

class FindMerchantViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var placemarks: [Placemark] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    enum SegueID {
        static let showQRBadge = "showPrintMerchantQR"
    }
    
    @IBOutlet weak var addressSearchField: UISearchBar!
    
    @IBAction func generateQRCode(_ sender: Any) {
        performSegue(withIdentifier: SegueID.showQRBadge, sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PlacemarkCell.self)
        tableView.tableFooterView = UIView()
    }
    
    func getPlaces(searchString: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchString
//        searchRequest.region = mapView.region
        
        let search = MKLocalSearch(request: searchRequest)

        search.start { [weak self] response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
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
            let navController = segue.destination as! UINavigationController
            let vc = navController.viewControllers.first as! MerchantQRViewController
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            vc.placemark = placemarks[indexPath.row]
            
        default:
            break
        }
    }
    
}

extension FindMerchantViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getPlaces(searchString: searchText)
    }
    
}

extension FindMerchantViewController: UITableViewDelegate, UITableViewDataSource {
    
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
