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

class NotificationsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

   
    
    @IBOutlet var tableView: UITableView!
    var webServiceController = WebServiceController()
    var items: NSArray = []
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup_ux()
        
        let array_parameter = ["": ""]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetCuponesVigentes(parameters: parameter_json_string!, doneFunction: GetCardGeneral)
    }
    
    func GetCardGeneral(status: Int, response: AnyObject){
        var json = JSON(response)
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
        return 3
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
        //var item = JSON(items[indexPath.section])
     
        
        cell.image_notification.image = cell.image_notification.image?.withRenderingMode(.alwaysTemplate)
        cell.image_notification.tintColor = Colors.green_dark
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("wananananaanan" )
        /*
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
        self.show(vc, sender: nil)
         */
 
    }




}
