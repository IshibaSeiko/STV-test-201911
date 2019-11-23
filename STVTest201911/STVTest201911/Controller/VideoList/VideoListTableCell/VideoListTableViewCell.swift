//
//  MovieListTableViewCell.swift
//  STVTest201911
//
//  Created by STV-M025 on 2019/11/23.
//  Copyright © 2019 STV-M025. All rights reserved.
//

import UIKit

class VideoListTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieStatusView: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLayout(data: VideoListData) {
        thumbnailImageView.dowloadFromServer(link: data.imageUrl)
        iconImageView.dowloadFromServer(link: data.profileImageUrl)
        titleLabel.text = data.name
        movieStatusView.text = "\(data.channelName)  ・  \(data.numberOfViews)"
    }
}
