//
//  ContactUsViewController.swift
//  StaySafe
//
//  Created by Mazen on 13/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit

class ContactUsViewController: UITableViewController {

    @IBOutlet private weak var footerNoteLabel: UILabel!
    @IBOutlet private weak var submitButton: UIBarButtonItem!
    @IBOutlet private weak var contactNameTextField: CATextField!
    @IBOutlet private weak var mobileNumberTextField: CATextField!

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard isScreenValid() else { return }
        
        // TODO: API call
        Alert.showLoading (title: "") { [weak self] in
            Alert.hideLoading()
            self?.closeButtonTapped()
        }
    }
    
    @IBAction func closeButtonTapped() {
        navigationController?.dismiss(animated: true)
    }

    @IBAction func viewTapped(_ sender: Any) {
        tableView.endEditing(true)
    }

    private func isScreenValid() -> Bool {
        return contactNameTextField.isValid(true) &&
            mobileNumberTextField.isValid(true)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // must be called at viewDidAppear to set footer based on screen vs content size
        reloadFooterView()
    }
    
    private func reloadFooterView() {
        tableView.tableFooterView = nil
        
        // create view
        footerNoteLabel.frame.size.width = tableView.bounds.width
        footerNoteLabel.frame.size.height = tableView.bounds.height - tableView.contentSize.height - 100 // bar height
        
        // add view
        let footerView = UIView(frame: footerNoteLabel.frame)
        footerView.addSameSizedSubview(footerNoteLabel)
        
        tableView.tableFooterView = footerView
        // adjust inset
        tableView.clipsToBounds = false
    }
    
}

extension ContactUsViewController {
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.tableView.tableFooterView?.isHidden = true
        coordinator.animateAlongsideTransition(in: nil, animation: nil, completion: {[weak self] _ in
            guard let self = self else { return }
            // required for the iPad to reload receipt footer when orientation change
            self.reloadFooterView()
            self.tableView.tableFooterView?.isHidden = false
        })
    }
    
}

extension ContactUsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mobileNumberTextField.becomeFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        submitButton.isEnabled = isScreenValid()
    }
}

private extension UIView {
    /// Add subView to self, with edge insets.
    func addSameSizedSubview(_ subView: UIView,
                                    edgeInsets: UIEdgeInsets = .zero) {
        addSubview(subView)
        insetSubview(subView, edgeInsets: edgeInsets)
    }
    
    /// Inset subView to self, by edge insets.
    func insetSubview(_ subView: UIView, edgeInsets: UIEdgeInsets) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edgeInsets.left).isActive = true
        trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: edgeInsets.right).isActive = true
        subView.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top).isActive = true
        bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: edgeInsets.bottom).isActive = true
    }
}
