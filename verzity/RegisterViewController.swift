//
//  RegisterViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 19/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import FloatableTextField


class RegisterViewController: BaseViewController, FloatableTextFieldDelegate {
    
    @IBOutlet weak var name_university: FloatableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name_university.floatableDelegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        self.view.addGestureRecognizer(tap)
        self.navigationItem.title = "Registro"
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.navigationController?.isNavigationBarHidden = false
       let backItem = UIBarButtonItem()
       backItem.title = ""
       self.navigationController?.navigationBar.backItem?.backBarButtonItem = backItem
        
    }
    
    @objc func dismissKey() {
        self.view.endEditing(true)
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



