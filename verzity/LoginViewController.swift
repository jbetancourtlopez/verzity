//
//  ViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 18/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnForget: UILabel!
    @IBOutlet weak var btnHere: UILabel!
    @IBOutlet weak var btnRegister: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Forget Event
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.on_click_forget))
        btnForget.isUserInteractionEnabled = true
        btnForget.addGestureRecognizer(tap)
    }
    
    
    @IBAction func on_click_login(_ sender: Any) {
        
        _ = self.navigationController?.popToRootViewController(animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Navigation_MainViewController") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = vc
        
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

