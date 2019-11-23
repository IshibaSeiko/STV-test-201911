//
//  ChannelListTableViewCell.swift
//  STVTest201911
//
//  Created by STV-M025 on 2019/11/23.
//  Copyright © 2019 STV-M025. All rights reserved.
//

import UIKit

class ChannelListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setLayout(data: ChannelListData) {
        thumbnailImageView.dowloadFromServer(link: data.imageUrl)
        channelNameLabel.text = data.name
        durationLabel.text = data.duration
    }
    
}
