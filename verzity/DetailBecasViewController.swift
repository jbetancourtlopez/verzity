//
//  DetailBecasViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 26/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class DetailBecasViewController: BaseViewController {

    var detail: AnyObject!
    
    @IBOutlet var detail_title: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var detail_name: UILabel!
    @IBOutlet var detail_description: UITextView!
    @IBOutlet var detail_file: UILabel!
    @IBOutlet var btn_university: UIButton!
    @IBOutlet var btn_file: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detail = detail as AnyObject
        set_data();
    }
    
    @IBAction func on_click_university(_ sender: Any) {
         var detail = JSON(self.detail)
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailUniversityViewControllerID") as! DetailUniversityViewController
        vc.idUniversidad = detail["idUniversidad"].intValue
        self.show(vc, sender: nil)
    }
    
    @IBAction func on_click_file(_ sender: Any) {
        var detail = JSON(self.detail)
        var file_path = detail["desRutaArchivo"].stringValue
        file_path = file_path.replacingOccurrences(of: "~", with: "")
        file_path = file_path.replacingOccurrences(of: "\\", with: "")
        let url =  "\(String(describing: Config.desRutaMultimedia))\(file_path)"
        openUrl(scheme: url)
    }
    
    func set_data(){
        debugPrint(self.detail)
        var detail = JSON(self.detail)
        
        detail_title.text = detail["nbBeca"].stringValue
        detail_name.text = detail["nbUniversidad"].stringValue
        detail_description.text = detail["desBeca"].stringValue
        detail_file.text = "Descargar archivo adjunto"
        
         // Imagen
         var pathImage = detail["pathImagen"].stringValue
         pathImage = pathImage.replacingOccurrences(of: "~", with: "")
         pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
         let url =  "\(String(describing: Config.desRutaMultimedia))\(pathImage)"
         let URL = Foundation.URL(string: url)
         let image_default = UIImage(named: "default.png")
         image.kf.setImage(with: URL, placeholder: image_default)
        
    }
    



}
