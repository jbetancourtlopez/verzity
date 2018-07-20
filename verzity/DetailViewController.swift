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
    
    @IBOutlet var postulate_date: UILabel!
    
    @IBOutlet var icon_name: UIImageView!
    @IBOutlet var icon_email: UIImageView!
    @IBOutlet var icon_phone: UIImageView!
    @IBOutlet var icon_location: UIImageView!
    @IBOutlet var button_phone: UIButton!
    @IBOutlet var button_email: UIButton!

    var idNotificacion: Int = 0
    var type: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idNotificacion = idNotificacion as Int
        type = type as String
        
        septup_ux()

        if type == "postulado" {
            detail = detail as AnyObject
            set_data_postulado()
        } else if type == "notificacion" {
            load_data();
        }
        
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
            "idDispositivo": 0,
            "idNotificacion": self.idNotificacion
            ] as [String : Any]
        debugPrint(array_parameter)
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetDetalleNotificacion(parameters: parameter_json_string!, doneFunction: GetDetalleNotificacion)
    }
    
    func GetDetalleNotificacion(status: Int, response: AnyObject){
        var json = JSON(response)
        debugPrint(json)
        if status == 1{
            self.detail = JSON(json["Data"]) as AnyObject
            set_data()
          
        }else{
            // Mensaje de Error
            showMessage(title: response as! String, automatic: true)
        }
        hiddenGifIndicator(view: self.view)
    }
    
    func set_data(){
        var data_json = JSON(self.detail)
        var persona = JSON(data_json["persona"])
        var licenciatura = JSON(data_json["licenciatura"])
        var beca = JSON(data_json["beca"])
        var financiamiento = JSON(data_json["financiamiento"])
        
        
        // Descripcion
        var postulate_description_text = ""
        
        if !licenciatura.isEmpty{
            let nbLicenciatura = licenciatura["nbLicenciatura"].stringValue
            postulate_description_text = persona["nbCompleto"].stringValue + " Se ha postulado al programa académico " + nbLicenciatura
        } else if !beca.isEmpty{
            postulate_description_text = persona["nbCompleto"].stringValue + " Se ha postulado a la beca " + beca["nbBeca"].stringValue
        } else if !financiamiento.isEmpty {
            postulate_description_text = persona["nbCompleto"].stringValue + " Se ha postulado al financiamiento " + financiamiento["nbFinanciamiento"].stringValue
        }
        
        postulate_description.text = postulate_description_text
        
        //Fecha de Postulacion
        var fechaPostulacion = data_json["fechaPostulacion"].stringValue
        var date_complete_array = fechaPostulacion.components(separatedBy: "T")
        let date_string = date_complete_array[0]
        var day = get_day_of_week(today:date_string)
        var date = get_date_complete(date_complete_string: fechaPostulacion )
        postulate_date.text = day + " " + date
        
        // Titulo
        postulate_name_postulate.text = "Nueva Postulacion"
        
        // Datos de la Persona
        postulate_name.text = persona["nbCompleto"].stringValue
        postulate_email.text = persona["desCorreo"].stringValue
        postulate_phone.text = persona["desTelefono"].stringValue
        
        var location_json = JSON(persona["Direcciones"])
        var text_location = ""
        if location_json["nbPais"].stringValue == "México"{
            text_location = "\(location_json["desDireccion"].stringValue), \(location_json["nbCiudad"].stringValue), \(location_json["nbMunicipio"].stringValue), \(location_json["nbEstado"].stringValue), \(location_json["nbPais"].stringValue), \(location_json["numCodigoPostal"].stringValue)"
        } else{
            text_location = location_json["nbPais"].stringValue
        }
        
        postulate_location.text = text_location
        
        
        // Imagen
        var pathImage = persona["pathFoto"].stringValue
        pathImage = pathImage.replacingOccurrences(of: "~", with: "")
        pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
        let url =  "\(String(describing: Defaults[.desRutaFTP]))\(pathImage)"
        let URL = Foundation.URL(string: url)
        let image_default = UIImage(named: "ic_user_profile.png")
        postulate_image.kf.setImage(with: URL, placeholder: image_default)
        
    }

    func set_data_postulado(){
        //debugPrint(self.detail)
        
        var data_json = JSON(self.detail)
        var persona = JSON(data_json["person"])
        var type = JSON(data_json["type"])
        
        
        // Fecha
        let fechaPostulacion = data_json["fechaPostulacion"].stringValue
        var date_complete_array = fechaPostulacion.components(separatedBy: "T")
        let date_string = date_complete_array[0]
        let day = get_day_of_week(today:date_string)
        let date = get_date_complete(date_complete_string: fechaPostulacion )
        postulate_date.text = day + " " + date
        
        // Titulo
        let nbLicenciatura = type["nbLicenciatura"].stringValue
        let postulate_description_text = persona["nbCompleto"].stringValue + " Se ha postulado al programa académico " + nbLicenciatura
        
        // Descripcion
        postulate_name_postulate.text = postulate_description_text
        
        // Datos de la Persona
        postulate_description.text = ""
        postulate_name.text = persona["nbCompleto"].stringValue
        postulate_email.text = persona["desCorreo"].stringValue
        postulate_phone.text = persona["desTelefono"].stringValue
        
        var location_json = JSON(persona["Direcciones"])
        var text_location = ""
        if location_json["nbPais"].stringValue == "México"{
            text_location = "\(location_json["desDireccion"].stringValue), \(location_json["nbCiudad"].stringValue), \(location_json["nbMunicipio"].stringValue), \(location_json["nbEstado"].stringValue), \(location_json["nbPais"].stringValue), \(location_json["numCodigoPostal"].stringValue)"
        } else{
            text_location = location_json["nbPais"].stringValue
        }
        
        postulate_location.text = text_location
        
        
        // Imagen
        var pathImage = persona["pathFoto"].stringValue
        pathImage = pathImage.replacingOccurrences(of: "~", with: "")
        pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
        let url =  "\(String(describing: Defaults[.desRutaFTP]))\(pathImage)"
        let URL = Foundation.URL(string: url)
        let image_default = UIImage(named: "ic_user_profile.png")
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
        
        let busPhone = postulate_phone.text
        
        if let url = URL(string: "tel://\(busPhone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    


}
