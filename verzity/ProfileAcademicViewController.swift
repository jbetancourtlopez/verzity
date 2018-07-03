//
//  ProfileAcademicViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 30/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit

class ProfileAcademicViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet var img_profile: UIImageView!
    @IBOutlet var import_image: UIButton!
    @IBOutlet var countryPickerView: UIPickerView!
    
    
    @IBOutlet var name_profile: UITextField!
    
    @IBOutlet var phone_profile: UITextField!
    
    @IBOutlet var cp_profile: UITextField!
    
    @IBOutlet var description_profile: UITextField!
    @IBOutlet var city_profile: UITextField!
    @IBOutlet var municipio_profile: UITextField!
    @IBOutlet var email_profile: UITextField!
    @IBOutlet var state_profile: UITextField!
    
    let countries = ["Mexico", "Francia", "Argentina"]
    override func viewDidLoad() {
        super.viewDidLoad()

        setup_ux()
        
        cp_profile.addTarget(self, action: "cpDidChange:", for: UIControlEvents.editingChanged)

        
        
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
            //Error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func on_click_continue(_ sender: Any) {
        print("Continuar")
    }
    
    
    func setup_ux(){
        self.img_profile.layer.masksToBounds = true
        self.img_profile.cornerRadius = 60
        self.import_image.layer.masksToBounds = true
        self.import_image.cornerRadius = 17.5
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
    
    


}
