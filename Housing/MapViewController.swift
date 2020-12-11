//
//  MapViewController.swift
//  Housing
//
//  Created by Vidhi Patel on 07/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // these are passed from detail screen
    public var latitude: Double = 0
    var longitude: Double = 0
    var houseTitle: String = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- show location in map
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = houseTitle
        
        setMapRegion()
        
        // set map annotation for the house location
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = houseTitle
        mapView.addAnnotation(annotation)
        
        // add interaction for context menu
        let interaction = UIContextMenuInteraction(delegate: self)
        view.addInteraction(interaction)
        
    }
    
    private func setMapRegion() {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let regionRadius = 5000
        let region = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: CLLocationDistance(regionRadius), longitudinalMeters: CLLocationDistance(regionRadius))
        mapView.setRegion(region, animated: true)
    }
    
    //MARK:- this returns menu items for context menu
    private func getMenuActions()->[UIAction] {
        
        // disable "Standard Map" if that is already loaded
        
        var actionStandard : UIAction;
        if self.mapView.mapType == .standard {
            actionStandard = UIAction(
                title: NSLocalizedString("Standard Map", comment: "Menu"),
                image: nil,
                identifier: nil,
                attributes: UIMenuElement.Attributes.disabled) { _ in
                    self.mapView.mapType = .standard
            }
        } else {
            actionStandard = UIAction(
                title: NSLocalizedString("Standard Map", comment: "Menu"),
                image: nil,
                identifier: nil) { _ in
                    self.mapView.mapType = .standard
            }
        }
        
        
        // disable "Satellite Map" if that is already loaded
        
        var actionSatellite : UIAction
        if self.mapView.mapType == .satellite {
            actionSatellite = UIAction(
                title: NSLocalizedString("Satellite Map", comment: "Menu"),
                image: nil,
                identifier: nil,
                attributes: UIMenuElement.Attributes.disabled) { _ in
                    self.mapView.mapType = .satellite
            }
        } else {
            actionSatellite = UIAction(
                title: NSLocalizedString("Satellite Map", comment: "Menu"),
                image: nil,
                identifier: nil) { _ in
                    self.mapView.mapType = .satellite
            }
        }
        
        // reload house location in map
        let actionReload = UIAction(
            title: NSLocalizedString("Refresh Location", comment: "Menu"),
            image: nil,
            identifier: nil) { _ in
                self.setMapRegion()
        }
        
        // close menu
        let actionClose = UIAction(
            title: NSLocalizedString("Close", comment: "Button"),
            image: nil,
            identifier: nil,
            attributes: .destructive) { _ in
        }
        
        return [actionStandard, actionSatellite, actionReload, actionClose]
    }
    
}

//MARK:- To prepare context menu while loading. The menu shows on long press/tap on screen
extension MapViewController : UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil,
            actionProvider: { _ in
                return UIMenu(title: "", children: self.getMenuActions())
        })
    }
}
