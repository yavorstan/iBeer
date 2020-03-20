//
//  FilterScreenViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 20.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class FilterScreenViewController: BAViewController {
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filtersViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var filtersViewTopConstraint: NSLayoutConstraint!
    
    var isCollapsed = Bool()
    
    
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCollapsed = true
        filterButton.setTitle("Expand", for: .normal)
        
        let frame = view.safeAreaLayoutGuide.layoutFrame
        
        filtersViewYConstraint.constant = (filterView.frame.height - frame.height) + 100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Buttons Actions
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        if isCollapsed {
            UIView.animate(withDuration: 0.6, delay: 0.1, options: [.curveEaseOut], animations: {
                self.filtersViewYConstraint.constant = 0
                self.view.layoutIfNeeded()
                self.isCollapsed = false
                self.filterButton.setTitle("Collapse", for: .normal)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.6, delay: 0.1, options: [.curveEaseOut], animations: {
                self.filtersViewYConstraint.constant = 550
                self.view.layoutIfNeeded()
                self.isCollapsed = true
                self.filterButton.setTitle("Expand", for: .normal)
            }, completion: nil)
        }
    }
}
