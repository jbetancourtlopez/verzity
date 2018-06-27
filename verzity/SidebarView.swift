//
//  SidebarView.swift
//  verzity
//
//  Created by Jossue Betancourt on 20/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


protocol SidebarViewDelegate: class {
    func sidebarDidSelectRow(item: AnyObject)
}

class SidebarView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    //var titleArr = [String]()

    weak var delegate: SidebarViewDelegate?
    
    var side_menu = [AnyObject]()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = Colors.white   //UIColor(red: 54/255, green: 55/255, blue: 56/255, alpha: 1.0)
        self.clipsToBounds=true
        
        side_menu = Menus.side_menu_representative as [AnyObject]
        
        setupViews()
        
        myTableView.delegate=self
        myTableView.dataSource=self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.tableFooterView=UIView()
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        myTableView.allowsSelection = true
        myTableView.bounces=false
        myTableView.showsVerticalScrollIndicator=false
        myTableView.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return side_menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.backgroundColor = Colors.green_medium //UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1.0)
           
            //Imagen Perfil
            //let cellLbl = UILabel(frame: CGRect(x: 10, y: cell.frame.height/2-15, width: 250, height: 30))
            let cellImg: UIImageView!
            cellImg = UIImageView(frame: CGRect(x: 15, y: 10, width: 100, height: 100))
            cellImg.layer.cornerRadius = 50
            cellImg.layer.masksToBounds=true
            cellImg.contentMode = .scaleAspectFill
            cellImg.layer.masksToBounds=true
            cellImg.image=#imageLiteral(resourceName: "ic_user_profile.jpg")
            cell.addSubview(cellImg)
            
            // Nombre
            let cellLbl = UILabel(frame: CGRect(x: 15, y: 115, width: 250, height: 30))
            cell.addSubview(cellLbl)
            cellLbl.text = "Nombre"//titleArr[indexPath.row]
            cellLbl.font=UIFont.systemFont(ofSize: 17)
            cellLbl.textColor=UIColor.white
            
            // Correo
            let cellLblCorreo = UILabel(frame: CGRect(x: 15, y: 145, width: 250, height: 30))
            cell.addSubview(cellLblCorreo)
            cellLblCorreo.text = "Correo"//titleArr[indexPath.row]
            cellLblCorreo.font=UIFont.systemFont(ofSize: 15)
            cellLblCorreo.textColor=UIColor.white
            
            
        } else {
            var item_menu = JSON(side_menu[indexPath.row])
            
            if indexPath.row == (side_menu.count - 1) {
                // Session
                let cell_menu_name_session = UILabel(frame: CGRect(x: 15, y: 10, width: 190, height: 30))
                cell.addSubview(cell_menu_name_session)
                cell_menu_name_session.text = "Sesión"
                cell_menu_name_session.font=UIFont.systemFont(ofSize: 16)
                cell_menu_name_session.textColor=Colors.gray
                
                //Icono
                let cellImg_sigout: UIImageView!
                cellImg_sigout = UIImageView(frame: CGRect(x: 15, y: 45, width: 20, height: 20))
                cellImg_sigout.layer.masksToBounds=true
                cellImg_sigout.contentMode = .scaleAspectFill
                cellImg_sigout.layer.masksToBounds=true
                cellImg_sigout.image = UIImage(named:  item_menu["image"].stringValue)
                cellImg_sigout.image = cellImg_sigout.image?.withRenderingMode(.alwaysTemplate)
                cellImg_sigout.tintColor = Colors.gray
                
                cell.addSubview(cellImg_sigout)
                
                // Nombre
                var cell_menu_name_sigout = UILabel(frame: CGRect(x: 60, y: 45, width: 190, height: 30))
                cell.addSubview(cell_menu_name_sigout)
                cell_menu_name_sigout.text = item_menu["name"].stringValue
                cell_menu_name_sigout.font=UIFont.systemFont(ofSize: 16)
                cell_menu_name_sigout.textColor=UIColor.black
                //cell_menu_name_sigout.font = UIFont.boldSystemFont(ofSize: 15.0)
            }
            else{
                
                //Icono
                let cellImg: UIImageView!
                cellImg = UIImageView(frame: CGRect(x: 15, y: 15, width: 20, height: 20))
                cellImg.layer.masksToBounds=true
                cellImg.contentMode = .scaleAspectFill
                cellImg.layer.masksToBounds=true
                cellImg.image = UIImage(named:  item_menu["image"].stringValue)
                cellImg.image = cellImg.image?.withRenderingMode(.alwaysTemplate)
                cellImg.tintColor = Colors.gray
                cell.addSubview(cellImg)
                
                let cell_menu_name = UILabel(frame: CGRect(x: 50, y: 10, width: 190, height: 30))
                cell.addSubview(cell_menu_name)
                cell_menu_name.text = item_menu["name"].stringValue
                cell_menu_name.font=UIFont.systemFont(ofSize: 16)
                cell_menu_name.textColor=UIColor.black
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item_menu = side_menu[indexPath.row]
        self.delegate?.sidebarDidSelectRow(item: item_menu)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 180
        } else {
            if indexPath.row == side_menu.count {
               return 90
            } else {
              return 50
            }
            
        }
    }
    
    func setupViews() {
        self.addSubview(myTableView)
        myTableView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let myTableView: UITableView = {
        let table=UITableView()
        table.translatesAutoresizingMaskIntoConstraints=false
        return table
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}