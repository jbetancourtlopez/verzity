//
//  ListAcademicsViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 27/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class ListAcademicsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var webServiceController = WebServiceController()
    var items:NSArray = []
    var sections: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setup_ux()
        load_data()
    }
    
    func load_data(){
        let array_parameter = ["": ""]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetProgramasAcademicos(parameters: parameter_json_string!, doneFunction: GetList)
    }
    
    func GetList(status: Int, response: AnyObject){
        var json = JSON(response)
        if status == 1{
            items = json["Data"].arrayValue as NSArray
            for item in items{
                
                var item_json = JSON(item)
                var catNivel = JSON(item_json["CatNivelEstudios"])
                
                let indice = validar_seccion(idCatNivelEstudios: Int64(catNivel["idCatNivelEstudios"].intValue))
                if indice >= 0 {
                    let item_licensature_all = [
                        "idLicenciatura": 0,
                        "nbLicenciatura": "Todos"
                        ] as [String : Any]
 
                    let item_licensature = [
                        "idLicenciatura": item_json["idLicenciatura"].intValue,
                        "nbLicenciatura": item_json["nbLicenciatura"].stringValue
                        ] as [String : Any]
                    
                    let section_aux = sections[indice] as! NSDictionary
                    var list_licensature_aux = section_aux["list_licensature"] as! [Any]
                    /*if  list_licensature_aux.count > 1{
                        list_licensature_aux.append(item_licensature_all)
                    }else{
                        
                    }*/
                    list_licensature_aux.append(item_licensature)  // adding(item_licensature)
                    
                    let oldNivel:NSDictionary = [
                            "nbNivelEstudios": "\(catNivel["nbNivelEstudios"].stringValue)",
                            "idCatNivelEstudios":catNivel["idCatNivelEstudios"].intValue,
                            "list_licensature": list_licensature_aux
                        ]
                    sections[indice] = oldNivel
                    
                    
                }else{
                    let newNivel:NSDictionary = [
                        "nbNivelEstudios":catNivel["nbNivelEstudios"].stringValue,
                        "idCatNivelEstudios":catNivel["idCatNivelEstudios"].intValue,
                        "list_licensature": [
                                                [
                                                    "idLicenciatura": 0,
                                                    "nbLicenciatura": "Todos"
                                                ],
                                                [
                                                    "idLicenciatura": item_json["idLicenciatura"].intValue,
                                                    "nbLicenciatura": item_json["nbLicenciatura"].stringValue
                                                    
                                                ]
                                            ]
                    ]
                    sections.add(newNivel)
                }
            }
            
        }
        debugPrint(sections)
        tableView.reloadData()
        hiddenGifIndicator(view: self.view)
        
    }
    
    func  validar_seccion( idCatNivelEstudios: Int64) -> Int{
        var seccion_indice : Int = 0
        for section in sections{
            var aux_section = JSON(section)
            if aux_section["idCatNivelEstudios"].intValue == idCatNivelEstudios{
                return seccion_indice
            }
            seccion_indice += 1;
        }
        return -1
    }
    
    func setup_ux(){
        self.navigationItem.leftBarButtonItem?.title = ""
        //showGifIndicator(view: self.view)
    }
    
    //Table View. -------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        print("Count Sections: \(self.sections.count)")
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section_item = JSON(sections[section])
        let count = section_item["list_licensature"].count
        print("Count Rows in Section: \(count)")
        return count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section_item = JSON(sections[section])
        let title = section_item["nbNivelEstudios"].stringValue
        print("Title: \(title)")
        return  "Seccion \(title)"
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
        
        
        let section_item = JSON(sections[section])
        let title = section_item["nbNivelEstudios"].stringValue
        print("Title: \(title)")
        
        header.title.text = title
        header.backgroundColor = Colors.green_dark
        return header
    }
    
    // Set the spacing between sections
    
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 5.0
    }*/

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AcademicsTableViewCell
        let section_item = JSON(sections[indexPath.section])
        let rows = section_item["list_licensature"].arrayValue
        let row = JSON(rows[indexPath.row])

        cell.name.text = row["nbLicenciatura"].stringValue
        
        //
        cell.layer.borderWidth = 3
        cell.clipsToBounds = true
        
        return cell
        
    }

    


}
