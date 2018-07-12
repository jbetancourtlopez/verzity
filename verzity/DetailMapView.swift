//
//  DetailMapView.swift
//  ExampleMap
//
//  Created by Jossue Betancourt on 11/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit

protocol DetailMapViewDelegate: class {
    func detailsRequestedForPerson(idUniversidad: Int)
}

class DetailMapView: UIView {
    
    // outlets
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var seeDetailsButton: UIButton!
    
    // data
    var idUniversidad: Int!
    weak var delegate: DetailMapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func seeDetails(_ sender: Any) {
        delegate?.detailsRequestedForPerson(idUniversidad: idUniversidad)
    }
    
    func configureData(title: String, avatar: String, idUniversidad: Int) {
        self.idUniversidad = idUniversidad
        self.avatar.image = UIImage(named: "ic_user_profile.png")
        self.title.text = title
    }
    

    
    // MARK: - Hit test. We need to override this to detect hits in our custom callout.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if it hit our annotation detail view components.
        
        // details button
        if let result = seeDetailsButton.hitTest(convert(point, to: seeDetailsButton), with: event) {
            return result
        }
        // list
        //if let result = wishListTableView.hitTest(convert(point, to: wishListTableView), with: event) {
        //    return result
        //}
        // fallback to our background content view
        return  nil //backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
    
}
