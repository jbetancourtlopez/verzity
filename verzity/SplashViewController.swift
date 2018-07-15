//
//  LaunchViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 14/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class SplashViewController: BaseViewController {
    
    var webServiceController = WebServiceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Llamada a Firebase
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayFCMToken(notification:)),
                                               name: Notification.Name("FCMToken"), object: nil)
        load_settings()
    }
    
    
     // Firebase Event
    @objc func displayFCMToken(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        print("Debug-FirebaseToken Splash: \(userInfo["token"])")
        if let fcmToken = userInfo["token"] as? String {
            Defaults[.cvFirebase] = fcmToken
        }
    }
    
    func load_settings() {
        showGifIndicator(view: self.view)
        let array_parameter = ["": ""]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.getSettings(parameters: parameter_json_string!, doneFunction: getSettings)
    }
    
    func getSettings(status: Int, response: AnyObject){
        hiddenGifIndicator(view: self.view)
        var json = JSON(response)
        if status == 1{
            
            // Guardamos las configuracion
            var data = JSON(json["Data"])
            
            Defaults[.id_Configuraciones] = data["id_Configuraciones"].intValue
            Defaults[.desRutaWebServices] = data["desRutaWebServices"].stringValue
            Defaults[.desRutaMultimedia] = data["desRutaMultimedia"].stringValue
            Defaults[.cvPaypal] = data["cvPaypal"].stringValue
            Defaults[.desRutaFTP] = data["desRutaFTP"].stringValue
            Defaults[.nbUsuarioFTP] = data["nbUsuarioFTP"].stringValue
            Defaults[.pdwContraseniaFTP] = data["pdwContraseniaFTP"].stringValue
            Defaults[.desCarpetaMultimediaFTP] = data["desCarpetaMultimediaFTP"].stringValue
            
            // Validar Usuario
            validate_user()
        }
    }
    
    
    func validate_user(){
        
        print("Esta logueado el usuario: \(Defaults[.type_user])")
        
        if Defaults[.type_user] == 1{
            
            _ = self.navigationController?.popToRootViewController(animated: false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Navigation_MainViewController") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = vc
            
        } else if Defaults[.type_user] == 2 {
            print("Valido su activacion")
            showGifIndicator(view: self.view)

            let idUniveridad =  Defaults[.university_idUniveridad]
            let array_parameter = ["idUniversidad": idUniveridad]
            
            let parameter_json = JSON(array_parameter)
            let parameter_json_string = parameter_json.rawString()
            webServiceController.VerificarEstatusUniversidad(parameters: parameter_json_string!, doneFunction: VerificarEstatusUniversidad)
            
            
           
        }else{
            performSegue(withIdentifier: "showLogin", sender: self)
        }
        
        
        
    }
    
    func VerificarEstatusUniversidad(status: Int, response: AnyObject){
        hiddenGifIndicator(view: self.view)
        print("Validadon Universidad")
        let json = JSON(response)
        debugPrint(json)
        if status == 1{
          
            _ = self.navigationController?.popToRootViewController(animated: false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Navigation_MainViewController") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = vc
            
        }else{
            
            let yesAction = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                self.performSegue(withIdentifier: "showLogin", sender: self)
            }
            
            showAlert("Atención", message: StringsLabel.account_invalid, okAction: yesAction, cancelAction: nil, automatic: false)
            
            
        }
        
        
    }
    
    
    
}

