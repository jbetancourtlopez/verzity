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
import SwiftyUserDefaults


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
        
        Defaults[.cvDispositivo] = UIDevice.current.identifierForVendor!.uuidString
        print("Firebase Login: \(Defaults[.cvFirebase])")
       
        // End Facebook
        // var image_facebook = UIImage(named: "icon_face_white")
        //button_facaebook.imageEdgeInsets = UIEdgeInsets(top: 5, left: (button_facaebook.bounds.width - 35), bottom: 5, right: 5)
        //button_facaebook.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (image_facebook?.frame.width)!)
        
        // Llamada a Firebase
       
        
        // Forget Event
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.on_click_forget))
        btnForget.isUserInteractionEnabled = true
        btnForget.addGestureRecognizer(tap)
        
        // Here Event
        let tap_here = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.on_click_here))
        btnHere.isUserInteractionEnabled = true
        btnHere.addGestureRecognizer(tap_here)
    }
    
   
    
    // On_click_facebook
    @IBAction func on_click_facebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    func setup_uicontrols(){
        email.floatableDelegate = self
        password.floatableDelegate = self
    }

    @IBAction func on_click_login(_ sender: Any) {
        
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
        debugPrint(response)
        if status == 1{
            var json = JSON(response)
            let data = JSON(json["Data"])
            
            let personas = JSON(data["Personas"])
            let universidades_list = personas["Universidades"].array
            let universidades = JSON(universidades_list![0])
            let paquete = JSON(universidades["VentasPaquetes"])
            let direccion_uni = JSON(universidades["Direcciones"])
            let direccion_rep = JSON(personas["Direcciones"])
            
            
            setSettings(key: "profile_menu", value: "profile_university")
            Defaults[.type_user] = 2
            
            //Paquete
            Defaults[.package_idUniveridad] = paquete["idUniversidad"].intValue
            Defaults[.package_idPaquete] = paquete["idPaquete"].intValue
            
            //Universidad
            Defaults[.university_idUniveridad] = universidades["idUniversidad"].intValue
            Defaults[.university_pathLogo] = universidades["pathLogo"].stringValue
            Defaults[.university_nbUniversidad] = universidades["nbUniversidad"].stringValue
            Defaults[.university_nbReprecentante] = universidades["nbReprecentante"].stringValue
            Defaults[.university_desUniversidad] = universidades["desUniversidad"].stringValue
            Defaults[.university_desSitioWeb] = universidades["desSitioWeb"].stringValue
            Defaults[.university_desTelefono] = universidades["desTelefono"].stringValue
            Defaults[.university_desCorreo] = universidades["desCorreo"].stringValue
            Defaults[.university_idPersona] = universidades["idPersona"].intValue
            
            //Persona Universidad
            Defaults[.representative_nbCompleto] = personas["nbCompleto"].stringValue
            Defaults[.representative_desTelefono] = personas["desTelefono"].stringValue
            Defaults[.representative_desCorreo] = personas["desCorreo"].stringValue
            Defaults[.representative_pathFoto] = personas["pathFoto"].stringValue
            
            // Direccion Representante
            Defaults[.add_rep_desDireccion] = direccion_rep["desDireccion"].stringValue
            Defaults[.add_rep_numCodigoPostal] = direccion_rep["numCodigoPostal"].stringValue
            Defaults[.add_rep_nbPais] = direccion_rep["nbPais"].stringValue
            Defaults[.add_rep_nbEstado] = direccion_rep["nbEstado"].stringValue
            Defaults[.add_rep_nbMunicipio] = direccion_rep["nbMunicipio"].stringValue
            Defaults[.add_rep_nbCiudad] = direccion_rep["nbCiudad"].stringValue
            Defaults[.add_rep_dcLatitud] = direccion_rep["dcLatitud"].stringValue
            Defaults[.add_rep_dcLongitud] = direccion_rep["dcLongitud"].stringValue
            
            // Direccion Universidad
            Defaults[.add_uni_desDireccion] = direccion_uni["desDireccion"].stringValue
            Defaults[.add_uni_numCodigoPostal] = direccion_uni["numCodigoPostal"].stringValue
            Defaults[.add_uni_nbPais] = direccion_uni["nbPais"].stringValue
            Defaults[.add_uni_nbEstado] = direccion_uni["nbEstado"].stringValue
            Defaults[.add_uni_nbMunicipio] = direccion_uni["nbMunicipio"].stringValue
            Defaults[.add_uni_nbCiudad] = direccion_uni["nbCiudad"].stringValue
            Defaults[.add_uni_dcLatitud] = direccion_uni["dcLatitud"].stringValue
            Defaults[.add_uni_dcLongitud] = direccion_uni["dcLongitud"].stringValue
            
            /*
            let vc = storyboard?.instantiateViewController(withIdentifier: "SplashViewControllerID") as! SplashViewController
            self.show(vc, sender: nil)
            */
            performSegue(withIdentifier: "showSplash", sender: self)
            
            
        }else{
            showMessage(title: response as! String, automatic: true)
        }
    }
    // On_click_Here(AQUI)
    @objc func on_click_here(sender:UITapGestureRecognizer) {
        print("on_click_aqui")
        
        let array_parameter = [
            "cvFirebase": Defaults[.cvFirebase],
            "cvDispositivo": Defaults[.cvDispositivo]
        ]
        
        debugPrint(array_parameter)
        
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.IngresarUniversitario(parameters: parameter_json_string!, doneFunction: IngresarUniversitario)
    }
    
    // Callback - On_click_Here(AQUI)
    func IngresarUniversitario(status: Int, response: AnyObject){
        var json = JSON(response)
        debugPrint(json)
        if status == 1{
            let data_json = JSON(json["Data"])
            
            //Config
            setSettings(key: "profile_menu", value: "profile_academic")
            
            let persona_json = JSON(data_json["Personas"])
            let direcciones = JSON(persona_json["Direcciones"])
            
            
            var nbCompleto = persona_json["nbCompleto"].stringValue
            var desCorreo = persona_json["desCorreo"].stringValue
            
            if nbCompleto == "temp" {
                nbCompleto = ""
            }
            
            if desCorreo == "temp@email.com" {
                desCorreo = ""
            }
            Defaults[.type_user] = 1
            Defaults[.academic_idPersona] = persona_json["idPersona"].intValue
            Defaults[.academic_idDireccion] = direcciones["idDireccion"].intValue


            Defaults[.academic_name] = nbCompleto
            Defaults[.academic_email] = desCorreo
            Defaults[.academic_phone] =  persona_json["desTelefono"].stringValue
            Defaults[.academic_nbPais] = direcciones["nbPais"].stringValue
            Defaults[.academic_cp] = direcciones["numCodigoPostal"].stringValue
            Defaults[.academic_city] = direcciones["nbCiudad"].stringValue
            Defaults[.academic_municipio] = direcciones["nbMunicipio"].stringValue
            Defaults[.academic_state] = direcciones["nbEstado"].stringValue
            Defaults[.academic_description] =  direcciones["desDireccion"].stringValue
            
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

