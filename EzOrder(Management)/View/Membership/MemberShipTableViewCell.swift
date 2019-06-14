//
//  MemberShipTableViewCell.swift
//  EzOrder(Management)
//
//  Created by 劉十六 on 2019/6/13.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class MemberShipTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageVIew: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var telLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
