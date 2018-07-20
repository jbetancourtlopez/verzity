//
//  NotificationsAcademicViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 02/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SwiftyUserDefaults

class NotificationsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

   
    
    @IBOutlet var tableView: UITableView!
    var webServiceController = WebServiceController()
    var items: NSArray = []
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup_ux()
        
         let array_parameter = [
         "desCorreo": Defaults[.academic_email],
         "idPersona": Defaults[.academic_idPersona],
         "idDireccion": Defaults[.academic_idDireccion],
         "nbCompleto": Defaults[.academic_name] ,
         "desTelefono": Defaults[.academic_phone]
         ] as [String : Any]
 
        
        
        let array_parameter_test = [
            "desCorreo": "marco.yam.catina@gmail.com",
            "idPersona": 86,
            "idDireccion": 75,
            "nbCompleto": "Marco Yam Cetina",
            "desTelefono": "9971419990"
            ] as [String : Any]
        
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.ConsultarNotificaciones(parameters: parameter_json_string!, doneFunction: ConsultarNotificaciones)
    }
    
    func ConsultarNotificaciones(status: Int, response: AnyObject){
        var json = JSON(response)
        print(json)
        if status == 1{
            items = json["Data"].arrayValue as NSArray
            tableView.reloadData()
        }
        hiddenGifIndicator(view: self.view)
    }
    
    func setup_ux(){
        showGifIndicator(view: self.view)
    }
    
    //Table View. -------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.items.count == 0 {
            empty_data_tableview(tableView: tableView)
            return 0
        }else{
            tableView.backgroundView = nil
            return  self.items.count
        }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationsTableViewCell
        var item = JSON(items[indexPath.section])
        
        var notificacionEstatusList = JSON(item["NotificacionEstatus"])
        var notificacionEstatus = JSON(notificacionEstatusList[0])
        var status = JSON(notificacionEstatus["Estatus"])
        
        var feRegistro = item["feRegistro"].stringValue
        var feRegistro_array = feRegistro.components(separatedBy: "T")
        
        var hourRegistro = feRegistro_array[1]
        var hourRegistro_array = hourRegistro.components(separatedBy: ".")
        hourRegistro = hourRegistro_array[0]
        
        let date = get_date(date_string: feRegistro_array[0])
        cell.title_notification.text = item["desAsunto"].stringValue + " " + date + " " + hourRegistro
        
        if status["desEstatus"].stringValue == "PENDIENTE"{
            cell.title_notification.font = UIFont.boldSystemFont(ofSize: 14.0)
            cell.image_notification.image = UIImage(named: "ic_notification_green")
        }
        
        cell.description_notificaction.text = item["desMensaje"].stringValue
        
        
        
        //Icono
        cell.image_notification.image = cell.image_notification.image?.withRenderingMode(.alwaysTemplate)
        cell.image_notification.tintColor = Colors.green_dark
 
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var item = JSON(items[indexPath.section])
        let idNotificacion = item["idNotificacion"].intValue
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
        vc.idNotificacion = idNotificacion
        vc.type = "notificacion"
        self.show(vc, sender: nil)
 
 
    }




}
