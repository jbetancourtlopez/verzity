//
//  DetailMapViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 19/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Kingfisher

class DetailMapViewController: UIViewController {
    
    // outlet
    @IBOutlet var mapView: MKMapView!

    var info: AnyObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        info = info as AnyObject
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        set_map()
        mapView.showsUserLocation = true
        
    }
    
    func set_map(){
        
    }

    

}
