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
    var cityName: String!
    
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
    
    
    //MARK:- load data on view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if house nil, show error
        if house == nil {
            showAlert(NSLocalizedString("Sorry, house information not found!", comment: "Error"))
            return
        }
        
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        // load data into view
        loadBigImage(imageUrl: self.house.photos[0] as String)// show first photo in list
        photosCollectionView.reloadData()
        loadData();
    }
    
    func loadData() {
        priceLabel.text = "$\(String(format: "%.2f", house.price))"
        rentOrBuyLabel.text = house.onRent ? NSLocalizedString("For Rent", comment: "For Rent") : NSLocalizedString("For Sale", comment: "For Sale")
        titleLabel.text = house.title
        addressLabel.text = house.address
        cityLabel.text = cityName
        typeLabel.text = house.type
        sizeLabel.text = house.size
        
        // add amenities in stack view by adding label at run-time
        for amenity in house.amenities {
            let label = UILabel()
            label.text = "\u{2022} \(amenity)" // with bullet point
            label.textColor = typeLabel.textColor
            label.font = typeLabel.font
            amenitiesStackView.addArrangedSubview(label)
        }
        
        // set location in map preview
        let location = CLLocation(latitude: house.latitude, longitude: house.longitude)
        let regionRadius = 1000
        let region = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: CLLocationDistance(regionRadius), longitudinalMeters: CLLocationDistance(regionRadius))
        mapView.setRegion(region, animated: false)
        
        // add annotation for house in map preview
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: house.latitude, longitude: house.longitude)
        annotation.title = house.title
        mapView.addAnnotation(annotation)
    }
    
    //MARK:- on click contact, open alert to give option to send SMS to owner
    @IBAction func onClickContact(_ sender: Any) {
        if let _ = house, let contactNo = house.contactNo {
            let title = NSLocalizedString("Contact Owner", comment: "Title");
            let actionCancelStr = NSLocalizedString("Cancel", comment: "Button");
            let actionSMSStr = NSLocalizedString("Send SMS", comment: "Button");
            let smsMessage = NSLocalizedString("Hello, I'm from Housing app. I am interested in your house: ", comment: "Message") + house.title!;
            
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: actionCancelStr, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            // on click SMS, open device default messaging app with predefined message
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
    
    // show big image
    private func loadBigImage(imageUrl: String){
        bigImageView.loadUrl(url: imageUrl, spinner: bigImageSpinner)
    }
    
    //MARK:- on click map, open map screen and pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "MapSegue"?:
            let mapVC = segue.destination as! MapViewController
            mapVC.latitude = house.latitude
            mapVC.longitude = house.longitude
            mapVC.houseTitle = house.title ?? ""
        default:
            print("Segue id not found")
        }
    }
}

//MARK:- Collection view for photos
extension DetailViewController : UICollectionViewDataSource {
    
    // total photos
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = house {
            return house.photos.count
        }
        return 0
    }
    
    // return reusable cell by loading image
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! DetailPhotoCellView
        cellView.imageView.loadUrl(url: house.photos[indexPath.row] as String, spinner: cellView.spinnerView)
        return cellView
    }
    
    // on click photo from collection view, load that photo in big imageview
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row;
        if index < house.photos.count {
            loadBigImage(imageUrl: house.photos[index] as String)
        }
    }
}

extension DetailViewController : UICollectionViewDelegate {
    
}
