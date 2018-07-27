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
import FilesProvider



class RegisterViewController: BaseViewController, FloatableTextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FileProviderDelegate{
    
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
    
    var webServiceController = WebServiceController()
    
    // FTP
    let server: URL = URL(string: "http://smarterasp.net")!
    let ftp_username = "ftpVerzity"
    let ftp_password = "ftp.Verzity"
    let path_folder = "~/Upload/Usuarios/"
    
    var webdav: WebDAVFileProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_ux()
        setup_textfield()
        setdata_facebook()
        
        let credential = URLCredential(user: self.ftp_username, password: self.ftp_password, persistence: URLCredential.Persistence.permanent)
        webdav = WebDAVFileProvider(baseURL: server, credential: credential)
        webdav?.delegate = self as FileProviderDelegate
        
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
       
        debugPrint(info)
        
        
        let localUrl = (info[UIImagePickerControllerMediaURL] ?? info[UIImagePickerControllerReferenceURL]) as? URL
            
        print (localUrl)
        //if you want to get the image name
        let imageName = localUrl?.path
        print(imageName)
            
            
            
      
        
        /*
        
        let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("fileprovider.png")
        
        webdav?.copyItem(localFile: localURL, to: remotePath, completionHandler: nil)
        
        var uIImagePickerControllerReferenceURL = info[UIImagePickerControllerReferenceURL] as! URL
        var uIImagePickerControllerImageURL = info["UIImagePickerControllerImageURL"] as! URL
        
        */
        
        let remotePath = "/fileprovider.png"
        //webdav?.copyItem(localFile: localUrl!, to: remotePath, completionHandler: nil)
        
        
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
        print("Registro")
        //upload(name_image: "asset.JPG")
        
        
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
                if password.text != confirm_password.text{
                    confirm_password.setState(.FAILED, with: "Las contraseñas no coinciden")
                    count_error = count_error + 1
                }else{
                    confirm_password.setState(.DEFAULT, with: "")
                    password.setState(.DEFAULT, with: "")
                }
            }
        }
       
        
        if  !swich_acept.isOn {
            count_error = count_error + 1
        }
      
        return count_error
    }
    
    
    func upload(name_image: String){
        print("upload")
        let localURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.appendingPathComponent(name_image)
    

        print(localURL)
        let remotePath = "/\(name_image)"
        
        webdav?.copyItem(localFile: localURL, to: remotePath, completionHandler: nil)
        
    }
    
    
    // FilesProvider
    func fileproviderSucceed(_ fileProvider: FileProviderOperations, operation: FileOperationType) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("\(source) copied to \(dest).")
        case .remove(path: let path):
            print("\(path) has been deleted.")
        default:
            if let destination = operation.destination {
                print("\(operation.actionDescription) from \(operation.source) to \(destination) succeed.")
            } else {
                print("\(operation.actionDescription) on \(operation.source) succeed.")
            }
        }
    }
    
    func fileproviderFailed(_ fileProvider: FileProviderOperations, operation: FileOperationType, error: Error) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("copying \(source) to \(dest) has been failed.")
        case .remove:
            print("file can't be deleted.")
        default:
            if let destination = operation.destination {
                print("\(operation.actionDescription) from \(operation.source) to \(destination) failed.")
            } else {
                print("\(operation.actionDescription) on \(operation.source) failed.")
            }
        }
    }
    
    func fileproviderProgress(_ fileProvider: FileProviderOperations, operation: FileOperationType, progress: Float) {
        print("Entro")
        switch operation {
        case .copy(source: let source, destination: let dest) where dest.hasPrefix("file://"):
            print("Downloading \(source) to \((dest as NSString).lastPathComponent): \(progress * 100) completed.")
        case .copy(source: let source, destination: let dest) where source.hasPrefix("file://"):
            print("Uploading \((source as NSString).lastPathComponent) to \(dest): \(progress * 100) completed.")
        case .copy(source: let source, destination: let dest):
            print("Copiando")
            print("Copy \(source) to \(dest): \(progress * 100) completed.")
        default:
            break
        }
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



