//
//  DetailViewController.swift
//  Housing
//
//  Created on 29/11/20.
//  Author: Vidhi Patel
//  Copyright © 2020 Conestoga. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var house: House!
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var bigImageSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rentOrBuyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var amenitiesStackView: UIStackView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        HouseStore.instance.getHouses { (houses)-> Void in
            self.house = houses[0]
            self.photosCollectionView.reloadData()
            
            self.loadBigImage(imageUrl: self.house.photos[0])
            
            self.loadData();
        }
        
    }
    
    func loadData() {
        priceLabel.text = "$\(String(format: "%.2f", house.price))"
        rentOrBuyLabel.text = house.onRent ? "For Rent" : "For Sale"
        titleLabel.text = house.title
        addressLabel.text = house.address
        cityLabel.text = house.city
        typeLabel.text = house.type
        sizeLabel.text = house.size
        
        if let amenities = house.amenities {
            for amenity in amenities {
                let label = UILabel()
                label.text = "\u{2022} \(amenity)"
                label.textColor = typeLabel.textColor
                label.font = typeLabel.font
                amenitiesStackView.addArrangedSubview(label)
            }
        }
        
        let location = CLLocation(latitude: house.latitude, longitude: house.longitude)
        let regionRadius = 1000
        let region = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: CLLocationDistance(regionRadius), longitudinalMeters: CLLocationDistance(regionRadius))
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: house.latitude, longitude: house.longitude)
        annotation.title = house.title
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func onClickContact(_ sender: Any) {
        if let _ = house, let contactNo = house.contactNo {
            let title = "Contact Owner";
            let actionCancelStr = "Cancel";
            let actionSMSStr = "Send SMS";
            let smsMessage = "Hello, I'm from Housing app. I am interested in your house " + house.title;
            
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: actionCancelStr, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            let smsAction = UIAlertAction(title: actionSMSStr, style: .default, handler: {
                (action) -> Void in
                let sms: String = "sms:\(contactNo)&body=\(smsMessage)"
                let urlStr: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                UIApplication.shared.open(URL.init(string: urlStr)!, options: [:], completionHandler: nil)
            })
            alert.addAction(smsAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func loadBigImage(imageUrl: String){
        bigImageView.loadUrl(url: imageUrl, spinner: bigImageSpinner)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "MapSegue"?:
            let mapVC = segue.destination as! MapViewController
            mapVC.latitude = house.latitude
            mapVC.longitude = house.longitude
            mapVC.houseTitle = house.title
        default:
            print("Segue id not found")
        }
    }
}

extension DetailViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = house, let _ = house.photos {
            print(house.photos.count)
            return house.photos.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! DetailPhotoCellView
        cellView.imageView.loadUrl(url: house.photos[indexPath.row], spinner: cellView.spinnerView)
        return cellView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row;
        if let photos = house.photos, index < photos.count {
            loadBigImage(imageUrl: house.photos[index])
        }
    }
}

extension DetailViewController : UICollectionViewDelegate {
    
}
