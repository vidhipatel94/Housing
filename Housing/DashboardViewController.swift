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
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var rentButton: UIButton!
    
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        cityCollectionView.dataSource = self
        
        changeButtonsUI();
        
        if let user = UserStore.instance.getUser() {
            welcomeLabel.text = welcomeLabel.text! + " " + user.name + "!"
        }
        
        getCitiesWithListing()
    }
    
    private func changeButtonsUI(){
        searchButton.layer.borderColor = UIColor.white.cgColor
        searchButton.layer.borderWidth = 1
        searchButton.layer.cornerRadius = 4
        searchButton.contentEdgeInsets.left = 20
        searchButton.contentEdgeInsets.right = 20
        searchButton.contentEdgeInsets.top = 10
        searchButton.contentEdgeInsets.bottom = 10
        
        let greenColor = UIColor(red: 0.42, green: 0.73, blue: 0.6, alpha: 1).cgColor
        buyButton.layer.borderColor = greenColor
        buyButton.layer.borderWidth = 1
        buyButton.layer.cornerRadius = 4
        buyButton.contentEdgeInsets.left = 20
        buyButton.contentEdgeInsets.right = 20
        buyButton.contentEdgeInsets.top = 10
        buyButton.contentEdgeInsets.bottom = 10
        
        rentButton.layer.borderColor = greenColor
        rentButton.layer.borderWidth = 1
        rentButton.layer.cornerRadius = 4
        rentButton.contentEdgeInsets.left = 20
        rentButton.contentEdgeInsets.right = 20
        rentButton.contentEdgeInsets.top = 10
        rentButton.contentEdgeInsets.bottom = 10
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
            
            // change height of collection view because it is inside scrollview and scoll of collectionview is disabled
            let heightConstraint = self.cityCollectionView.heightAnchor.constraint(equalToConstant: CGFloat((128+10) * self.cityListings.count/2 + 20))
            heightConstraint.isActive = true
            self.cityCollectionView.layoutIfNeeded()
            
            self.cityCollectionView.reloadData()
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
        case "CitySegue"?:
            if let selectedIndexPath = cityCollectionView.indexPathsForSelectedItems?.first {
                let listVC = segue.destination as! ListViewController
                listVC.filter = Filter()
                listVC.filter.city = cityListings[selectedIndexPath.row].city
            }
        default:
            print("Unexpected segue identifier")
        }
    }
    
}

extension DashboardViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityListings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = cityCollectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CityCellView
        let cityListing = cityListings[indexPath.row]
        cellView.titleView.text = cityListing.city
        cellView.imageView.loadUrl(url: cityListing.imageUrl, spinner: cellView.spinnerView)
        return cellView;
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
