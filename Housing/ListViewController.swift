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
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.houses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell") as! FilterTableViewCell
        cell.selectionStyle = .none
        let details = self.houses[indexPath.row]
        cell.lbl_Title.text = details.title
        cell.lbl_City.text = details.city
        cell.lbl_Price.text = "$ \(details.price ?? 0.0)"
        cell.lbl_Type.text = details.type
        print(details.photos[0])
        cell.imgView_Image?.loadUrl(url: details.photos[0], spinner: cell.loader)
        return cell
    }
    
    
}

extension UIViewController {
    
    func showAlert(_ message:String)  {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

}
