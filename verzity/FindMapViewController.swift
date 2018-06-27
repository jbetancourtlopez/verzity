//
//  FindMapViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 26/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import MapKit

class customPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubTitle: String, location:CLLocationCoordinate2D){
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
        
    }
}

class FindMapViewController: UIViewController, MKMapViewDelegate, CustomViewDelegate {
    
    func detailsRequestedForCustom(data: AnyObject) {
        // Code
    }
    
    
    var type: String = ""
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = String(type)
        mapView.showsUserLocation = true
        mapView.delegate = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let location = CLLocationCoordinate2D(latitude: 38.0000, longitude: -97.0000)
        let region = MKCoordinateRegionMakeWithDistance(location, 1800000, 1800000)
        mapView.setRegion(region, animated: true)
        
        //Agrego los Markers
        add_makers_universities(lat: 25.7742691, lon: -80.1936569, title: "Prueba")
    }
    
    func setFakeUserPosition() {
        let visibleRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 47.57983, longitude: -52.68997), 10000, 10000)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let visibleRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10000, 10000)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{ return nil }
        
        let anotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnotation")
        anotationView.image = UIImage(named: "ic_school_map.png")
        anotationView.canShowCallout = true
        return anotationView
        
    }

    func add_makers_universities(lat: Double, lon: Double, title: String){
        let location = CLLocationCoordinate2D(latitude: lat,
                                              longitude: lon)
        let pin = customPin(pinTitle: title, pinSubTitle: "Sub", location: location)
        //let annotation = MKPointAnnotation()
        //annotation.coordinate = location
        //annotation.title = title
        //annotation.subtitle = ""
        mapView.addAnnotation(pin)
    }
    
    
    
    // https://www.youtube.com/watch?v=agXeo1PApq8
    // https://stackoverflow.com/questions/30793315/customize-mkannotation-callout-view
    // http://www.surekhatech.com/blog/custom-callout-view-for-ios-map
    
    
    

}
