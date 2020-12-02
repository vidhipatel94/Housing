//
//  ListViewController.swift
//  Housing
//
//  Created on 29/11/20.
//  Author: Simranjit Singh
//  Copyright © 2020 Conestoga. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var filter = Filter()
    var houses = [House]()
    
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshRequired = true;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if refreshRequired {
            getFilteredHouses()
        }
    }
    
    func getFilteredHouses() {
        HouseStore.instance.getFilteredHouses(filter: filter) { (houses)-> Void in
            self.houses = houses
            print("Total filtered houses: \(houses.count)")
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "DetailSegue"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let house = houses[row]
                let detailVC = segue.destination as! DetailViewController
                detailVC.house = house
                refreshRequired = false
            }
        case "FilterSegue"?:
            let filterVC = segue.destination as! FilterViewController
            filterVC.filter = filter
            refreshRequired = true
        default:
            print("Unexpected segue identifier")
            refreshRequired = false
        }
    }
    
}
