//
//  CardViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 21/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher

class CardViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var webServiceController = WebServiceController()
    var type: String = ""
    var idUniversidad = 0
    var list_data: AnyObject!
    var items:NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        type = String(type)
        idUniversidad = idUniversidad as Int
        
        load_data(type:type)
        
    }
    
    func load_data(type: String){
        showGifIndicator(view: self.view)
        
        switch String(type) {
        case "becas":
            self.title = "Becas"
            let array_parameter = ["idUniversidad": idUniversidad]
            let parameter_json = JSON(array_parameter)
            let parameter_json_string = parameter_json.rawString()
            webServiceController.GetBecasVigentes(parameters: parameter_json_string!, doneFunction: GetCardGeneral)
            break
        case "financing":
            print("financing")
            self.title = "Financiamiento"
            let array_parameter = ["idUniversidad": idUniversidad]
            let parameter_json = JSON(array_parameter)
            let parameter_json_string = parameter_json.rawString()
            webServiceController.GetFinanciamientosVigentes(parameters: parameter_json_string!, doneFunction: GetCardGeneral)
            break
        case "coupons":
            self.title = "Cupones"
            let array_parameter = ["": ""]
            let parameter_json = JSON(array_parameter)
            let parameter_json_string = parameter_json.rawString()
            webServiceController.GetCuponesVigentes(parameters: parameter_json_string!, doneFunction: GetCardGeneral)
            break
        case "travel":
            self.title = "Viajes"
            
            print("travel")
            break
        default:
            break
        }
    }
    
    func GetCardGeneral(status: Int, response: AnyObject){
        var json = JSON(response)
        if status == 1{
            list_data = json["Data"].arrayValue as Array as AnyObject
            items = json["Data"].arrayValue as NSArray
            tableView.reloadData()
        }else{
            showMessage(title: response as! String, automatic: true)
        }
        hiddenGifIndicator(view: self.view)
    }
    
    //Table View. -------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.items.count == 0 {
            empty_data_tableview(tableView: tableView)
            return 0
        }
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardTableViewCell
        var item = JSON(items[indexPath.section])
        debugPrint(item)
        var title = ""
        var name = ""
        var lblDescription = ""
        var pathImage = ""

        // Becas
        if type == "becas" {
            title = item["nbBeca"].stringValue
            name = "Autor"
            var universidad = JSON(item["Universidades"])
            lblDescription = universidad["nbUniversidad"].stringValue
            pathImage = item["pathImagen"].stringValue
            pathImage = pathImage.replacingOccurrences(of: "~", with: "")
            pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
        }
        
        // Financiamiento
        if type == "financing" {
            title = item["nbFinanciamiento"].stringValue
            name = "Autor"
            lblDescription = item["desFinancimiento"].stringValue
            pathImage = item["pathArchivo"].stringValue
            pathImage = pathImage.replacingOccurrences(of: "~", with: "")
            pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
        }
        
        //Cupones
        if type == "coupons" {
            title = item["nbCupon"].stringValue
            name = "Vencimiento"
            let feInicio = (item["feInicio"].stringValue).components(separatedBy: "T")
            let feFin = (item["feFin"].stringValue).components(separatedBy: "T")
            lblDescription = "\(feInicio[0]) - \(feFin[0])"
            
            var imagenesCupones = item["ImagenesCupones"].arrayValue
            var cuponImagen = JSON(imagenesCupones[0])
            
            pathImage = cuponImagen["desRutaFoto"].stringValue
            pathImage = pathImage.replacingOccurrences(of: "~", with: "")
            pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
        }
        
        // ------
        let url =  "\(String(describing: Config.desRutaMultimedia))\(pathImage)"
        let URL = Foundation.URL(string: url)
        let image = UIImage(named: "default.png")
        
        cell.imageBackground.kf.setImage(with: URL, placeholder: image)
        cell.title.text = title
        cell.name.text = name
        cell.lblDescription.text = lblDescription
        
        cell.btnShowMore.addTarget(self, action: #selector(self.on_click_show_more), for:.touchUpInside)
        cell.btnShowMore.tag = indexPath.section
        
        return cell
    }
    
   @objc func on_click_show_more(sender: UIButton){
        let index = sender.tag
        switch String(type) {
        case "becas":
            print("becas")
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailBecasViewControllerID") as! DetailBecasViewController
            vc.detail = items[index] as AnyObject
            self.show(vc, sender: nil)
            break
        case "financing":
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailFinanciamientoViewControllerID") as! DetailFinanciamientoViewController
            //vc.detail = items[index] as AnyObject
            self.show(vc, sender: nil)
            
            break
        case "coupons":
            print("coupons")
            let vc = storyboard?.instantiateViewController(withIdentifier: "QrCouponViewControllerID") as! QrCouponViewController
            var item = JSON(items[index])
            vc.idCupon = item["idCupon"].intValue
            self.show(vc, sender: nil)
            break
        default:
            break
        }
    }

}
