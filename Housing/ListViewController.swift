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
    
    var filter = Filter() // applied filter
    var houses = [House]() // list of houses loaded in table view
    var cities = [City]() // used to show city name in table cell
    
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshRequired = true; // if filter applied
    
    //MARK:- Get cities. If returned from filter screen, refresh house list
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cities.count == 0 {
            getCities()
        }
        if refreshRequired {
            getFilteredHouses()
        }
    }
    
    private func getCities() {
        HouseStore.instance.getCities { (cities) -> Void in
            self.cities = cities
            self.tableView.reloadData()
        }
    }
    
    func getFilteredHouses() {
        HouseStore.instance.getFilteredHouses(filter: filter) { (houses)-> Void in
            self.houses = houses
            print("Total filtered houses: \(houses.count)")
            self.tableView.reloadData()
        }
    }
    
    // returns city name corresponds to id
    func getCityName(id:Int)->String! {
        if cities.count > 0 {
            let filteredCities = cities.filter { ( $0.id == id ) }
            if filteredCities.count > 0, let city = filteredCities.first {
                return city.name
            }
        }
        return nil
    }
    
    //MARK:- Set values to next view controller before opening
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "DetailSegue"?:
            // get selected house and open detail screen
            if let row = tableView.indexPathForSelectedRow?.row {
                let house = houses[row]
                let detailVC = segue.destination as! DetailViewController
                detailVC.house = house
                detailVC.cityName = getCityName(id: Int(house.cityId))
                refreshRequired = false
            }
        case "FilterSegue"?:
            // open filter screen
            let filterVC = segue.destination as! FilterViewController
            filterVC.filter = filter
            refreshRequired = true
        default:
            print("Unexpected segue identifier")
            refreshRequired = false
        }
    }
    
    // reload data on back from previous screen
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        self.tableView.reloadData()
    }
}

//MARK:- For house list
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Total houses in list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.houses.count
    }
    
    // Get resuable cell and set values
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell") as! FilterTableViewCell
        cell.selectionStyle = .none
        let details = self.houses[indexPath.row]
        cell.lbl_Title.text = details.title
        cell.lbl_City.text = self.getCityName(id: Int(details.cityId))
        cell.lbl_Price.text = "$ \(details.price)"
        cell.lbl_Type.text = details.type
        cell.imgView_Image?.loadUrl(url: details.photos[0] as String, spinner: cell.loader)
        return cell
    }
}

