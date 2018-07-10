//
//  ViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 18/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SwiftyJSON
import FloatableTextField


class LoginViewController: BaseViewController, FloatableTextFieldDelegate {

    @IBOutlet weak var email: FloatableTextField!
    @IBOutlet weak var password: FloatableTextField!
    @IBOutlet weak var btnForget: UILabel!
    @IBOutlet weak var btnHere: UILabel!
    @IBOutlet weak var btnRegister: UILabel!
    
    var webServiceController = WebServiceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup_uicontrols()
        
        // Forget Event
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.on_click_forget))
        btnForget.isUserInteractionEnabled = true
        btnForget.addGestureRecognizer(tap)
        
        // Here Event
        let tap_here = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.on_click_here))
        btnHere.isUserInteractionEnabled = true
        btnHere.addGestureRecognizer(tap_here)
    }
    
    func setup_uicontrols(){
        email.floatableDelegate = self
        password.floatableDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setSettings(key: "profile_menu", value: "")
        setSettings(key: "name_profile", value: "")
        setSettings(key: "name_email", value: "")
    }
    
    
    @IBAction func on_click_login(_ sender: Any) {
        setSettings(key: "profile_menu", value: "profile_university")
    
            if validate_form() == 0 {
            //if  true {
                //showGifIndicator(view: self.view)

                let array_parameter = [
                    "pwdContrasenia": password.text,
                    "nbUsuario": email.text
                ]
                let parameter_json = JSON(array_parameter)
                let parameter_json_string = parameter_json.rawString()
                webServiceController.IngresarAppUniversidad(parameters: parameter_json_string!, doneFunction: IngresarAppUniversidad)
            }
       
    }

    func IngresarAppUniversidad(status: Int, response: AnyObject){
        
        
        let json = JSON(response)
        debugPrint(json)
        if status == 1 || true {
            hiddenGifIndicator(view: self.view)
            _ = self.navigationController?.popToRootViewController(animated: false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Navigation_MainViewController") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = vc
        }else{
            hiddenGifIndicator(view: self.view)
            showMessage(title: response as! String, automatic: true)
        }
        
        
    }
    
    
    
    @objc func on_click_here(sender:UITapGestureRecognizer) {
        print("AQUI")
        let cvDispositivo =  Config.UID
        
        let array_parameter = [
            "cvFirebase": Config.cvFirebase,
            "cvDispositivo": cvDispositivo
        ]
        
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.IngresarAppUniversitario(parameters: parameter_json_string!, doneFunction: sigin_academic)
        
    }
    
    func sigin_academic(status: Int, response: AnyObject){
        var json = JSON(response)
        debugPrint(json)
        if status == 1{
            let data = json["Data"].rawValue
            var data_json = JSON(data)
            
            //Config
            setSettings(key: "profile_menu", value: "profile_academic")
            
            //Persona
            let persona_json = JSON(data_json["Personas"])
            let idPersona = persona_json["idPersona"].stringValue
            var nbCompleto = persona_json["nbCompleto"].stringValue
            var desCorreo = persona_json["desCorreo"].stringValue
            
            if nbCompleto == "temp" {
                nbCompleto = ""
            }
            
            if desCorreo == "temp@email.com" {
                desCorreo = ""
            }
            
            setSettings(key: "persona", value: data_json["Personas"].stringValue)
            setSettings(key: "name_profile", value: nbCompleto)
            setSettings(key: "email_profile", value: desCorreo)
            setSettings(key: "phone_profile", value: persona_json["desTelefono"].stringValue)
            setSettings(key: "idPersona", value: idPersona)
            
            // Direcciones
            let direcciones = JSON(persona_json["Direcciones"])
            setSettings(key: "nbPais", value: direcciones["nbPais"].stringValue)
            setSettings(key: "cp_profile", value: direcciones["numCodigoPostal"].stringValue)
            setSettings(key: "city_profile", value: direcciones["nbCiudad"].stringValue)
            setSettings(key: "municipio_profile", value: direcciones["nbMunicipio"].stringValue)
            setSettings(key: "state_profile", value: direcciones["nbEstado"].stringValue)
            setSettings(key: "description_profile", value: direcciones["desDireccion"].stringValue)
            
            
            _ = self.navigationController?.popToRootViewController(animated: false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Navigation_MainViewController") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = vc
        }else{
           updateAlert(title: "Error", message: response as! String, automatic: true)
        }
        
        
    }
    
    @objc func on_click_forget(sender:UITapGestureRecognizer) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "ForgetViewControllerID") as! ForgetViewController
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController!.navigationBar.topItem!.title = ""
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func validate_form()-> Int{
        
        var count_error:Int = 0
        if FormValidate.isEmptyTextField(textField: email){
            //email.setState(.FAILED, with: StringsLabel.required)
            updateAlert(title: "Correo electrónico", message: StringsLabel.required, automatic: true)
            count_error = count_error + 1
            return count_error
        }else{
            if FormValidate.validateEmail(email.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) == false {
                //email.setState(.FAILED, with: StringsLabel.email_invalid)
                updateAlert(title: "Correo electrónico", message: StringsLabel.email_invalid, automatic: true)
                count_error = count_error + 1
                return count_error
            }else{
                email.setState(.DEFAULT, with: "")
            }
        }
        
        if FormValidate.isEmptyTextField(textField: password){
            //email.setState(.FAILED, with: StringsLabel.required)
            updateAlert(title: "Contraseña", message: StringsLabel.required, automatic: true)
            count_error = count_error + 1
            return count_error
        }else{
            email.setState(.DEFAULT, with: "")
        }
        
        return count_error
    }

}

extension LoginViewController: ForgetViewControllerDelegate {
    func okButtonTapped(textFieldValue: String) {
        
        let array_parameter = ["nbUsuario": textFieldValue]
        
        if FormValidate.validateEmail(textFieldValue){
            showGifIndicator(view: self.view)
            let parameter_json = JSON(array_parameter)
            let parameter_json_string = parameter_json.rawString()
            webServiceController.RecuperarContrasenia(parameters: parameter_json_string!, doneFunction: RecuperarContrasenia)
        }else{
            showMessage(title: StringsLabel.email_invalid, automatic: true)
        }
        
        
    }
    
    func RecuperarContrasenia(status: Int, response: AnyObject){
        let json = JSON(response)
        
        if status == 1{
            showMessage(title: json["Mensaje"].stringValue, automatic: true)
        }
        
        hiddenGifIndicator(view: self.view)
        showMessage(title: response as! String, automatic: true)
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
}

