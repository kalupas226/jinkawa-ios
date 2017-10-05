//
//  EventDetailTableViewCell.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/14.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit

class EventDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
