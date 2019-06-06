//
//  AdTableViewCell.swift
//  EzOrder(Management)
//
//  Created by Lee Chien Kuan on 2019/6/6.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class AdTableViewCell: UITableViewCell {

    @IBOutlet weak var AdImg: UIImageView!
    @IBOutlet weak var RestaurantNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
