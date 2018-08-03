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
import SwiftyUserDefaults
import FilesProvider



class RegisterViewController: BaseViewController, FloatableTextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // oulets
    @IBOutlet var import_image: UIButton!
    @IBOutlet var img_profile: UIImageView!
    @IBOutlet weak var name_university: FloatableTextField!
    @IBOutlet var name_representative: FloatableTextField!
    @IBOutlet var swich_acept: UISwitch!
    @IBOutlet var confirm_password: FloatableTextField!
    @IBOutlet var password: FloatableTextField!
    @IBOutlet var email: FloatableTextField!
    @IBOutlet var phone_representative: FloatableTextField!
    
    @IBOutlet var accept_error: UILabel!
    
    // Contrains
    @IBOutlet var topContrainstLabelTerminos: NSLayoutConstraint!
    @IBOutlet var topConstrainsSwich: NSLayoutConstraint!
    @IBOutlet var topConstrainsButtonRegister: NSLayoutConstraint!
    
    // Datos obtenidos de facebook
    var facebook_url: String = ""
    var facebook_name: String = ""
    var facebook_email: String = ""
    var facebook_id: String = ""
    var is_facebook:Int = 0
    
    var name_image = ""
    
    // FTP
    let server = Defaults[.desRutaFTP]!
    let ftp_username = Defaults[.nbUsuarioFTP]!
    let ftp_password = Defaults[.desCarpetaMultimediaFTP]!
    let path_folder = Defaults[.pdwContraseniaFTP]!
    
    
    /*
     "ftp.smarterasp.net"
     "ftpVerzity"
     "ftp.Verzity"
    */
    
    let serverd = "ftp.smarterasp.net" //"jossuebetancourt.com/" //"reservanty.com"
    let ftp_usernamed = "ftpVerzity" //"develop@jossuebetancourt.com" //"reservanty"
    let ftp_passwordd = "ftp.Verzity" //"qwerty123*" //"AFRJ3vkd#_8y"
    
    var ftp:FTPUpload!
    var webServiceController = WebServiceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_ux()
        setup_textfield()
        setdata_facebook()
        
        // Ftp
        ftp = FTPUpload(baseUrl: serverd, userName: ftp_usernamed, password: ftp_passwordd, directoryPath: "/")
        
    }
    
    func setdata_facebook(){
        self.facebook_url = facebook_url as String
        self.facebook_name = facebook_name as String
        self.facebook_email = facebook_email as String
        self.is_facebook = Int(is_facebook)
        self.facebook_id = facebook_id as String
        
        name_representative.text = self.facebook_name
        email.text = self.facebook_email
        confirm_password.text = self.facebook_id
        password.text = String(describing: self.facebook_id)

        
        // Foto Profile
        let url = self.facebook_url
        let URL = Foundation.URL(string: url)
        let image_default = UIImage(named: "ic_user_profile.png")
        img_profile.kf.setImage(with: URL, placeholder: image_default)
        
        if is_facebook == 1{
            email.isEnabled = false
            password.isHidden = true
            confirm_password.isHidden = true
            topContrainstLabelTerminos.constant = -100
            topConstrainsSwich.constant = -100
            topConstrainsButtonRegister.constant = -70
        }
        
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
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            img_profile.image = image
        }else{
            showMessage(title: "Error al cargar la imagen", automatic: true)
        }
        self.dismiss(animated: true, completion: upload_photo)
    }
    
    func upload_photo(){
        print("Callback")
        let data = UIImageJPEGRepresentation(img_profile.image!, 1.0)
        self.name_image = randomString(length: 11) + "_ios.jpg"
        self.ftp.send(data: data!, with: name_image, success: success)
    }
    
    func success(is_sucess: Bool){
        print("Imagen cargada con exito")
        print(is_sucess)
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
        accept_error.isHidden = true
    }
    
    @objc(textField:shouldChangeCharactersIn:replacementString:) func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count == 0 {
            return true
        }
      
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        switch textField {
            case phone_representative:
                return newString.length <= 10
            default:
                return true
        }
    }
    
  
    @IBAction func on_click_register(_ sender: Any) {
        print("Registro")
        
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
                                    "cvDispositivo": Defaults[.cvDispositivo]!,
                                    "cvFirebase": Defaults[.cvFirebase]!,
                                    "idDispositivo": 0
                                ]
                        ],
                        "idPersona": 0,
                        "pathFoto": self.path_folder + self.name_image,
                        "nbCompleto": name_representative.text!,
                        "desTelefono": phone_representative.text! as String,
                        "Universidades": [
                            [
                            "idUniversidad": 0,
                            "nbUniversidad": name_university.text!,
                            "nbReprecentante": name_representative.text! as String
                            ]
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
            let alertController = UIAlertController(title: "Atención", message: "Se enviará la información para que sea verificada por el administrador, por favor espere el correo de confirmación del registro de la universidad.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alertController.addAction(defaultAction)
             present(alertController, animated: true, completion: nil)
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
        
        
        if is_facebook == 0 {
            if FormValidate.isEmptyTextField(textField: password){
                password.setState(.FAILED, with: StringsLabel.required)
                count_error = count_error + 1
            }else{
                
                if FormValidate.validate_min_length(password, maxLength: 8){
                    if password.text != confirm_password.text{
                        confirm_password.setState(.FAILED, with: StringsLabel.password_coinciden_invalid)
                        count_error = count_error + 1
                    }else{
                        confirm_password.setState(.DEFAULT, with: "")
                        password.setState(.DEFAULT, with: "")
                    }
                }else{
                    password.setState(.FAILED, with: StringsLabel.password_invalid)
                    count_error = count_error + 1
                }
                
                
            }
        }
       
        
        if  !swich_acept.isOn {
            count_error = count_error + 1
            accept_error.isHidden = false
            accept_error.text = StringsLabel.acept_invalid
        }else{
            accept_error.isHidden = true
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



