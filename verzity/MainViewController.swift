//
//  MainViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 20/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//
import UIKit
import SwiftyJSON
import SwiftyUserDefaults


class MainViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    var sidebarView: SidebarView!
    var blackScreen: UIView!
    @IBOutlet weak var tableView: UITableView!
    var profile_menu:String = ""
    var menu_main = Menus.menu_main_academic
    weak var delegate:SidebarViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setup_ux()
        
        profile_menu = getSettings(key: "profile_menu")
        
        if profile_menu == "profile_academic" {
            menu_main = Menus.menu_main_academic  as [AnyObject] as! [[String : String]]
        }else if profile_menu == "profile_university" {
            menu_main = Menus.menu_main_university as [AnyObject] as! [[String : String]]
        }
    }

    //On_click_Side_Menu
    @IBAction func on_click_slide_menu(_ sender: Any) {
        blackScreen.isHidden=false
        UIView.animate(withDuration: 0.3, animations: {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 250, height: self.sidebarView.frame.height)
        }) { (complete) in
            self.blackScreen.frame=CGRect(x: self.sidebarView.frame.width, y: 0, width: self.view.frame.width-self.sidebarView.frame.width, height: self.view.bounds.height+100)
            self.sidebarView.myTableView.reloadData()
            
        }
    }
    
    //Table View. -------
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
        let name = menu_main[indexPath.section]["name"]
        let image = menu_main[indexPath.section]["image"]
        
        cell.name.text = name
        cell.icon.image = UIImage(named: image!)
        
        cell.icon.image = cell.icon.image?.withRenderingMode(.alwaysTemplate)
        cell.icon.tintColor = Colors.green_dark
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menu_selected = menu_main[indexPath.section]["type"]
        switch String(menu_selected!) {
        case "find_university": //Promociones
            print("find_university")
            let vc = storyboard?.instantiateViewController(withIdentifier: "FindUniversityViewControllerID") as! FindUniversityViewController
            vc.type = menu_selected!
            self.show(vc, sender: nil)
            break
        case "becas":
            print("becas")
            let vc = storyboard?.instantiateViewController(withIdentifier: "CardViewControllerID") as! CardViewController
            vc.type = menu_selected!
            self.show(vc, sender: nil)
            break
        case "financing": //comunicados
            print("financing")
            let vc = storyboard?.instantiateViewController(withIdentifier: "CardViewControllerID") as! CardViewController
            vc.type = menu_selected!
            self.show(vc, sender: nil)
            break
        case "coupons": //Eventos
            print("coupons")
            let vc = storyboard?.instantiateViewController(withIdentifier: "CardViewControllerID") as! CardViewController
            vc.type = menu_selected!
            self.show(vc, sender: nil)
            break
        case "travel": //Eventos
            print("travel")
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailMapViewControllerID") as! DetailMapViewController
            self.show(vc, sender: nil)
 
            //showMessage(title: "En proceso ...", automatic: true)
            
            break
        case "package": //Eventos
            print("package")
            let vc = storyboard?.instantiateViewController(withIdentifier: "PackagesViewControllerID") as! PackagesViewController
            self.show(vc, sender: nil)
            break
        case "postulate": //Eventos
            print("postulate")
            let vc = storyboard?.instantiateViewController(withIdentifier: "PostuladoViewControllerID") as! PostuladoViewController
            self.show(vc, sender: nil)
            break
        default:
            break
        }
    }
    
    // ---------------
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
    }
    
    func setup_ux(){
        
        self.navigationItem.backBarButtonItem?.title = ""
        
        //SideBar
        sidebarView=SidebarView(frame: CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height))
        sidebarView.delegate=self
        sidebarView.layer.zPosition=100
        self.view.isUserInteractionEnabled=true
        self.navigationController?.view.addSubview(sidebarView)
        
        blackScreen=UIView(frame: self.view.bounds)
        blackScreen.backgroundColor=UIColor(white: 0, alpha: 0.5)
        blackScreen.isHidden=true
        self.navigationController?.view.addSubview(blackScreen)
        blackScreen.layer.zPosition=99
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
    }
    
    func sigout(type: Int){
        // Borramos los datos de session
        setSettings(key: "profile_menu", value: "")
        Defaults[.type_user] = 0
        Defaults[.academic_idPersona] = 0
        Defaults[.academic_idDireccion] = 0

        Defaults[.academic_name] = ""
        Defaults[.academic_email] = ""
        Defaults[.academic_phone] = ""
        Defaults[.academic_pathFoto] = ""

        Defaults[.academic_nbPais] = ""
        Defaults[.academic_cp] = ""
        Defaults[.academic_city] = ""
        Defaults[.academic_municipio] = ""
        Defaults[.academic_state] = ""
        Defaults[.academic_description] = ""

        Defaults[.academic_dcLatitud] = ""
        Defaults[.academic_dcLongitud] = ""

        
        //Paquete
        Defaults[.package_idUniveridad] = 0
        Defaults[.package_idPaquete] = 0

        //Universidad
        Defaults[.university_idUniveridad] = 0
        Defaults[.university_pathLogo] = ""
        Defaults[.university_nbUniversidad] = ""
        Defaults[.university_nbReprecentante] = ""
        Defaults[.university_desUniversidad] = ""
        Defaults[.university_desSitioWeb] = ""
        Defaults[.university_desTelefono] = ""
        Defaults[.university_desCorreo] = ""
        Defaults[.university_idPersona] = 0

        /*
        //Persona Universidad
        Defaults[.representative_nbCompleto] = ""
        Defaults[.representative_desTelefono] = ""
        Defaults[.representative_desCorreo] = ""
        Defaults[.representative_pathFoto] = ""

        // Direccion Representante
        Defaults[.add_rep_desDireccion] = ""
        Defaults[.add_rep_numCodigoPostal] = ""
        Defaults[.add_rep_nbPais] = ""
        Defaults[.add_rep_nbEstado] = ""
        Defaults[.add_rep_nbMunicipio] = ""
        Defaults[.add_rep_nbCiudad] = ""
        Defaults[.add_rep_dcLatitud] = ""
        Defaults[.add_rep_dcLongitud] = ""
        */

        // Direccion Universidad
        
        Defaults[.add_uni_idDireccion] = 0
        Defaults[.add_uni_desDireccion] = ""
        Defaults[.add_uni_numCodigoPostal] = ""
        Defaults[.add_uni_nbPais] = ""
        Defaults[.add_uni_nbEstado] = ""
        Defaults[.add_uni_nbMunicipio] = ""
        Defaults[.add_uni_nbCiudad] = ""
        Defaults[.add_uni_dcLatitud] = 0.0
        Defaults[.add_uni_dcLongitud] = 0.0
        
        if type == 1{
            // Cambiamos de vista
            _ = self.navigationController?.popToRootViewController(animated: false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginNavigationControllerID") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = vc
        }else if type == 2{
            exit(0)
        }
        
    }
}

extension MainViewController: SidebarViewDelegate {
    
    func sidebarDidSelectRow(item: AnyObject) {
        // Oculto el Menu Side
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
        let menu_side_selected = JSON(item)
        switch String(menu_side_selected["type"].stringValue) {
            case "profile_representative": //Promociones
                print("profile_representative")
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileAcademicViewControllerID") as! ProfileAcademicViewController
                vc.type = "profile_representative"
                self.show(vc, sender: nil)
                break
            case "profile_university":
                print("profile_university")
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileUniversityViewControllerID") as! ProfileUniversityViewController
                self.show(vc, sender: nil)
                break
            case "notifications":
                print("notifications")
                let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationsViewControllerID") as! NotificationsViewController
                self.show(vc, sender: nil)
                break
            case "profile_academic":
                print("profile_academic")
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileAcademicViewControllerID") as! ProfileAcademicViewController
                vc.type = "profile_academic"
                self.show(vc, sender: nil)
                break
            case "sigout":
                print("Salir")
                sigout(type: 1)
                break
        case "sigout_academic":
                sigout(type: 2)
                break
            default:
                break
        }
        
        
        /*Gradiente
        let gl = CAGradientLayer()
        gl.colors = [Colors.green_light, Colors.green_dark]
        gl.locations = [0.0, 1.0]
        gl.frame = CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        self.sidebarView.layer.insertSublayer(gl, at: 0)
        //self.sidebarView.layer.addSublayer(gl)
         */
        
   
    }
}
