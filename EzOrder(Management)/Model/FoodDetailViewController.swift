//
//  foodDetailssViewController.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/6/2.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Kingfisher

class FoodDetailViewController: UIViewController {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var foodDetailTextView: UITextView!
    
    var foodImage: String?
    var foodName: String?
    var foodPrice: Int?
    var foodDetail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let foodImage = foodImage,
            let foodName = foodName,
            let foodPrice = foodPrice,
            let foodDetail = foodDetail{
            
            foodImageView.kf.setImage(with: URL(string: foodImage))
            foodNameLabel.text = foodName
            foodPriceLabel.text = "$\(foodPrice)"
            foodDetailTextView.text = foodDetail
        }
    }
}

