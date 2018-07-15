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
import SwiftyUserDefaults


class DetailBecasViewController: BaseViewController {

    var detail: AnyObject!
    
    @IBOutlet var icon_file_right: UIButton!
    @IBOutlet var icon_person_rigth: UIButton!
    
    @IBOutlet var icon_file: UIImageView!
    @IBOutlet var icon_person: UIImageView!
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
        setup_ux()
    }
    
    func setup_ux(){
    
        let image_visitar_web  = UIImage(named: "ic_visitar_web")?.withRenderingMode(.alwaysTemplate)
        let image_file_download  = UIImage(named: "ic_file_download")?.withRenderingMode(.alwaysTemplate)
    
        btn_university.setImage(image_visitar_web, for: .normal)
        btn_university.tintColor = Colors.gray
        
        btn_file.setImage(image_file_download, for: .normal)
        btn_file.tintColor = Colors.gray
    
    }
    
    @IBAction func on_click_university(_ sender: Any) {
        print("Universidad")
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
        
        if  !file_path.isEmpty{
            openUrl(scheme: url)
        }
    }
    
    @IBAction func on_click_postulate(_ sender: Any) {
        let idPersona = Defaults[.academic_idPersona]
        if  (idPersona! > 0){
            showGifIndicator(view: self.view)
            
            var detail = JSON(self.detail)
            let array_parameter = [
                "idPersona": idPersona!,
                "idBeca": detail["idBeca"].intValue
                ] as [String : Any]
            
            let parameter_json = JSON(array_parameter)
            let parameter_json_string = parameter_json.rawString()
            webServiceController.PostularseBeca(parameters: parameter_json_string!, doneFunction: PostularseBeca)
            
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileAcademicViewControllerID") as! ProfileAcademicViewController
            self.show(vc, sender: nil)
        }
    }
    
    func PostularseBeca(status: Int, response: AnyObject){
        hiddenGifIndicator(view: self.view)
        var json = JSON(response)
        if status == 1{
            let message = json["Mensaje"].stringValue
            showMessage(title: message, automatic: true)
        }else{
            showMessage(title: response as! String, automatic: true)
        }
       
    }
    
    func set_data(){
        debugPrint(self.detail)
        var detail = JSON(self.detail)
        var file_path = detail["desRutaArchivo"].stringValue
        
        var universidad = JSON(detail["Universidades"])
        
        detail_title.text = detail["nbBeca"].stringValue
        detail_name.text = universidad["nbUniversidad"].stringValue
        detail_description.text = detail["desBeca"].stringValue
        
        let amountOfLinesToBeShown:CGFloat = 6
        let maxHeight:CGFloat = detail_description.font!.lineHeight * amountOfLinesToBeShown
        detail_description.sizeThatFits(CGSize(width: detail_description.frame.size.width, height:maxHeight))
        if  !file_path.isEmpty{
             detail_file.text = "Descargar archivo adjunto"
        }else{
             detail_file.text = "No se encontró archivo adjunto"
        }
       
        icon_file.image = icon_file.image?.withRenderingMode(.alwaysTemplate)
        icon_file.tintColor = Colors.gray
        
        //icon_file_right.image = icon_file_right.image?.withRenderingMode(.alwaysTemplate)
        icon_file_right.tintColor = Colors.gray
        
        //icon_person_rigth.image = icon_person_rigth.image?.withRenderingMode(.alwaysTemplate)
        icon_person_rigth.tintColor = Colors.gray
        
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
