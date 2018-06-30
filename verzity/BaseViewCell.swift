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

class HeaderTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
}


class VideoTableViewCell: UITableViewCell{

    @IBOutlet var title: UILabel!
    @IBOutlet var playerView: PlayerViewClass!
    @IBOutlet var video_description: UITextView!
    
    @IBOutlet var webView: UIWebView!
    
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
