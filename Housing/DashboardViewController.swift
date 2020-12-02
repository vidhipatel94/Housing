//
//  DashboardViewController.swift
//  Housing
//
//  Created on 29/11/20.
//  Author: Waqas Basir
//  Copyright © 2020 Conestoga. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    var cityListings = [CityListing]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        getCitiesWithListing()
        
    }
    
    private func getCitiesWithListing() {
        HouseStore.instance.getHouses { (houses) -> Void in
            print("Total houses: \(houses.count)")
            if houses.count > 0 {
                for house in houses {
                    if let cityListing = self.cityListings.first(where: { $0.city == house.city }) {
                        cityListing.noOfHouses += 1
                    } else {
                        let imageUrl = house.photos != nil && house.photos.count > 0 ? house.photos[0] : nil
                        self.cityListings.append(CityListing(city: house.city, noOfHouses: 1, imageUrl: imageUrl))
                    }
                }
            }
            
            // reload collection view
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BuyHouseSegue"?:
            let listVC = segue.destination as! ListViewController
            listVC.filter = Filter()
            listVC.filter.onBuy = true
            listVC.filter.onRent = false
        case "RentHouseSegue"?:
            let listVC = segue.destination as! ListViewController
            listVC.filter = Filter()
            listVC.filter.onBuy = false
            listVC.filter.onRent = true
        default:
            print("Unexpected segue identifier")
        }
    }
    
}

class CityListing {
    let city: String
    var noOfHouses: Int
    let imageUrl: String!
    
    init(city: String, noOfHouses: Int, imageUrl: String!){
        self.city = city
        self.noOfHouses = noOfHouses
        self.imageUrl = imageUrl
    }
}
