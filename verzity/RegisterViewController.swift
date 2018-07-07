//
//  RegisterViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 19/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import FloatableTextField
import SwiftyJSON



class RegisterViewController: BaseViewController, FloatableTextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var import_image: UIButton!
    @IBOutlet var img_profile: UIImageView!
    @IBOutlet weak var name_university: FloatableTextField!
    @IBOutlet var name_representative: FloatableTextField!
    @IBOutlet var swich_acept: UISwitch!
    @IBOutlet var confirm_password: FloatableTextField!
    @IBOutlet var password: FloatableTextField!
    @IBOutlet var email: FloatableTextField!
    @IBOutlet var phone_representative: FloatableTextField!
    
    var webServiceController = WebServiceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_ux()
        setup_textfield()
    }
    
    @IBAction func import_image(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        self.present(image, animated: true){
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            img_profile.image = image
        }else{
            showMessage(title: "Error al cargar la imagen", automatic: true)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func setup_ux(){
        
        self.navigationItem.title = "Registro"
        
        self.navigationController?.isNavigationBarHidden = false
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationController?.navigationBar.backItem?.backBarButtonItem = backItem
        
        // Image
        self.img_profile.layer.masksToBounds = true
        self.img_profile.cornerRadius = 60
        self.import_image.layer.masksToBounds = true
        self.import_image.cornerRadius = 17.5
    }
    
    func setup_textfield(){
        name_university.floatableDelegate = self
        name_representative.floatableDelegate = self
        confirm_password.floatableDelegate = self
        password.floatableDelegate = self
        email.floatableDelegate = self
        phone_representative.floatableDelegate = self
    }
    


    @IBAction func on_click_register(_ sender: Any) {
        
        if validate_form() == 0 {
            
            showGifIndicator(view: self.view)
            let cvDispositivo =  UIDevice.current.identifierForVendor!.uuidString

            let array_parameter = [
                "pwdContrasenia": password.text!,
                "idUsuario": 0,
                "nbUsuario": email.text!,
                "Personas": [
                    "desCorreo": email.text! as String,
                    "Dispositivos": [
                            [
                                "cvDispositivo": cvDispositivo,
                                "cvFirebase": "Fix",
                                "idDispositivo": 0
                            ]
                    ]
                ],
                "idPersona": 0,
                "nbCompleto": name_representative.text!,
                "desTelefono": phone_representative.text! as String,
                "Universidades": [
                    [
                    "idUniversidad": 0,
                    "nbUniversidad": name_university.text!,
                    "nbReprecentante": name_representative.text! as String
                    ]
                ]
                
                ] as [String : Any]
            
            
            let parameter_json = JSON(array_parameter)
            let parameter_json_string = parameter_json.rawString()
            webServiceController.CrearCuentaAcceso(parameters: parameter_json_string!, doneFunction: CrearCuentaAcceso)
        }
    }
    
    
    func CrearCuentaAcceso(status: Int, response: AnyObject){
        let json = JSON(response)
        
        if status == 1{
            showMessage(title: json["Mensaje"].stringValue , automatic: true)
        }else {
            showMessage(title: response as! String, automatic: true)
        }
        hiddenGifIndicator(view: self.view)
        
    }
    
    
    func validate_form()-> Int{
       
        var count_error:Int = 0
        
        if FormValidate.isEmptyTextField(textField: name_university){
            name_university.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            name_university.setState(.DEFAULT, with: "")
        }
        
        //Telefono Repressentante
        if FormValidate.isEmptyTextField(textField: phone_representative){
            phone_representative.setState(.FAILED, with: StringsLabel.phone_invalid)
            count_error = count_error + 1
        }else{
            if FormValidate.validatePhone(textField: phone_representative){
                phone_representative.setState(.FAILED, with: StringsLabel.phone_invalid)
                count_error = count_error + 1
            }else{
                phone_representative.setState(.DEFAULT, with: "")
            }
        }
        
        // Nombre Representante
        if FormValidate.isEmptyTextField(textField: name_representative){
            name_representative.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            name_representative.setState(.DEFAULT, with: "")
        }
        
        
        if FormValidate.isEmptyTextField(textField: email){
            email.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            if FormValidate.validateEmail(email.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) == false {
                email.setState(.FAILED, with: StringsLabel.email_invalid)
                count_error = count_error + 1
            }else{
                email.setState(.DEFAULT, with: "")
            }
        }
        
        if FormValidate.isEmptyTextField(textField: password){
            password.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            if password.text != confirm_password.text{
                confirm_password.setState(.FAILED, with: "Las contraseñas no coinciden")
                count_error = count_error + 1
            }else{
                confirm_password.setState(.DEFAULT, with: "")
                password.setState(.DEFAULT, with: "")
            }
        }
        
        if  !swich_acept.isOn {
            count_error = count_error + 1
        }
      
        return count_error
    }
    
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}



