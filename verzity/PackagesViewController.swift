//
//  PackagesViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 03/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON

class PackagesViewController:BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var webServiceController = WebServiceController()
    var items:NSArray = []
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 60
        setup_ux()
        load_data()
    }
    
    func load_data(){
        let array_parameter = ["idUniversidad": 4]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetPostulados(parameters: parameter_json_string!, doneFunction: GetList)
    }
    
    func GetList(status: Int, response: AnyObject){
        var json = JSON(response)
        if status == 1{
        
        }
        tableView.reloadData()
        hiddenGifIndicator(view: self.view)
    }
    
    func setup_ux(){
        self.navigationItem.leftBarButtonItem?.title = ""
        showGifIndicator(view: self.view)
    }
    
    //Table View. -------------------
    func numberOfSections(in tableView: UITableView) -> Int {
       
        /*if self.items.count == 0 {
            empty_data_tableview(tableView: tableView)
            return 0
        }*/
        
        return 3//self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PackageTableViewCell
        
        
        //Evento al Boton
        cell.button_buy.addTarget(self, action: #selector(self.on_click_buy), for:.touchUpInside)
        cell.button_buy.tag = indexPath.section
        
        // setup_ux
        cell.clipsToBounds = true
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 2
        cell.layer.borderWidth = 4
        cell.layer.shadowOffset = CGSize(width:1, height:-20)
        let borderColor: UIColor = Colors.green_dark
        cell.layer.borderColor = borderColor.cgColor
        
        return cell
    }
    
    @objc func on_click_buy(sender: UIButton){
        let index = sender.tag
        print("Pagar \(index)")
    }


}
