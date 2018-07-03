//
//  DetailViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 02/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {

    
    
    @IBOutlet var postulate_image: UIImageView!
    
    @IBOutlet var postulate_phone: UILabel!
    @IBOutlet var postulate_email: UILabel!
    @IBOutlet var postulate_name: UILabel!
    @IBOutlet var postulate_description: UITextView!
    @IBOutlet var postulate_name_postulate: UILabel!
    @IBOutlet var postulate_location: UILabel!
    @IBOutlet var postulate_image_name: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func on_click_email(_ sender: Any) {
    }
    
    @IBAction func on_click_phone(_ sender: Any) {
    }
    
    


}
