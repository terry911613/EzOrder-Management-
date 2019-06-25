//
//  firstViewController.swift
//  EzOrder(Management)
//
//  Created by 劉十六 on 2019/6/25.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
class firstViewController: UIViewController {
    @IBOutlet weak var adtext: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    var adCoumt  = [QueryDocumentSnapshot]()
    var storeCount = [QueryDocumentSnapshot]()
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
    }
        

        

    
    
    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        db.collection("manage").document("check").collection("AD").whereField("ADStatus", isEqualTo: 0).addSnapshotListener { (AD, error) in
            if let AD = AD{
                self.adCoumt = AD.documents
                UIView.animate(withDuration: 0.2, delay:1 , animations: {
                    self.adtext.alpha = 1
                    self.adtext.text = "以 及 \(self.adCoumt.count) 件 廣 告 審 核 請 問\n要 先 做 什 麼 呢 ?"
                })
                print(self.adCoumt.count)
            }
        }
        db.collection("manage").document("check").collection("storeconfirm").whereField("status", isEqualTo: 0).addSnapshotListener  { (store, error) in
            if let store = store{
                self.storeCount = store.documents
                print(self.storeCount.count)
                UIView.animate(withDuration: 0.2, delay:1 , animations: {
                    self.storeLabel.alpha = 1
                    self.storeLabel.text = "今 天 有 \(self.storeCount.count) 家 店 家 尚 未 審 核"
                })
                
            }
        }
       
        
    }
}
