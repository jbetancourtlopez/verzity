//
//  FindMapViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 26/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import MapKit

private let kPersonWishListAnnotationName = "kPersonWishListAnnotationName"

class FindMapViewController: UIViewController, MKMapViewDelegate, DetailMapViewDelegate {
    
    // outlet
    @IBOutlet weak var mapView: MKMapView!
    
    // data
    var type: String = ""
    // data
    var idUniversidad: Int = 0
    
    let names = ["Oren Nimmons", "Flor Addington"]
    let coordinates = [
        CLLocationCoordinate2D(latitude: 47.57273, longitude: -52.68997),
        CLLocationCoordinate2D(latitude: 47.56624, longitude: -52.71184)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = String(type)
        //mapView.showsUserLocation = true
        //mapView.delegate = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load_data()
        setFakeUserPosition()
    }
    
    func load_data() {
        var annotations = [MKAnnotation]()
        for i in 0..<self.names.count {
            
            let title_item =  names[i]
            let avatar = "ic_user_profile.png"
            let idUniversidad = 11
            let location = coordinates[i]
            
            let annotation =  CustomAnnotation.init(title: title_item, idUniversidad: idUniversidad, location: location, avatar: avatar)
            annotations.append(annotation)
        }
        
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    
    func setFakeUserPosition() {
        let visibleRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 47.57983, longitude: -52.68997), 10000, 10000)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
    }

    // MARK: - MKMapViewDelegate methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let visibleRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10000, 10000)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kPersonWishListAnnotationName)
        
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: kPersonWishListAnnotationName)
            (annotationView as! CustomAnnotationView).detailDelegate  = self
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Ir al Detalle")
        
         if let pdvc = segue.destination as? DetailUniversityViewController {
         pdvc.idUniversidad = self.idUniversidad
         }
    }
    
    func detailsRequestedForPerson(idUniversidad: Int) {
        print("Hola:\(idUniversidad)")
        self.idUniversidad = idUniversidad
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailUniversityViewControllerID") as! DetailUniversityViewController
        vc.idUniversidad = idUniversidad
        self.show(vc, sender: nil)
    }
    
    
    // ----------------------
    // https://www.youtube.com/watch?v=agXeo1PApq8
    // https://stackoverflow.com/questions/30793315/customize-mkannotation-callout-view
    // http://www.surekhatech.com/blog/custom-callout-view-for-ios-map
    
    
    

}
