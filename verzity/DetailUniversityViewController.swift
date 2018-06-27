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

     var university: AnyObject!
    
    @IBOutlet var description_university: UILabel!
    @IBOutlet var name_universitity: UILabel!
    
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
     var count_current: Int!
    
    @IBOutlet var page_control: UIPageControl!
    @IBOutlet var image_slider: UIImageView!
    @IBOutlet var button_postulate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        university = university as AnyObject
        debugPrint(university)
        setup_ux()
        set_data()
        
        //Gestos
        count_current = 1
        let directions: [UISwipeGestureRecognizerDirection] = [.up, .down, .right, .left]
        
        for direction in directions {
            swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwView(_:)))
            image_slider.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
            image_slider.isUserInteractionEnabled = true
            image_slider.isMultipleTouchEnabled = true
        }

    }
    
    func load_images(idUniversidad:Int){
        let array_parameter = ["idUniversidad": idUniversidad]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetDetallesUniversidad(parameters: parameter_json_string!, doneFunction: getDetalleImagenes)
    }
    
    func getDetalleImagenes(status: Int, response: AnyObject){
        var json = JSON(response)
        if status == 1{
            let data = JSON(json["Data"])
            self.list_images = data["FotosUniversidades"].arrayValue as NSArray
            self.page_control.numberOfPages = self.list_images.count
            set_image_slider()
        }else{
            // Mensaje de Error
        }
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
    
    @IBAction func on_click_financing(_ sender: Any) {
        print("Financing")
    }
    
    @IBAction func on_click_beca(_ sender: Any) {
        print("beca")
    }
    
    @IBAction func on_click_video(_ sender: Any) {
        print("video")
    }
    
    @IBAction func on_click_map(_ sender: Any) {
        print("mapa")
    }
    
    @IBAction func on_click_favorit(_ sender: Any) {
        print("Favorit")
    }
    
    func setup_ux(){

        image_address.image = image_address.image?.withRenderingMode(.alwaysTemplate)
        image_address.tintColor = Colors.gray
        image_phone.image = image_phone.image?.withRenderingMode(.alwaysTemplate)
        image_phone.tintColor = Colors.gray
        image_web.image = image_web.image?.withRenderingMode(.alwaysTemplate)
        image_web.tintColor = Colors.gray
        image_beca.image = image_beca.image?.withRenderingMode(.alwaysTemplate)
        image_beca.tintColor = Colors.gray
        image_email.image = image_email.image?.withRenderingMode(.alwaysTemplate)
        image_email.tintColor = Colors.gray
        image_video.image = image_video.image?.withRenderingMode(.alwaysTemplate)
        image_video.tintColor = Colors.gray
        image_financing.image = image_financing.image?.withRenderingMode(.alwaysTemplate)
        image_financing.tintColor = Colors.gray
       
    }
    
    func set_data(){
        var university_json = JSON(university)
        var address = JSON(university_json["Direcciones"])
        
        name_universitity.text = university_json["nbUniversidad"].stringValue
        description_university.text = university_json["desUniversidad"].stringValue
        label_address.text = "\(address["desDireccion"].stringValue), \(address["nbCiudad"].stringValue), \(address["nbEstado"].stringValue), \(address["nbPais"].stringValue)"
        label_web.text = university_json["desSitioWeb"].stringValue
        label_email.text = university_json["desCorreo"].stringValue
        label_phone.text = university_json["desTelefono"].stringValue
        label_video.text = "Ver videos"
        label_beca.text = "Ver becas"
        label_financing.text = "Ver financiamientos"
        
        load_images(idUniversidad: university_json["idUniversidad"].intValue)
    }



}
