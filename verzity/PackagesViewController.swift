//
//  PackagesViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 03/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class PackagesViewController:BaseViewController, UITableViewDelegate, UITableViewDataSource, PayPalPaymentDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var webServiceController = WebServiceController()
    var items:NSMutableArray = []
    var selected_idPaquete = 0;
    var have_package = false

  
    // Init Paypal
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
        
    }
    
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    //End Paypal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000.0
        setup_ux()
        load_data()
        setup_paypal()
        setup_back_button()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.layoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setup_back_button(){
        let image = UIImage(named: "ic_file_download")?.withRenderingMode(.alwaysOriginal)
        
        
        let button_back = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(on_click_back))
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.setTitle("Inicio", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(on_click_back), for: .touchUpInside)

        
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(customView: button)
        
        //self.navigationItem.leftBarButtonItem = button_back
    }
    
    @objc func on_click_back(sender: AnyObject) {
        print("Atras")
        
       
        
        if !have_package {
            
            let yesAction = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                
                _ = self.navigationController?.popToRootViewController(animated: false)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginNavigationControllerID") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .default) { (action) -> Void in
            }
            
            showAlert("¿Desea cancelar la compra?", message: StringsLabel.cancel_buy, okAction: yesAction, cancelAction: cancelAction, automatic: false)
            
            
        }else{
            _ = self.navigationController?.popToRootViewController(animated: false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Navigation_MainViewController") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
      
        
    }
    
    func load_data(){
        let array_parameter = ["": ""]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetPaquetesDisponibles(parameters: parameter_json_string!, doneFunction: GetPaquetesDisponibles)
    }
    
    func GetPaquetesDisponibles(status: Int, response: AnyObject){
        var json = JSON(response)
        if status == 1{
            let list_items = json["Data"].arrayValue
            for i in 0..<list_items.count{
                var item = JSON(list_items[i])
                
                if item["idPaquete"].intValue == Defaults[.package_idPaquete]{
                    have_package = true
                    self.items.add(item)
                }
                
            }
            
            
            for i in 0..<list_items.count{
                var item = JSON(list_items[i])
                
                if item["idPaquete"].intValue != Defaults[.package_idPaquete]{
                    self.items.add(item)
                }
                
            }
            
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
        if self.items.count == 0 {
            empty_data_tableview(tableView: tableView)
            return 0
        }else{
            tableView.backgroundView = nil
            return self.items.count
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PackageTableViewCell
        
        var item = JSON(items[indexPath.section])
        
        //Evento al Boton
        cell.button_buy.addTarget(self, action: #selector(self.on_click_buy), for:.touchUpInside)
        cell.button_buy.tag = indexPath.section
        
        // Precio
        cell.price.text = "\(Double(item["dcCosto"].intValue))"
        
        cell.title_top.text = item["nbPaquete"].stringValue
        cell.vigency.text = "\(item["dcDiasVigencia"].stringValue) días de vigencia. "
        cell.description_package.text = item["desPaquete"].stringValue
        
        //cell.description_package.translatesAutoresizingMaskIntoConstraints = true
        //cell.description_package.sizeToFit()
        //cell.description_package.isScrollEnabled = false
        
        var height = cell.description_package.frame.height
        
        //cell.content_package.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:(490 + 70))

        cell.content_package.frame.size.height = 560
        
        // Swich
        cell.label_beca.text = "Aplica becas"
        cell.swich_beca.isOn = item["fgAplicaBecas"].boolValue
        
        cell.label_financing.text = "Aplica financiamiento"
        cell.swich_financing.isOn = item["fgAplicaFinanciamiento"].boolValue
        
        cell.label_postulacion.text = "Aplica postulación"
        cell.swich_postulacion.isOn = item["fgAplicaPostulacion"].boolValue
        
        print("Paq Actual: \(Defaults[.package_idPaquete])")
        print("For Paq: \(item["idPaquete"].intValue)" )
        
        if item["idPaquete"].intValue == Defaults[.package_idPaquete]{
            cell.button_buy.setTitle("PAQUETE ACTUAL", for: .normal)
            cell.button_buy.isEnabled = false
        }
        
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
    
    func setup_paypal(){
        payPalConfig.acceptCreditCards = acceptCreditCards;
        payPalConfig.merchantName = "Siva Ganesh Inc."
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.google.com")! as URL
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.google.com")! as URL
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    // PayPalPaymentDelegate
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController!, didComplete completedPayment: PayPalPayment!) {
        
        print("PayPal Payment Success !")
        paymentViewController?.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            let confirmation = completedPayment.confirmation
            let response = confirmation["response"] as AnyObject
            let state = response["state"]  as! String
            if state == "approved"{
                // Guardar el Paquete
                self.showGifIndicator(view: self.view)

                let array_parameter = [
                    "idUniversidad": Defaults[.university_idUniveridad] ,
                    "idPaquete": self.selected_idPaquete
                ]
                
                debugPrint(array_parameter)
                
                let parameter_json = JSON(array_parameter)
                let parameter_json_string = parameter_json.rawString()
                self.webServiceController.SaveVentaPaquete(parameters: parameter_json_string!, doneFunction: self.SaveVentaPaquete)
            }else{
                self.showMessage(title: "El pago fue rechazado", automatic: true)
            }

        })
    }
    
    func SaveVentaPaquete(status: Int, response: AnyObject){
         hiddenGifIndicator(view: self.view)
        var json = JSON(response)
        if status == 1{
            
            
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "DetailBuyViewControllerID") as! DetailBuyViewController
            customAlert.info = json as AnyObject
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.delegate = self
            self.present(customAlert, animated: true, completion: nil)
            
        }else{
            showMessage(title: response as! String, automatic: true)
        }
    }
    
    @objc func on_click_buy(sender: UIButton){
        let index = sender.tag
        
        let yesAction = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
            self.payment(index: index)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default) { (action) -> Void in
        }
        
        showAlert("Atención", message: "Ya cuenta con un paquete activo. ¿Desea actualizarlo?", okAction: yesAction, cancelAction: cancelAction, automatic: false)
        
    }
    
    func payment(index:Int){
        /*
         
         "idPaquete": 11,
         "cvPaquete": "CV007",
         "nbPaquete": "PAQUETE 007",
         "desPaquete": "ESTE ES UN PAQUETE DE PRUEBA",
         "dcDiasVigencia": 10,
         "fgAplicaBecas": true,
         "fgAplicaFinanciamiento": false,
         "fgAplicaPostulacion": false,
         "dcCosto": 1.0,
         "feRegistro": "2018-04-23T18:53:07.133",
         "idEstatus": 0,
         "Estatus": null,
         "VentasPaquetes": []
         */
        
        var package = JSON(self.items[index])
        
        // Process Payment once the pay button is clicked.
        self.selected_idPaquete = package["idPaquete"].intValue
        let currency_code = "MXN"
        let quantity = 1
        let product_name = package["nbPaquete"].stringValue
        let product_price = package["dcCosto"].stringValue
        let product_description_short = package["desPaquete"].stringValue
        let product_sku = "\(product_name)-\(package["cvPaquete"].stringValue)"
        
        
        // --------
        var item = PayPalItem(name: product_name, withQuantity: UInt(quantity), withPrice: NSDecimalNumber(string: product_price), withCurrency: currency_code, withSku: product_sku)
        
        let items = [item]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: currency_code, shortDescription: product_description_short, intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            print("Payment not processalbe: \(payment)")
        }
        
        
    }


}

extension PackagesViewController: DetailBuyViewControllerDelegate {
    func okButtonTapped() {
     
    }
    

}
