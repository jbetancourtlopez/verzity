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
    var webServiceController = WebServiceController()
    
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
    
    @IBAction func on_click_postulate(_ sender: Any) {
        let idPersona = Int(getSettings(key: "idPersona"))
        if  (idPersona! > 0){
            showGifIndicator(view: self.view)
            
            // FIX - Armar los parametros
            let array_parameter = ["": ""]
            let parameter_json = JSON(array_parameter)
            let parameter_json_string = parameter_json.rawString()
            webServiceController.PostularseBeca(parameters: parameter_json_string!, doneFunction: PostularseBeca)
            
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileAcademicViewControllerID") as! ProfileAcademicViewController
            self.show(vc, sender: nil)
        }
    }
    
    func PostularseBeca(status: Int, response: AnyObject){
        var json = JSON(response)
        if status == 1{
            let message = json["Mensaje"].stringValue
            updateAlert(title: "Error", message: message, automatic: true)
        }else{
            updateAlert(title: "Error", message: response as! String, automatic: true)
        }
        hiddenGifIndicator(view: self.view)
        
    }
    
    func set_data(){
        debugPrint(self.detail)
        var detail = JSON(self.detail)
        
        detail_title.text = detail["nbBeca"].stringValue
        detail_name.text = detail["nbUniversidad"].stringValue
        detail_description.text = detail["desBeca"].stringValue
        
        let amountOfLinesToBeShown:CGFloat = 6
        let maxHeight:CGFloat = detail_description.font!.lineHeight * amountOfLinesToBeShown
        detail_description.sizeThatFits(CGSize(width: detail_description.frame.size.width, height:maxHeight))
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
