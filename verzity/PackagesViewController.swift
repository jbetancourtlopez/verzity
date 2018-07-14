//
//  PackagesViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 03/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import SwiftyJSON

class PackagesViewController:BaseViewController, UITableViewDelegate, UITableViewDataSource, PayPalPaymentDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var webServiceController = WebServiceController()
    var items:NSArray = []
    var selected_idPaquete = 0;

  
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
        tableView.estimatedRowHeight = 60
        
        setup_ux()
        load_data()
        setup_paypal()
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
            items = json["Data"].arrayValue as NSArray
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
        
        // Swich
        cell.label_beca.text = "Aplica becas"
        cell.swich_beca.isOn = item["fgAplicaBecas"].boolValue
        
        cell.label_financing.text = "Aplica financiamiento"
        cell.swich_financing.isOn = item["fgAplicaFinanciamiento"].boolValue
        
        cell.label_postulacion.text = "Aplica postulación"
        cell.swich_postulacion.isOn = item["fgAplicaPostulacion"].boolValue
        
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
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.sivaganesh.com/privacy.html")! as URL
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.sivaganesh.com/useragreement.html")! as URL
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
                    "idUniversidad": 4,
                    "idPaquete": self.selected_idPaquete
                ]
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
            showMessage(title: json["Mensaje"].stringValue, automatic: true)
        }else{
            showMessage(title: response as! String, automatic: true)
        }
       
    }
    
    @objc func on_click_buy(sender: UIButton){
        let index = sender.tag
        
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
