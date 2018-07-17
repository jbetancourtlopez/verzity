//
//  DetailViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 02/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SwiftyUserDefaults


class DetailViewController: BaseViewController {

    var detail: AnyObject!
    var webServiceController = WebServiceController()
    
    @IBOutlet var postulate_image: UIImageView!
    
    @IBOutlet var postulate_phone: UILabel!
    @IBOutlet var postulate_email: UILabel!
    @IBOutlet var postulate_name: UILabel!
    @IBOutlet var postulate_description: UITextView!
    @IBOutlet var postulate_name_postulate: UILabel!
    @IBOutlet var postulate_location: UILabel!
    @IBOutlet var postulate_image_name: UILabel!
    
    @IBOutlet var icon_name: UIImageView!
    @IBOutlet var icon_email: UIImageView!
    @IBOutlet var icon_phone: UIImageView!
    @IBOutlet var icon_location: UIImageView!
    @IBOutlet var button_phone: UIButton!
    @IBOutlet var button_email: UIButton!
    var idNotificacion: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idNotificacion = idNotificacion as Int
        
        septup_ux()
        
        load_data();
    }
    
    func septup_ux(){
        icon_name.image = icon_name.image?.withRenderingMode(.alwaysTemplate)
        icon_name.tintColor = Colors.gray
        
        icon_email.image = icon_email.image?.withRenderingMode(.alwaysTemplate)
        icon_email.tintColor = Colors.gray
        
        icon_phone.image = icon_phone.image?.withRenderingMode(.alwaysTemplate)
        icon_phone.tintColor = Colors.gray
        
        icon_location.image = icon_location.image?.withRenderingMode(.alwaysTemplate)
        icon_location.tintColor = Colors.gray
        
        
        let image = UIImage(named: "ic_visitar_web")?.withRenderingMode(.alwaysTemplate)
        button_phone.setImage(image, for: .normal)
        button_phone.tintColor = Colors.gray
        
        
        let image_file = UIImage(named: "ic_visitar_web")?.withRenderingMode(.alwaysTemplate)
        button_email.setImage(image_file, for: .normal)
        button_email.tintColor = Colors.gray
    }
    
    func load_data(){
        // Cargamos los datos
        showGifIndicator(view: self.view)
        let array_parameter = [
            "idDispositivo":Defaults[.cvDispositivo]!,
            "idNotificacion": self.idNotificacion
            ] as [String : Any]
        
        
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetDetalleNotificacion(parameters: parameter_json_string!, doneFunction: GetDetalleNotificacion)
    }
    
    func GetDetalleNotificacion(status: Int, response: AnyObject){
        
        var json = JSON(response)
        debugPrint(json)
        if status == 1{
            self.detail = JSON(json["Data"]) as AnyObject
            //set_data()
          
        }else{
            // Mensaje de Error
        }
        hiddenGifIndicator(view: self.view)
    }
    
    func set_data(){
        var data_json = JSON(self.detail)
        
        postulate_name.text = data_json["nbCompleto"].stringValue
        postulate_email.text = data_json["desCorreo"].stringValue
        postulate_phone.text = data_json["desTelefono"].stringValue
        
        var location_json = JSON(data_json["Direcciones"])
        let text_location = "\(location_json["desDireccion"].stringValue), \(location_json["nbCiudad"].stringValue), \(location_json["nbMunicipio"].stringValue), \(location_json["nbEstado"].stringValue), \(location_json["nbPais"].stringValue), \(location_json["numCodigoPostal"].stringValue)"
        postulate_location.text = text_location
        
        
        // Imagen
        var pathImage = data_json["pathFoto"].stringValue
        pathImage = pathImage.replacingOccurrences(of: "~", with: "")
        pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
        let url =  "\(String(describing: Config.desRutaMultimedia))\(pathImage)"
        let URL = Foundation.URL(string: url)
        let image_default = UIImage(named: "default.png")
        postulate_image.kf.setImage(with: URL, placeholder: image_default)
        
    }
    
    @IBAction func on_click_email(_ sender: Any) {
        let email = postulate_email.text
        
        if !FormValidate.validateEmail(postulate_email.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) == false {
            let url = URL(string: "mailto:\(email)")
            UIApplication.shared.openURL(url!)
        }else{
            showMessage(title: StringsLabel.email_invalid, automatic: true)
        }
        
    }
    
    @IBAction func on_click_phone(_ sender: Any) {
        
        let busPhone = "9999018357"
        
        if let url = URL(string: "tel://\(busPhone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    


}
