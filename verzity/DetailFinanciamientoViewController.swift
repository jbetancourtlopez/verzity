//
//  DetailFinanciamientoViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 07/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SwiftyUserDefaults


class DetailFinanciamientoViewController: BaseViewController {

    var detail: AnyObject!
    var webServiceController = WebServiceController()
    
    //UIControls
    @IBOutlet var image_caratule: UIImageView!
    @IBOutlet var financing_title: UILabel!
    @IBOutlet var financing_descripction: UITextView!
    @IBOutlet var label_web: UILabel!
    @IBOutlet var icon_web: UIImageView!
    
    @IBOutlet var label_university: UILabel!
    @IBOutlet var icon_university: UIImageView!
    @IBOutlet var button_university: UIButton!
    
    @IBOutlet var icon_file: UIImageView!
    @IBOutlet var label_file: UILabel!
    @IBOutlet var button_file: UIButton!
    
    @IBOutlet var button_request: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        septup_ux()
        detail = detail as AnyObject
        
        debugPrint(detail)
        set_data();

    }
    
    
    func septup_ux(){
        icon_file.image = icon_file.image?.withRenderingMode(.alwaysTemplate)
        icon_file.tintColor = Colors.gray

        icon_web.image = icon_web.image?.withRenderingMode(.alwaysTemplate)
        icon_web.tintColor = Colors.gray

        icon_university.image = icon_university.image?.withRenderingMode(.alwaysTemplate)
        icon_university.tintColor = Colors.gray
        
        
        let image = UIImage(named: "ic_visitar_web")?.withRenderingMode(.alwaysTemplate)
        button_university.setImage(image, for: .normal)
        button_university.tintColor = Colors.gray
        
        
        let image_file = UIImage(named: "ic_file_download")?.withRenderingMode(.alwaysTemplate)
        button_file.setImage(image_file, for: .normal)
        button_file.tintColor = Colors.gray
    }
    
    
    func set_data(){
        var detail = JSON(self.detail)

        // Archivo
        let file_path = detail["pathArchivo"].stringValue
        if  !file_path.isEmpty{
             label_file.text = "Descargar archivo adjunto"
        }else{
             label_file.text = "No se encontró archivo adjunto"
        }
        
        var universidad = JSON(detail["Universidades"])
        

        // Titulo
        financing_title.text = detail["nbFinanciamiento"].stringValue
        
        // Web
        var desSitioWeb = universidad["desSitioWeb"].stringValue
        if desSitioWeb.isEmpty {
            desSitioWeb = "http://www.dwmedios.com"
        }
        label_web.text = desSitioWeb

        // Name universidad
        var nbUniversidad = universidad["nbUniversidad"].stringValue
        if nbUniversidad.isEmpty {
            nbUniversidad = "Dw Medios"
        }
        label_university.text = nbUniversidad
      
        // Descripcion
        financing_descripction.text = detail["desFinancimiento"].stringValue
        let amountOfLinesToBeShown:CGFloat = 6
        let maxHeight:CGFloat = financing_descripction.font!.lineHeight * amountOfLinesToBeShown
        financing_descripction.sizeThatFits(CGSize(width: financing_descripction.frame.size.width, height:maxHeight))
        
         // Imagen
         var pathImage = detail["pathImagen"].stringValue
         pathImage = pathImage.replacingOccurrences(of: "~", with: "")
         pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
         let url =  "\(String(describing: Config.desRutaMultimedia))\(pathImage)"
         let URL = Foundation.URL(string: url)
         let image_default = UIImage(named: "default.png")
         image_caratule.kf.setImage(with: URL, placeholder: image_default)
    }

   
    @IBAction func on_clic_request(_ sender: Any) {
        let idPersona = Defaults[.academic_idPersona] as! Int
        
        var detail = JSON(self.detail)
        let idFinanciamiento = detail["idFinanciamiento"].stringValue
        
        if  (idPersona > 0){
            showGifIndicator(view: self.view)
            
            // FIX - Armar los parametros
            let array_parameter = [
                "idPersona": idPersona,
                "idFinanciamiento": idFinanciamiento
                ] as [String : Any]
            
            debugPrint(array_parameter)
            let parameter_json = JSON(array_parameter)
            let parameter_json_string = parameter_json.rawString()
            webServiceController.SolicitarFinanciamientos(parameters: parameter_json_string!, doneFunction: SolicitarFinanciamientos)
            
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileAcademicViewControllerID") as! ProfileAcademicViewController
            self.show(vc, sender: nil)
        }
    }
    
    
    func SolicitarFinanciamientos(status: Int, response: AnyObject){
        print("Callaback")
        hiddenGifIndicator(view: self.view)
        var json = JSON(response)
        if status == 1{
            let message = json["Mensaje"].stringValue
            showMessage(title: message, automatic: true)
        }else{
            showMessage(title: response as! String, automatic: true)
        }
        
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
}
