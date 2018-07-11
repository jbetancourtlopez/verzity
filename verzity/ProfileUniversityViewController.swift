//
//  ProfileUniversityViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 09/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit

class ProfileUniversityViewController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet var import_image: UIButton!
    @IBOutlet var img_profile: UIImageView!
    @IBOutlet var button_back: UIButton!
    @IBOutlet var button_next: UIButton!
    
    var state_form = "first"
    var container : ContainerViewController!
    
    var data_form = NSMutableDictionary()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update_button()
        setup_ux()
    }
    
    // Cargar Imagen
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container"{
            self.container = segue.destination as! ContainerViewController
        }
    }
    
    @IBAction func on_click_next_save(_ sender: Any) {

        let firstVC = self.container.currentViewController as? FirstFormViewController
        let secondVC = self.container.currentViewController as? SecondFormViewController
        
        if self.state_form == "first"{
            let validate_form_first = 0 //firstVC?.validate_form()
            if  validate_form_first == 0{
                
                data_form["first_name_university"] = firstVC?.first_name_university.text
                data_form["first_name_representative"] = firstVC?.first_name_representative.text
                data_form["first_description"] = firstVC?.first_description.text
                data_form["first_web"]  = firstVC?.first_web.text
                data_form["first_phone"] = firstVC?.first_phone.text
                data_form["first_email"] = firstVC?.first_email.text
                
                container.segueIdentifierReceivedFromParent("second")
                state_form = "second"
            }
            
        }else if self.state_form == "second" {
            
            let validate_form_second = 0 //secondVC?.validate_form()
            if  validate_form_second == 0{
                
                data_form["second_cp"] = secondVC?.second_cp.text
                data_form["second_state"] = secondVC?.second_state.text
                data_form["second_municipio"] = secondVC?.second_municipio.text
                data_form["second_city"] = secondVC?.second_city.text
                data_form["second_description"] = secondVC?.second_description.text
                data_form["second_location"] = secondVC?.second_location.text
                
                save_data()
            }
        }
        update_button()
    }
    
    
    func save_data(){
        
        debugPrint(data_form)
        
        print("Guardar Datos")
        
        // Tab 1
        
        
        
        
    }
    
    
    @IBAction func on_click_back(_ sender: Any) {
        container.segueIdentifierReceivedFromParent("first")
        var controller = container.currentViewController as! FirstFormViewController
        state_form = "first"
        update_button()
    }
   
    func update_button(){
        if  self.state_form == "first" {
            button_back.isHidden = true
            button_next.setTitle("SIGUIENTE", for: .normal)
        }else if self.state_form == "second" {
            button_back.isHidden = false
            button_next.setTitle("GUARDAR CAMBIOS", for: .normal)
        }
    }
    
    func setup_ux(){
        self.img_profile.layer.masksToBounds = true
        self.img_profile.cornerRadius = 60
        self.import_image.layer.masksToBounds = true
        self.import_image.cornerRadius = 17.5
    }
}
