//
//  VideoViewController.swift
//  verzity
//
//  Created by Jossue Betancourt on 29/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SwiftyJSON
import Kingfisher

class VideoViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var webServiceController = WebServiceController()
    var list_data: AnyObject!
    var items:NSArray = []
    var idUniversidad: Int = 0
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idUniversidad = idUniversidad as Int
        
        let array_parameter = ["idUniversidad": idUniversidad]
        let parameter_json = JSON(array_parameter)
        let parameter_json_string = parameter_json.rawString()
        webServiceController.GetVideos(parameters: parameter_json_string!, doneFunction: GetVideo)

    }
    
    func GetVideo(status: Int, response: AnyObject){
        var json = JSON(response)
        debugPrint(json)
        if status == 1{
            list_data = json["Data"].arrayValue as Array as AnyObject
            items = json["Data"].arrayValue as NSArray
            tableView.reloadData()
        }
        hiddenGifIndicator(view: self.view)
    }
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var item = JSON(items[indexPath.row])
        var video = item["desRutaVideo"].stringValue
        var cell_name = ""
        if video.isEmpty {
            cell_name = "cell_youtube"
        }else{
            cell_name = "cell_player"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_name, for: indexPath) as! VideoTableViewCell
        
        if cell_name == "cell_youtube"{
            cell.viewYoutube.load(withVideoId: item["urlVideo"].stringValue)
            cell.viewYoutube.playVideo()
            
        }else{
            
            //Video de Ruta
            // https://www.youtube.com/watch?v=X3wwI1NDeKc
            //"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
            let url_string = item["desRutaVideo"].stringValue
            
            let video_url = NSURL(string: url_string)
            let avPlayer = AVPlayer(url: video_url as! URL)
            cell.playerView?.playerLayer.player = avPlayer
            cell.playerView.player?.play()
        }
       
        
        /*
        
        */
        /*
        // http://prismasoft.mx/
        // http://www.youtube.com/embed/X3wwI1NDeKc
        //http://www.youtube.com/embed/C0Z6tJdeQ_E
        let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        cell.webView.loadRequest(URLRequest(url: url!))*/
        
        //Video de Youtube
        
        
        
        
        cell.title.text = item["nbVideo"].stringValue
        cell.video_description.text = item["desVideo"].stringValue
        
        //
        cell.layer.borderWidth = 3
        cell.clipsToBounds = true
        
        return cell
        
    }
    




}

