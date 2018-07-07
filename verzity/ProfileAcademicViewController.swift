//
//  ProfileAcademicViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 30/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import FloatableTextField
import SwiftyJSON

class ProfileAcademicViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FloatableTextFieldDelegate{
    
    @IBOutlet var topContraintDescription: NSLayoutConstraint!
    @IBOutlet var img_profile: UIImageView!
    @IBOutlet var import_image: UIButton!
    @IBOutlet var countryPickerView: UIPickerView!
    
    
    @IBOutlet var name_profile: FloatableTextField!
    @IBOutlet var phone_profile: FloatableTextField!
    @IBOutlet var cp_profile: FloatableTextField!
    @IBOutlet var description_profile: FloatableTextField!
    @IBOutlet var city_profile: FloatableTextField!
    @IBOutlet var municipio_profile: FloatableTextField!
    @IBOutlet var email_profile: FloatableTextField!
    @IBOutlet var state_profile: FloatableTextField!
    let countries = ["Mexico", "Francia", "Argentina"]
    var is_mexico = 1;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_ux()
        setup_textfield()
        cp_profile.addTarget(self, action: "cpDidChange:", for: UIControlEvents.editingChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        self.view.addGestureRecognizer(tap)
        
        // Get Data Preferencias
        get_data_profile()

    }
    
    @objc func cpDidChange(_ textField: UITextField) {
        print("Cambio")
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
    
    @IBAction func on_click_continue(_ sender: Any) {
        print("Continuar")
        if validate_form() == 0 {
            
            setSettings(key: "name_profile", value: name_profile.text!)
            setSettings(key: "phone_profile", value: phone_profile.text!)
            setSettings(key: "cp_profile", value: cp_profile.text!)
            setSettings(key: "description_profile", value: description_profile.text!)
            setSettings(key: "city_profile", value: city_profile.text!)
            setSettings(key: "municipio_profile", value: municipio_profile.text!)
            setSettings(key: "email_profile", value: email_profile.text!)
            setSettings(key: "state_profile", value: state_profile.text!)
            
            showMessage(title: StringsLabel.operation_complete, automatic: true)
        }
        
    }
    
    func get_data_profile(){
        name_profile.text = getSettings(key: "name_profile")
        phone_profile.text = getSettings(key: "phone_profile")
        cp_profile.text = getSettings(key: "cp_profile")
        description_profile.text = getSettings(key: "description_profile")
        city_profile.text = getSettings(key: "city_profile")
        municipio_profile.text = getSettings(key: "municipio_profile")
        email_profile.text = getSettings(key: "email_profile")
        state_profile.text = getSettings(key: "state_profile")
    }
    
    func setup_ux(){
        self.img_profile.layer.masksToBounds = true
        self.img_profile.cornerRadius = 60
        self.import_image.layer.masksToBounds = true
        self.import_image.cornerRadius = 17.5
    }
    
    func setup_textfield(){
        name_profile.floatableDelegate = self
        phone_profile.floatableDelegate = self
        cp_profile.floatableDelegate = self
        description_profile.floatableDelegate = self
        city_profile.floatableDelegate = self
        municipio_profile.floatableDelegate = self
        email_profile.floatableDelegate = self
        state_profile.floatableDelegate = self
    }
    
    // Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return  countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Seleccionado")
        if  countries[row] != "Mexico"{
            cp_profile.isHidden = true
            state_profile.isHidden = true
            municipio_profile.isHidden = true
            city_profile.isHidden = true
            topContraintDescription.constant = -260
            is_mexico = 0
            
        }else{
            cp_profile.isHidden = false
            state_profile.isHidden = false
            municipio_profile.isHidden = false
            city_profile.isHidden = false
            topContraintDescription.constant = 0
            is_mexico = 1
        }
    }
    
    
    func validate_form()-> Int{
        
        var count_error:Int = 0
        
        //Nombre
        if FormValidate.isEmptyTextField(textField: name_profile){
            name_profile.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            name_profile.setState(.DEFAULT, with: "")
        }
        
        //Telefono
        if FormValidate.isEmptyTextField(textField: phone_profile){
            phone_profile.setState(.FAILED, with: StringsLabel.phone_invalid)
            count_error = count_error + 1
        }else{
            if FormValidate.validatePhone(textField: phone_profile){
                phone_profile.setState(.FAILED, with: StringsLabel.phone_invalid)
                count_error = count_error + 1
            }else{
                phone_profile.setState(.DEFAULT, with: "")
            }
        }
 
        
        if FormValidate.isEmptyTextField(textField: email_profile){
            email_profile.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            if FormValidate.validateEmail(email_profile.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) == false {
                email_profile.setState(.FAILED, with: StringsLabel.email_invalid)
                count_error = count_error + 1
            }else{
                email_profile.setState(.DEFAULT, with: "")
            }
        }
        
        // CP
        if  is_mexico == 1{
            if FormValidate.isEmptyTextField(textField: cp_profile){
                cp_profile.setState(.FAILED, with: StringsLabel.required)
                count_error = count_error + 1
            }else{
                cp_profile.setState(.DEFAULT, with: "")
            }
        }
        
        
        return count_error
    }
    


}
