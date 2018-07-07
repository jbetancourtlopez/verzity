//
//  DetailUniversityViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 26/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class DetailUniversityViewController: BaseViewController {

    @IBOutlet var description_university: UILabel!
    @IBOutlet var name_universitity: UILabel!
    
    // Favorito
    @IBOutlet var button_favorit: UIButton!
    // Direccion
    @IBOutlet var image_address: UIImageView!
    @IBOutlet var label_address: UITextView!
    @IBOutlet var button_address: UIButton!
    // Telefono
    @IBOutlet var image_phone: UIImageView!
    @IBOutlet var label_phone: UITextView!
    // Web
    @IBOutlet var image_web: UIImageView!
    @IBOutlet var label_web: UITextView!
    // Email
    @IBOutlet var image_email: UIImageView!
    @IBOutlet var label_email: UITextView!
    // Video
    @IBOutlet var image_video: UIImageView!
    @IBOutlet var label_video: UITextView!
    @IBOutlet var button_video: UIButton!
    // Beca
    @IBOutlet var image_beca: UIImageView!
    @IBOutlet var label_beca: UITextView!
    @IBOutlet var button_beca: UIButton!
    // Financiamiento
    @IBOutlet var image_financing: UIImageView!
    @IBOutlet var label_financing: UITextView!
    @IBOutlet var button_financing: UIButton!
    
    var swipeGesture  = UISwipeGestureRecognizer()
    var webServiceController = WebServiceController()
    var list_images: NSArray = []
    var list_licenciaturas: NSArray = []
    var count_current = 0
    var idUniversidad: Int!
    var detail_data: AnyObject!
    var selected_postulate: String = ""
    
    @IBOutlet var page_control: UIPageControl!
    @IBOutlet var image_slider: UIImageView!
    @IBOutlet var button_postulate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idUniversidad = idUniversidad as Int
        setup_ux()
        
        load_data()
        
        //Gestos
        count_current = 0
        let directions: [UISwipeGestureRecognizerDirection] = [.up, .down, .right, .left]
        
        for direction in directions {
            swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwView(_:)))
            image_slider.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
            image_slider.isUserInteractionEnabled = true
            image_slider.isMultipleTouchEnabled = true
        }

    }
    
    func load_data(){
        // Cargamos los datos
        showGifIndicator(view: self.view)
        let array_parameter = ["idUniversidad": idUniversidad]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetDetallesUniversidad(parameters: parameter_json_string!, doneFunction: GetDetallesUniversidad)
    }
   
    func GetDetallesUniversidad(status: Int, response: AnyObject){
        
        var json = JSON(response)
        debugPrint(json)
        if status == 1{
            self.detail_data = JSON(json["Data"]) as AnyObject
            let data = JSON(json["Data"])
            self.list_images = data["FotosUniversidades"].arrayValue as NSArray
            self.list_licenciaturas = data["Licenciaturas"].arrayValue as NSArray
            self.page_control.numberOfPages = self.list_images.count
            set_image_slider()
            set_data()
        }else{
            // Mensaje de Error
        }
        hiddenGifIndicator(view: self.view)
    }
    
    // FotosUniversidades
    @objc func swipwView(_ sender : UISwipeGestureRecognizer){
        UIView.animate(withDuration: 1.0) {
            
            if sender.direction == .left {
                if (self.count_current >= (self.list_images.count - 1)){
                    self.count_current = 0;
                }else{
                    self.count_current = self.count_current + 1
                }
                print("left")
            }else if sender.direction == .right{
                print("right")
                if (self.count_current <= 0){
                    self.count_current = self.list_images.count - 1
                }else{
                    self.count_current = self.count_current - 1
                }
            }
            
            self.page_control.currentPage = self.count_current
            self.set_image_slider()
            self.image_slider.layoutIfNeeded()
            self.image_slider.setNeedsDisplay()
        }
    }
    
    func set_image_slider(){
        print("count_current: \(self.count_current)")
        print("list_images_cont: \(self.list_images.count)")
        
        if self.list_images.count > 0 {
            let image_item = self.list_images[self.count_current]
            var image = JSON(image_item)
            
            var pathImage = image["desRutaFoto"].stringValue
            pathImage = pathImage.replacingOccurrences(of: "~", with: "")
            pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
            
            let url =  "\(String(describing: Config.desRutaMultimedia))\(pathImage)"
            let URL = Foundation.URL(string: url)
            let image_default = UIImage(named: "default.png")
            
            self.image_slider.kf.setImage(with: URL, placeholder: image_default)
        }
    }
    
    @IBAction func on_click_financing(_ sender: Any) {
        print("Financing")
        let vc = storyboard?.instantiateViewController(withIdentifier: "CardViewControllerID") as! CardViewController
        vc.idUniversidad = idUniversidad
        vc.type = "financing"
        self.show(vc, sender: nil)
    }
    
    @IBAction func on_click_beca(_ sender: Any) {
        print("beca")
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CardViewControllerID") as! CardViewController
        vc.idUniversidad = idUniversidad
        vc.type = "becas"
        self.show(vc, sender: nil)
    }
    
    @IBAction func on_click_video(_ sender: Any) {
        print("video")
        var university_json = JSON(self.detail_data)
        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoViewControllerID") as! VideoViewController
        vc.idUniversidad = university_json["idUniversidad"].intValue
        self.show(vc, sender: nil)
    }
    
    @IBAction func on_click_map(_ sender: Any) {
        print("mapa")
    }
    
    @IBAction func on_click_postulate(_ sender: Any) {
        print("Postulado")
        let alert = UIAlertController(title: "Seleccione programa academico", message: nil, preferredStyle: .actionSheet)
        
        for i in 0 ..< list_licenciaturas.count {
            
            let item = JSON(self.list_licenciaturas[i])
            let nbLicenciatura = item["nbLicenciatura"].stringValue
            let idLicenciatura = item["idLicenciatura"].intValue
            
            let action = UIAlertAction(title: nbLicenciatura, style: .default, handler: {(action) in
                self.selected_postulate(name:nbLicenciatura, idLicenciatura: idLicenciatura )
            })
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func selected_postulate(name: String, idLicenciatura: Int){
        //alert.
        print("Postulado Metodo: \(name)")
        showGifIndicator(view: self.view)
        
        let array_parameter = [
            "idUniversidad": idUniversidad,
            "idLicenciatura": idLicenciatura
            ] as [String : Any]
        
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.SetFavorito(parameters: parameter_json_string!, doneFunction: PostularseLicenciatura)
    }
    
    func PostularseLicenciatura(status: Int, response: AnyObject){
        var json = JSON(response)
        if status == 1{
            showMessage(title: json["Mensaje"].stringValue, automatic: true)
        }else{
            showMessage(title: response as! String, automatic: true)
        }
        hiddenGifIndicator(view: self.view)
    }
    
    
    
    @IBAction func on_click_favorit(_ sender: Any) {
        print("Favorit")
        showGifIndicator(view: self.view)
        let array_parameter = [
            "idUniversidad": idUniversidad,
            "idPersona": getSettings(key: "idPersona")
            ] as [String : Any]
        
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.SetFavorito(parameters: parameter_json_string!, doneFunction: SetFavorito)
    }
    
    func SetFavorito(status: Int, response: AnyObject){
        var json = JSON(response)
        var data = JSON(json["Data"])
        if status == 1{
            if  data["idFavoritos"].intValue == 0{
                let image = UIImage(named: "ic_action_star_border")?.withRenderingMode(.alwaysTemplate)
                button_favorit.setImage(image, for: .normal)
            }else{
                let image = UIImage(named: "ic_action_star")?.withRenderingMode(.alwaysTemplate)
                button_favorit.setImage(image, for: .normal)
            }
        }else{
            let image = UIImage(named: "ic_action_star")?.withRenderingMode(.alwaysTemplate)
            button_favorit.setImage(image, for: .normal)
        }
        hiddenGifIndicator(view: self.view)
    }
    
    func setup_ux(){
        
        let image_visitar_web  = UIImage(named: "ic_visitar_web")?.withRenderingMode(.alwaysTemplate)
        // Favorito
        let image = UIImage(named: "ic_action_star_border")?.withRenderingMode(.alwaysTemplate)
        button_favorit.setImage(image, for: .normal)
        button_favorit.tintColor = Colors.green_dark
        
        // DIreccion
        image_address.image = image_address.image?.withRenderingMode(.alwaysTemplate)
        image_address.tintColor = Colors.gray
        // Phone
        image_phone.image = image_phone.image?.withRenderingMode(.alwaysTemplate)
        image_phone.tintColor = Colors.gray
        // Web
        image_web.image = image_web.image?.withRenderingMode(.alwaysTemplate)
        image_web.tintColor = Colors.gray
        // Beca
        image_beca.image = image_beca.image?.withRenderingMode(.alwaysTemplate)
        image_beca.tintColor = Colors.gray
        button_beca.setImage(image_visitar_web, for: .normal)
        button_beca.tintColor = Colors.gray
        // Email
        image_email.image = image_email.image?.withRenderingMode(.alwaysTemplate)
        image_email.tintColor = Colors.gray
        //Video
        image_video.image = image_video.image?.withRenderingMode(.alwaysTemplate)
        image_video.tintColor = Colors.gray
        button_video.setImage(image_visitar_web, for: .normal)
        button_video.tintColor = Colors.gray
        // FInancimaineto
        image_financing.image = image_financing.image?.withRenderingMode(.alwaysTemplate)
        image_financing.tintColor = Colors.gray
        button_financing.setImage(image_visitar_web, for: .normal)
        button_financing.tintColor = Colors.gray
       
    }
    
    func set_data(){
        var university_json = JSON(self.detail_data)
        var address = JSON(university_json["Direcciones"])
        
        var name_uniersity_text = university_json["nbUniversidad"].stringValue
        if  name_uniersity_text.isEmpty{
            name_uniersity_text = StringsLabel.no_university_name
        }
        
        var label_address_text = "\(address["desDireccion"].stringValue), \(address["nbCiudad"].stringValue), \(address["nbEstado"].stringValue), \(address["nbPais"].stringValue)"
        if (address["desDireccion"].stringValue).isEmpty {
            label_address_text = StringsLabel.no_address
        }
        
        var label_web_text = university_json["desSitioWeb"].stringValue
        if  label_web_text.isEmpty{
            label_web_text = StringsLabel.no_website
        }
        
        var label_email_text =  university_json["desCorreo"].stringValue
        if  label_email_text.isEmpty{
            label_email_text = StringsLabel.no_email
        }
        
        var label_phone_text = university_json["desTelefono"].stringValue
        if  label_phone_text.isEmpty{
            label_phone_text = StringsLabel.no_phone
        }
        
        name_universitity.text = name_uniersity_text
        description_university.text = university_json["desUniversidad"].stringValue
        label_address.text = label_address_text
        label_web.text = label_web_text
        label_email.text = label_email_text
        label_phone.text = label_phone_text
        label_video.text = "Ver videos"
        label_beca.text = "Ver becas"
        label_financing.text = "Ver financiamientos"
    }



}
