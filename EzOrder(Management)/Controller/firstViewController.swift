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
    
    var adArray  = [QueryDocumentSnapshot]()
    var resArray = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adtext.text = ""
        storeLabel.text = ""
        
        let db = Firestore.firestore()
        db.collection("manage").document("check").collection("AD").whereField("ADStatus", isEqualTo: 0).addSnapshotListener { (AD, error) in
            if let AD = AD{
                self.adArray = AD.documents
                self.adtext.text = "今 天 有 \(self.adArray.count) 件 廣 告 尚 未 審 核 "
                print(self.adArray.count)
            }
        }
        db.collection("manage").document("check").collection("storeconfirm").whereField("status", isEqualTo: 0).addSnapshotListener  { (store, error) in
            if let store = store{
                self.resArray = store.documents
                self.storeLabel.text = "\(self.resArray.count) 家 店 家 尚 未 審 核"
            }
        }
    }
}
