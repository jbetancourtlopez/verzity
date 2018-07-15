//
//  QrCouponViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 02/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SwiftyUserDefaults


class QrCouponViewController: BaseViewController {

    @IBOutlet var coupon_title: UILabel!
    @IBOutlet var coupon_validez: UILabel!
    @IBOutlet var code_coupon: UILabel!
    @IBOutlet var image_qr: UIImageView!
    @IBOutlet var image_caratule: UIImageView!
    
    @IBOutlet var view_code_qr: UIView!
    @IBOutlet var button_canjear: UIButton!
    @IBOutlet var coupon_description: UITextView!
    
    var idCupon: Int = 0
    var webServiceController = WebServiceController()
    var data: AnyObject!
    
    var qrcodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idCupon = idCupon as Int
       
        load_data(idCupon:idCupon)
        setup_ux()
        //generate_qr(qr:"BK002")
    }
    
    func load_data(idCupon:Int){
        showGifIndicator(view: self.view)

        let array_parameter = ["idCupon": idCupon]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetDetalleCupon(parameters: parameter_json_string!, doneFunction: GetDetalleCupon)
    }
    
    func GetDetalleCupon(status: Int, response: AnyObject){
        var json = JSON(response)
        if status == 1{
            var data = JSON(json["Data"])
            
            // Titulo
            coupon_title.text = data["nbCupon"].stringValue
            // Código
            code_coupon.text = data["cvCupon"].stringValue
            // Fecha
            let feInicio = data["feInicio"].stringValue
            let feInicio_array = feInicio.components(separatedBy: "T")
            let feFin = data["feFin"].stringValue
            let feFin_array = feFin.components(separatedBy: "T")
            
            let validez = "Validez: \(format_date_dmy(date_string: feInicio_array[0])) al \(format_date_dmy(date_string:feFin_array[0]))"
            coupon_validez.text = validez
            
            // Descripcion
            coupon_description.text = data["desCupon"].stringValue
            
            // Imagen
            var imagenesCupones = data["ImagenesCupones"].arrayValue
            var cuponImagen = JSON(imagenesCupones[0])
            
            var pathImage = cuponImagen["desRutaFoto"].stringValue
            pathImage = pathImage.replacingOccurrences(of: "~", with: "")
            pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
            
            let url =  "\(String(describing: Config.desRutaMultimedia))\(pathImage)"
            let URL = Foundation.URL(string: url)
            let image = UIImage(named: "default.png")
            
            image_caratule.kf.setImage(with: URL, placeholder: image)
            
            
        }else{
            showMessage(title: response as! String, automatic: true)
        }
        hiddenGifIndicator(view: self.view)
    }
    
    func setup_ux(){
        view_code_qr.isHidden = true
    }
    
    
    @IBAction func on_click_canjear_cupon(_ sender: Any) {
        
        showGifIndicator(view: self.view)
        
        let array_parameter = [
            "idCupon": idCupon,
            "idPersona": Defaults[.academic_idPersona]
            ] as [String : Any]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.CanjearCupon(parameters: parameter_json_string!, doneFunction: CanjearCupon)
        
   
    }
    
    func CanjearCupon(status: Int, response: AnyObject){
        let json = JSON(response)
        debugPrint(json)
        if status == 1{
            button_canjear.isHidden = true
            view_code_qr.isHidden = false
            generate_qr(qr: code_coupon.text!)
            
        }else{
            showMessage(title: response as! String, automatic: true)
        }
        hiddenGifIndicator(view: self.view)

    }
    
    func generate_qr(qr: String){
        
        if qrcodeImage == nil {
            let data = qr.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter?.outputImage
            //image_qr.image = UIImage(ciImage: (qrcodeImage!))
            
           displayQRCodeImage()
        }else {
            image_qr.image = nil
            qrcodeImage = nil
        }
    }
    
    func displayQRCodeImage() {
        let scaleX = image_qr.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = image_qr.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        image_qr.image = UIImage(ciImage: transformedImage)
    }
    
    
   
    

  
}
