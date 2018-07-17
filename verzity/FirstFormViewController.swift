//
//  FirstFormViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 10/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import FloatableTextField
import SwiftyJSON
import SwiftyUserDefaults

class FirstFormViewController: BaseViewController, FloatableTextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var first_name_university: FloatableTextField!
    @IBOutlet var first_name_representative: FloatableTextField!
    @IBOutlet var first_description: FloatableTextField!
    @IBOutlet var first_web: FloatableTextField!
    @IBOutlet var first_phone: FloatableTextField!
    @IBOutlet var first_email: FloatableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_textfield()
        set_data()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        self.view.addGestureRecognizer(tap)
        
        registerForKeyboardNotifications(scrollView: scrollView)
        setGestureRecognizerHiddenKeyboard()
    }
    
    func validate_form()-> Int{
        var count_error:Int = 0
        
        //Nombre universida
        if FormValidate.isEmptyTextField(textField: first_name_university){
            //first_name_university.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            //first_name_university.setState(.DEFAULT, with: "")
        }
        
        //Nombre representante
        if FormValidate.isEmptyTextField(textField: first_name_representative){
            //first_name_representative.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            //first_name_representative.setState(.DEFAULT, with: "")
        }
        
        //Descripcion
        if FormValidate.isEmptyTextField(textField: first_description){
            //first_description.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            //first_description.setState(.DEFAULT, with: "")
        }
        
        //Sitio web
        if FormValidate.isEmptyTextField(textField: first_web){
            //first_web.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            if !FormValidate.validateUrl(urlString: first_web.text! as NSString){
                //first_web.setState(.FAILED, with: StringsLabel.no_website)
                count_error = count_error + 1
            }else{
                //first_web.setState(.DEFAULT, with: "")
            }
            
        }
        
        //Telefono
        if FormValidate.isEmptyTextField(textField: first_phone){
            //first_phone.setState(.FAILED, with: StringsLabel.phone_invalid)
            count_error = count_error + 1
        }else{
            if FormValidate.validatePhone(textField: first_phone){
                //first_phone.setState(.FAILED, with: StringsLabel.phone_invalid)
                count_error = count_error + 1
            }else{
                //first_phone.setState(.DEFAULT, with: "")
            }
        }
        
        // Email
        if FormValidate.isEmptyTextField(textField: first_email){
            //first_email.setState(.FAILED, with: StringsLabel.required)
            count_error = count_error + 1
        }else{
            if FormValidate.validateEmail(first_email.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) == false {
                //first_email.setState(.FAILED, with: StringsLabel.email_invalid)
                count_error = count_error + 1
            }else{
                //first_email.setState(.DEFAULT, with: "")
            }
        }
        
        
        
        
        return count_error
    }
    
    func setup_textfield(){
        first_name_university.floatableDelegate = self
        first_name_representative.floatableDelegate = self
        first_description.floatableDelegate = self
        first_web.floatableDelegate = self
        first_phone.floatableDelegate = self
        first_email.floatableDelegate = self
    }
    
    func set_data(){
        first_name_university.text = Defaults[.university_nbUniversidad]
        first_name_representative.text = Defaults[.university_nbReprecentante]
        first_description.text = Defaults[.university_desUniversidad]
        first_web.text = Defaults[.university_desSitioWeb]
        first_phone.text = Defaults[.university_desTelefono]
        first_email.text = Defaults[.university_desCorreo]
    }
}
