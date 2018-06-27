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
            //debugPrint(json)
            
            
            items = json["Data"].arrayValue as NSArray
            
            
            for item in items{
                
                var item_json = JSON(item)
                var catNivel = JSON(item_json["CatNivelEstudios"])
                
                let indice = validar_seccion(idCatNivelEstudios: Int64(catNivel["idCatNivelEstudios"].intValue))
                if indice >= 0 {
                    
                    
                    let item_licensature = [
                        "idLicenciatura": item_json["idLicenciatura"].intValue,
                        "nbLicenciatura": item_json["nbLicenciatura"].stringValue
                        ] as [String : Any]
                    
                    let section_aux = sections[indice] as! NSDictionary
                    print("section_aux")
                    debugPrint(section_aux)
                    var list_licensature_aux = section_aux["list_licensature"] as! [Any]
                    print("list_licensature_aux")
                    debugPrint(list_licensature_aux)
                    list_licensature_aux.append(item_licensature)  // adding(item_licensature)
                    
                    print("list_licensature_aux add")
                    debugPrint(list_licensature_aux)
                    
                    print("-------------------")
                    
                    let oldNivel:NSDictionary = [
                            "nbNivelEstudios":catNivel["nbNivelEstudios"].stringValue,
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
                                                    "idLicenciatura": item_json["idLicenciatura"].intValue,
                                                    "nbLicenciatura": item_json["nbLicenciatura"].stringValue
                                                    
                                                ]
                                            ]
                    ]
                    
                    sections.add(newNivel)

                }
                
                
                
                
                
            }
            
            debugPrint(sections)
            
            
            
            //tableView.reloadData()
        }
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
        showGifIndicator(view: self.view)
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
        let item_academics = JSON(items[indexPath.section])
        
        /*
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
         */
        
        return cell
        
    }

    


}
