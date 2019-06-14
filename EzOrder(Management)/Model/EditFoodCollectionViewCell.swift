//
//  muneCollectionViewCell.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/6/2.
//  Copyright © 2019 TerryLee. All rights reserved.
//
import UIKit

class EditFoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodMoneyLabel: UILabel!
    
    @IBOutlet weak var editNameTextfield: UITextField!
    @IBOutlet weak var editMoneyTextfield: UITextField!
    @IBOutlet weak var statusSwich: UISwitch!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBAction func statusAction(_ sender:UISwitch) {
        if sender.isOn {
            menuView.alpha = 1
            
            
        }
        else {
            menuView.alpha = 0.4
            foodNameLabel.text = ""
        }
    }
}

