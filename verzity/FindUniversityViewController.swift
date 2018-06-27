//
//  FindUniversityViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 26/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class FindUniversityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet var page_control: UIPageControl!
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
     var webServiceController = WebServiceController()
    let menu_main = Menus.menu_find_university
    var type: String = ""
    var list_data: AnyObject!
    var items:NSArray = []
    
    var timer: Timer!
    var updateCounter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Buscar universidades"
        updateCounter = 1
        self.navigationItem.backBarButtonItem?.title = ""
        
        // Cargamos los Banners
       
        let array_parameter = ["": ""]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetBannersVigentes(parameters: parameter_json_string!, doneFunction: getBanners)
        
        //Evento a la imagen del Banner
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        debugPrint(items[updateCounter - 1])
        
        // Your action
    }
    
    func getBanners(status: Int, response: AnyObject){
        var json = JSON(response)
        if status == 1{
            list_data = json["Data"].arrayValue as Array as AnyObject
            items = json["Data"].arrayValue as NSArray
            //hiddenGifIndicator(view: self.view)
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(FindUniversityViewController.updateTimer), userInfo: nil, repeats: true)
        }else{
            // Mensaje de Error
        }
    }
    
    @objc internal func updateTimer(){
        if (updateCounter <= (items.count - 1)){
            page_control.currentPage = updateCounter
            
            let banner_data = items[updateCounter]
            var banner = JSON(banner_data)
            
            var pathImage = banner["desRutaFoto"].stringValue
            pathImage = pathImage.replacingOccurrences(of: "~", with: "")
            pathImage = pathImage.replacingOccurrences(of: "\\", with: "")
            
            let url =  "\(String(describing: Config.desRutaMultimedia))\(pathImage)"
            let URL = Foundation.URL(string: url)
            let image_default = UIImage(named: "default.png")
            
            image?.kf.setImage(with: URL, placeholder: image_default)
            
            updateCounter = updateCounter + 1
        }else{
            updateCounter = 0;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem?.title = ""
    }
    
    //Table View. -------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.menu_main.count
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
        
        var menu_item = JSON(menu_main[indexPath.section])
        let name = menu_item["name"].stringValue
        let icon = UIImage(named: menu_item["image"].stringValue)
        
        cell.icon.image = icon
        cell.name.text = name
        cell.icon.image = cell.icon.image?.withRenderingMode(.alwaysTemplate)
        cell.icon.tintColor = Colors.green_dark
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menu_selected = menu_main[indexPath.section]["type"]
        
        switch String(menu_selected!) {
        case "find_university": //Promociones
            print("find_university")
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "ListUniversitiesViewControllerID") as! ListUniversitiesViewController
            vc.type = menu_selected!
            self.show(vc, sender: nil)
         
            break
        case "find_academics":
            print("find_academics")
            break
        case "find_next_to_me": //comunicados
            print("find_next_to_me")

            break
        case "find_euu": //Eventos
            print("find_euu")
            let vc = storyboard?.instantiateViewController(withIdentifier: "FindMapViewControllerID") as! FindMapViewController
            vc.type = menu_selected!
            self.show(vc, sender: nil)
            break
        case "find_favorit": //Eventos
            print("find_favorit")
            break
        default:
            break
        }
    }
    

}
