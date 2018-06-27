//
//  ListUniversitiesViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 26/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class ListUniversitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var webServiceController = WebServiceController()  //WebServiceController()
    var type: String = ""
    var items:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        type = String(type)
        
        // Cargamos las Universidades
        let array_parameter = ["": ""]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.BusquedaUniversidades(parameters: parameter_json_string!, doneFunction: GetListGeneral)
        
        self.navigationItem.backBarButtonItem?.title = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = "Universidades"
    }
    
    func GetListGeneral(status: Int, response: AnyObject){
        var json = JSON(response)
        
        if status == 1{
            items = json["Data"].arrayValue as NSArray
            //hiddenGifIndicator(view: self.view)
            tableView.reloadData()
        }else{
            //hiddenGifIndicator(view: self.view)
            
            /*
             let okAction = UIAlertAction(title: "reintentar", style: .cancel) { _ -> Void in
             self.usuarioController.getClubs(doneFunction: self.getClubs)
             self.showAlert_Indicator("", message: "Obteniendo clubs...\n\n\n")
             }
             self.showAlert("Error", message: response as! String, okAction: okAction, cancelAction: nil, automatic: false)
             */
        }
        
    }
    
    //Table View. -------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        var item_university = JSON(items[indexPath.section])
        
        //Nombre
        cell.name.text  = item_university["nbUniversidad"].stringValue
        // Imagen
        var pathImage = item_university["pathLogo"].stringValue
        pathImage = pathImage.replacingOccurrences(of: "~", with: "")
        pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
        let url =  "\(String(describing: Config.desRutaMultimedia))\(pathImage)"
        let URL = Foundation.URL(string: url)
        let image_default = UIImage(named: "default.png")
        cell.icon.kf.setImage(with: URL, placeholder: image_default)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let university = items[indexPath.section]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailUniversityViewControllerID") as! DetailUniversityViewController
        vc.university = university as AnyObject
        self.show(vc, sender: nil)
    }
    


}
