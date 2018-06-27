//
//  BaseViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 18/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SystemConfiguration

class BaseViewController: UIViewController {
    var alert = UIAlertController()
    var alert_indicator = UIAlertController()
    var activeField: UITextField?
    var scrollView_: UIScrollView?
    var indicator : UIActivityIndicatorView!
    var viewLoading : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Abrir el navegador
    func openUrl(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            //print("Open \(scheme): \(success)")
                })
            } else {
                //let success = UIApplication.shared.openURL(url)
                //print("Open \(scheme): \(success)")
            }
        }
    }
    
    //Tabla Vacia
    func empty_data_tableview(tableView: UITableView, string: String? = "Ups! No encontramos elementos."){
        let view: UIView     = UIView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        let title: UILabel     = UILabel(frame: CGRect(x: 0, y:(tableView.frame.size.height/2), width: self.view.frame.width, height: 21))
        let noDataLabel: UIImageView     = UIImageView(frame: CGRect(x: (self.view.frame.width/2) - 30, y: (tableView.frame.height/2) - 65, width: 60, height: 60))
        title.text             = string
        title.textColor        = Colors.green_dark
        title.textAlignment    = .center
        noDataLabel.image = UIImage(named: "ic_action_pais")
        view.addSubview(title)
        //view.addSubview(noDataLabel)
        view.backgroundColor = Colors.black
        tableView.backgroundView = view
        tableView.backgroundView?.isHidden = false
        tableView.separatorStyle = .none
    }
    
    //Mensaje
    func showMessage(title:String)->Void{
        let alertView:UIAlertView = UIAlertView()
        alertView.title = title
        //alertView.delegate = self
        alertView.addButton(withTitle: "OK")
        alertView.show()
    }
    
    // Alerts
    func showAlert(_ title: String, message: String, okAction: UIAlertAction?, cancelAction: UIAlertAction?, automatic: Bool){
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        if  okAction != nil{
            alert.addAction(okAction!)
        }
        if cancelAction != nil{
            alert.addAction(cancelAction!)
        }
        self.present(alert, animated: true, completion: nil)
        if automatic == true{
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(BaseViewController.dismissAlert), userInfo: nil, repeats: false)
        }
    }
    
    func updateAlert(title: String, message: String, automatic: Bool){
        alert.title = title
        alert.message = message
        if automatic{
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(BaseViewController.dismissAlert), userInfo: nil, repeats: false)
        }
    }
    
    @objc func dismissAlert(){
        alert.dismiss(animated: true, completion: nil)
    }
    
    func showAlert_Indicator(_ title : String, message: String){
        alert_indicator = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: alert_indicator.view.bounds)
        indicator.center = CGPoint(x: 130.5, y: 65.5)
        indicator.color = Colors.green_dark
        alert_indicator.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        self.present(alert_indicator, animated: true, completion: nil)
    }
    
    func showIndicator(view: UIView){
        let navigationHeigth = (self.navigationController?.navigationBar.frame.size.height)! + 20
        indicator = UIActivityIndicatorView(frame: CGRect(x: (self.view.frame.width/2) - 25, y: (self.view.frame.height/2) - navigationHeigth, width: 50.0, height: 50.0))
        indicator.color = Colors.green_dark
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        view.addSubview(indicator)
        view.isUserInteractionEnabled = false
    }
    
    func hiddenIndicator(view: UIView){
        indicator.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    
    
    //Gif Loading
    func showGifIndicator(view: UIView){
        viewLoading = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        viewLoading.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "loading_data", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        let imageLoading = UIImageView(image: advTimeGif)
        
        imageLoading.frame = CGRect(x: (viewLoading.frame.size.width/2) - 100, y: (viewLoading.frame.height/2)-100, width: 200, height: 200)
        imageLoading.backgroundColor = Colors.green_dark
        imageLoading.layer.cornerRadius = 8.0
        imageLoading.contentMode = .scaleAspectFit
        viewLoading.addSubview(imageLoading)
        view.addSubview(viewLoading)
    }
    
    func hiddenGifIndicator(view: UIView){
        if viewLoading != nil{
            viewLoading.removeFromSuperview()
            viewLoading = nil
        }
    }
    
}
