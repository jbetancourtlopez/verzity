//
//  BaseViewCell.swift
//  verzity
//
//  Created by Jossue Betancourt on 21/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell{
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class AcademicsTableViewCell: UITableViewCell{
 
    @IBOutlet var name: UILabel!
    @IBOutlet var swich_item: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class NotificationsTableViewCell: UITableViewCell{
    
    @IBOutlet var image_notification: UIImageView!
    @IBOutlet var title_notification: UITextView!
    @IBOutlet var description_notificaction: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class PostuladosTableViewCell: UITableViewCell{
    

    @IBOutlet var postulate_name_academic: UILabel!
    @IBOutlet var postulate_date: UILabel!
    @IBOutlet var postulate_day: UILabel!
    @IBOutlet var postulate_university: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


class HeaderTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
}

class PackageTableViewCell: UITableViewCell {

    @IBOutlet var title_top: UILabel!
    
    @IBOutlet var label_financing: UILabel!
    @IBOutlet var price: UILabel!
    
    @IBOutlet var swich_beca: UISwitch!
    @IBOutlet var swich_financing: UISwitch!
    @IBOutlet var description_package: UILabel!
    @IBOutlet var label_postulacion: UILabel!
    @IBOutlet var swich_postulacion: UISwitch!
    @IBOutlet var button_buy: UIButton!
    @IBOutlet var label_beca: UILabel!
    @IBOutlet var vigency: UILabel!
}



class VideoTableViewCell: UITableViewCell{

    @IBOutlet var title: UILabel!
    @IBOutlet var video_description: UITextView!
    @IBOutlet var viewYoutube: YTPlayerView!
    
    @IBOutlet var playerView: PlayerViewClass!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class CardTableViewCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var btnShowMore: UIButton!
    @IBOutlet weak var imageBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
