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
import FacebookLogin
import FBSDKLoginKit
import Firebase


class LoginViewController: BaseViewController, FloatableTextFieldDelegate {

    @IBOutlet weak var email: FloatableTextField!
    @IBOutlet weak var password: FloatableTextField!
    @IBOutlet weak var btnForget: UILabel!
    @IBOutlet weak var btnHere: UILabel!
    @IBOutlet weak var btnRegister: UILabel!
    @IBOutlet var button_facaebook: UIButton!
    
    var webServiceController = WebServiceController()
    var dict : [String : AnyObject]!
    var is_click_facebook = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setup_uicontrols()
        setup_ux()
       
        // End Facebook
        // var image_facebook = UIImage(named: "icon_face_white")
        //button_facaebook.imageEdgeInsets = UIEdgeInsets(top: 5, left: (button_facaebook.bounds.width - 35), bottom: 5, right: 5)
        //button_facaebook.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (image_facebook?.frame.width)!)
        
        /*
        // Llamada a Firebase
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayFCMToken(notification:)),
                                               name: Notification.Name("FCMToken"), object: nil)
         */
        
        // Forget Event
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.on_click_forget))
        btnForget.isUserInteractionEnabled = true
        btnForget.addGestureRecognizer(tap)
        
        // Here Event
        let tap_here = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.on_click_here))
        btnHere.isUserInteractionEnabled = true
        btnHere.addGestureRecognizer(tap_here)
    }
    
    // Firebase Event
    @objc func displayFCMToken(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        if let fcmToken = userInfo["token"] as? String {
            print("Received FCM token: \(fcmToken)")
        }
    }
    
    // On_click_facebook
    @IBAction func on_click_facebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                self.is_click_facebook = 1
            case .cancelled:
                print("User cancelled login.")
                self.is_click_facebook = 1
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
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
                showGifIndicator(view: self.view)
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
        hiddenGifIndicator(view: self.view)
        var json = JSON(response)
        debugPrint(json)
        if status == 1 || true {
            
            
            _ = self.navigationController?.popToRootViewController(animated: false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Navigation_MainViewController") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = vc
        }else{
            showMessage(title: response as! String, automatic: true)
        }
    }
    // On_click_Here(AQUI)
    @objc func on_click_here(sender:UITapGestureRecognizer) {
        print("AQUI")
        let cvDispositivo =  Config.UID
        let array_parameter = [
            "cvFirebase": Config.cvFirebase,
            "cvDispositivo": cvDispositivo
        ]
        
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.IngresarAppUniversitario(parameters: parameter_json_string!, doneFunction: ingresarAppUniversitario)
        
    }
    
    // Callback - On_click_Here(AQUI)
    func ingresarAppUniversitario(status: Int, response: AnyObject){
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

    func setup_ux(){
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
    
    //function is fetching the user data
    func getFBUserData(){

        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    
                    var picture = self.dict["picture"] as! [String : AnyObject]
                    var data = picture["data"] as! [String : AnyObject]
                    var url = data["url"] as! String
 
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewControllerID") as! RegisterViewController
                    vc.facebook_name = self.dict["name"] as! String
                    vc.facebook_email = self.dict["email"] as! String
                    vc.facebook_url = url
                    vc.is_facebook = 1
                    self.show(vc, sender: nil)
 
                }
            })
        }
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
        }else{
           showMessage(title: response as! String, automatic: true)
        }
        hiddenGifIndicator(view: self.view)
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
}

