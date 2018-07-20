//
//  DetailBuyViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 19/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SwiftyUserDefaults


protocol DetailBuyViewControllerDelegate: class {
    func okButtonTapped()
}

class DetailBuyViewController: BaseViewController {
    
    // outlet
    @IBOutlet var alertView: UIView!
    @IBOutlet var date_top: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var vigency: UILabel!
    @IBOutlet var price: UILabel!
    
    // data
    var webServiceController = WebServiceController()
     var info: AnyObject!
    
    var delegate: DetailBuyViewControllerDelegate?
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        set_data()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func set_data(){
        debugPrint(info)
        /*
        feVenta
        feVigencia
 */
        var json = JSON(info)
        var data = JSON(json["Data"])
        Defaults[.package_idPaquete] = data["idPaquete"].intValue
        date_top.text = get_date_complete(date_complete_string: data["feVenta"].stringValue)
        
        name.text = " NA"
        vigency.text = get_date_complete(date_complete_string: data["feVigencia"].stringValue)
        price.text = " NA"
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 2
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }

    
    @IBAction func on_click_ok(_ sender: Any) {
        delegate?.okButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
