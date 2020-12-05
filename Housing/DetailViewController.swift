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
            self.house = houses[2]
            //print(self.house.toString())
            self.photosCollectionView.reloadData()
            
            HouseStore.instance.fetchImage(for: self.house.photos[0]) { (imageResult)->Void in
                switch(imageResult) {
                case let .Success(image):
                    self.bigImageView.image = image
                case let .failure(error):
                    print("Error on fetching image \(error)")
                }
            }
            
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
        return photosCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! DetailPhotoCellView
    }
}

extension DetailViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        if let _ = house, let _ = house.photos {
            
            let photo = house.photos[indexPath.row]
            
            HouseStore.instance.fetchImage(for: photo) { (imageResult) in
                guard
                    let photoIndex = self.house.photos.firstIndex(of: photo),
                    case let .Success(image) = imageResult
                    else {
                        return
                }
                let photoIndexPath = IndexPath(item: photoIndex, section: 0)
                if let cell = self.photosCollectionView.cellForItem(at: photoIndexPath) as? DetailPhotoCellView {
                    cell.updateView(image)
                }
            }
            
        }
    }
}

extension UIImageView {
    
}
