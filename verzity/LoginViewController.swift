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

class LoginViewController: BaseViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnForget: UILabel!
    @IBOutlet weak var btnHere: UILabel!
    @IBOutlet weak var btnRegister: UILabel!
    
    var webServiceController = WebServiceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Forget Event
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.on_click_forget))
        btnForget.isUserInteractionEnabled = true
        btnForget.addGestureRecognizer(tap)
        
        // Here Event
        let tap_here = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.on_click_here))
        btnHere.isUserInteractionEnabled = true
        btnHere.addGestureRecognizer(tap_here)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setSettings(key: "profile_menu", value: "")
        setSettings(key: "nbCompleto", value: "")
        setSettings(key: "desCorreo", value: "")
    }
    
    
    @IBAction func on_click_login(_ sender: Any) {
        setSettings(key: "profile_menu", value: "profile_university")

        _ = self.navigationController?.popToRootViewController(animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Navigation_MainViewController") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    @objc func on_click_here(sender:UITapGestureRecognizer) {
        print("AQUI")
        let cvDispositivo =  UIDevice.current.identifierForVendor!.uuidString
        
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
        
        if status == 1{
            let data = json["Data"].rawValue
            var data_json = JSON(data)
            
            debugPrint(data_json)
            
            let persona_json = JSON(data_json["Personas"])
            
            var nbCompleto = persona_json["nbCompleto"].stringValue
            var desCorreo = persona_json["desCorreo"].stringValue
            let idPersona = persona_json["idPersona"].stringValue
            
            if nbCompleto == "temp" {
                nbCompleto = ""
            }
            
            if desCorreo == "temp@email.com" {
                desCorreo = ""
            }
            
            setSettings(key: "persona", value: data_json["Personas"].stringValue)
            setSettings(key: "profile_menu", value: "profile_academic")
            setSettings(key: "nbCompleto", value: nbCompleto)
            setSettings(key: "desCorreo", value: desCorreo)
            setSettings(key: "idPersona", value: idPersona)
            
            
            _ = self.navigationController?.popToRootViewController(animated: false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Navigation_MainViewController") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = vc
        }else{
           updateAlert(title: "Error", message: response as! String, automatic: true)
        }
        
        
    }
    @objc func on_click_forget(sender:UITapGestureRecognizer) {
        print("Recuperar contraseña")
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "ForgetViewControllerID") as! ForgetViewController
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController!.navigationBar.topItem!.title = ""
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

}

extension LoginViewController: ForgetViewControllerDelegate {
    func okButtonTapped(textFieldValue: String) {
        print("TextField has value: \(textFieldValue)")
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
}

