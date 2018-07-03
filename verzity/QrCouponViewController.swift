//
//  QrCouponViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 02/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit

class QrCouponViewController: UIViewController {

    @IBOutlet var coupon_title: UILabel!
    @IBOutlet var coupon_validez: UILabel!
    @IBOutlet var code_coupon: UILabel!
    @IBOutlet var image_qr: UIImageView!
    
    var qrcodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generate_qr(qr:"BK002")
    }
    
    func generate_qr(qr: String){
        
        if qrcodeImage == nil {
            let data = qr.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter?.outputImage
            //image_qr.image = UIImage(ciImage: (qrcodeImage!))
            
           displayQRCodeImage()
        }else {
            image_qr.image = nil
            qrcodeImage = nil
        }
    }
    
    func displayQRCodeImage() {
        let scaleX = image_qr.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = image_qr.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        image_qr.image = UIImage(ciImage: transformedImage)
    }
    
    
   
    

  
}
