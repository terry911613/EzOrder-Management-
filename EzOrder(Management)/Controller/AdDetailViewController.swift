//
//  AdDetailViewController.swift
//  EzOrder(Management)
//
//  Created by 李泰儀 on 2019/6/11.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class AdDetailViewController: UIViewController {
    
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    let format = DateFormatter()
    var ad: QueryDocumentSnapshot?
    var documentID: String?
    var resID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        format.locale = Locale(identifier: "zh_TW")
        format.dateFormat = "yyyy年MM月dd日 a hh:mm"
        
        if let adData = ad?.data(){
            if let startTimeStamp = adData["startDate"] as? Timestamp,
                let endTimeStamp = adData["endDate"] as? Timestamp,
                let ADImage = adData["ADImage"] as? String,
                let documentID = adData["documentID"] as? String,
                let resID = adData["resID"] as? String{
                
                adImageView.kf.setImage(with: URL(string: ADImage))
                
                startDateLabel.text = "開始時間：\(format.string(from: startTimeStamp.dateValue()))"
                endDateLabel.text = "結束時間：\(format.string(from: endTimeStamp.dateValue()))"
                
                self.documentID = documentID
                self.resID = resID
            }
        }
    }
    
    @IBAction func denyButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "確定退回?", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default) { (ok) in
            print(123123123)
            let db = Firestore.firestore()
            if let documentID = self.documentID,
                let resID = self.resID{
                print(555)
                db.collection("manage").document("check").collection("AD").document(documentID).updateData(["ADStatus": 2])
                db.collection("res").document(resID).collection("AD").document(documentID).updateData(["ADStatus": 2])
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "確定申請通過?", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default) { (ok) in
            print(21213)
            
            let db = Firestore.firestore()
            print(self.documentID)
            print(self.resID)
            if let documentID = self.documentID,
                let resID = self.resID{
                print(12)
                db.collection("manage").document("check").collection("AD").document(documentID).updateData(["ADStatus": 1])
                db.collection("res").document(resID).collection("AD").document(documentID).updateData(["ADStatus": 1])
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
