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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       getFilteredHouses()
    }
    
    func getFilteredHouses() {
        HouseStore.instance.getFilteredHouses(filter: filter) { (houses)-> Void in
            self.houses = houses
            print("Total filtered houses: \(houses.count)")
            // reload table view
        }
    }
    
}
