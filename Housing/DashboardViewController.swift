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
        HouseStore().getHouses { (houses) -> Void in
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
