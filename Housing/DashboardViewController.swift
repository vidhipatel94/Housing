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
    
    var cities = [City]() // to load in collection view
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var langView: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var rentButton: UIButton!
    
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    //MARK:- on view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        cityCollectionView.dataSource = self
        
        changeButtonsUI();
        
        // Get user from database, add user name to welcome label
        if let user = UserStore.instance.getUser() {
            welcomeLabel.text = welcomeLabel.text! + " " + user.name + "!"
        }
        
        getCities()
        
        // change language view UI
        langView.layer.borderColor = UIColor.white.cgColor
        langView.layer.borderWidth = 0.5
        langView.layer.cornerRadius = 2
        
        // add gesture recognizer to language view to open menu on tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleLangTap(_:)))
        langView.addGestureRecognizer(tap)
    }
    
    private func changeButtonsUI(){
        // search button
        searchButton.layer.borderColor = UIColor.white.cgColor
        searchButton.layer.borderWidth = 1
        searchButton.layer.cornerRadius = 4
        searchButton.contentEdgeInsets.left = 20
        searchButton.contentEdgeInsets.right = 20
        searchButton.contentEdgeInsets.top = 10
        searchButton.contentEdgeInsets.bottom = 10
        
        // buy button
        let greenColor = UIColor(red: 0.42, green: 0.73, blue: 0.6, alpha: 1).cgColor
        buyButton.layer.borderColor = greenColor
        buyButton.layer.borderWidth = 1
        buyButton.layer.cornerRadius = 4
        buyButton.contentEdgeInsets.left = 20
        buyButton.contentEdgeInsets.right = 20
        buyButton.contentEdgeInsets.top = 10
        buyButton.contentEdgeInsets.bottom = 10
        
        // rent button
        rentButton.layer.borderColor = greenColor
        rentButton.layer.borderWidth = 1
        rentButton.layer.cornerRadius = 4
        rentButton.contentEdgeInsets.left = 20
        rentButton.contentEdgeInsets.right = 20
        rentButton.contentEdgeInsets.top = 10
        rentButton.contentEdgeInsets.bottom = 10
    }
    
    //MARK:- get cities and load in collection view
    private func getCities() {
        // HouseStore will fetch cities from database, and if not found, it will get from internet
        HouseStore.instance.getCities { (cities) -> Void in
            print("Total cities: \(cities.count)")
            
            self.cities = cities
            
            // change height of collection view because it is inside scrollview and scoll of collectionview is disabled
            let heightConstraint = self.cityCollectionView.heightAnchor.constraint(equalToConstant: CGFloat((128+10) * self.cities.count/2 + 20))
            heightConstraint.isActive = true
            self.cityCollectionView.layoutIfNeeded()
            
            // load data in collection view
            self.cityCollectionView.reloadData()
        }
    }
    
    //MARK:- open list with different filter data on prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // set filter object in list view controller
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
                listVC.filter.cityId = Int(cities[selectedIndexPath.row].id) // set selected city id
            }
        default:
            print("Unexpected segue identifier")
        }
    }
    
    //MARK:- on tap language view, open menu
    @objc func handleLangTap(_ sender: UITapGestureRecognizer? = nil) {
        becomeFirstResponder()
        
        // create menu and menu items
        let menu = UIMenuController.shared
        let engLangItem = UIMenuItem(title: NSLocalizedString("English", comment: "Language"), action: #selector(self.setEnglishLang(_:)))
        let frLangItem = UIMenuItem(title: NSLocalizedString("French", comment: "Language"), action: #selector(self.setFrenchLang(_:)))
        menu.menuItems = [engLangItem, frLangItem]
        
        // display menu by giving position using rect
        menu.showMenu(from: langView, rect: langView.frame)
    }
    
    @objc func setFrenchLang(_ sender: AnyObject) {
        changeLanguage(lang: "fr-CA")
    }
    
    @objc func setEnglishLang(_ sender: AnyObject) {
        changeLanguage(lang: "en")
    }
    
    func changeLanguage(lang: String) {
        // save to database
        LanguageStore.instance.saveLanguage(lang: lang)
        
        // change app language using bundle
        Bundle.setLanguage(lang)
        
        // reload storyboard
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    // used in menu
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

//MARK:- for city collection view
extension DashboardViewController : UICollectionViewDataSource {
    
    // total cities
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    // get reusable cell and set title and image, and return cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = cityCollectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CityCellView
        let city = cities[indexPath.row]
        cellView.titleView.text = city.name
        if let imageUrl = city.photo {
            cellView.imageView.loadUrl(url: imageUrl, spinner: cellView.spinnerView)
        }
        return cellView;
    }
}
