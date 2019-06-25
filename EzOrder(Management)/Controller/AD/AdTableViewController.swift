//
//  AdTableViewController.swift
//  EzOrder(Management)
//
//  Created by Lee Chien Kuan on 2019/6/6.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ViewAnimator


class AdTableViewController: UITableViewController {
    
    var adArray = [QueryDocumentSnapshot]()
    
    let format = DateFormatter()
    var selectAd: QueryDocumentSnapshot?
    var Ads = ["Ad1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        db.collection("manage").document("check").collection("AD").whereField("ADStatus", isEqualTo: 0).order(by: "date", descending: false).addSnapshotListener { (AD, error) in
            if let AD = AD{
                if AD.documents.isEmpty{
                    self.adArray.removeAll()
                    self.tableView.reloadData()
                }
                else{
                    self.adArray = AD.documents
                    self.animateTableView()
                }
            }
        }
        format.locale = Locale(identifier: "zh_TW")
        format.dateFormat = "yyyy年MM月dd日 a hh:mm"
    }
    func animateTableView(){
        let animations = [AnimationType.from(direction: .top, offset: 30.0)]
        tableView.reloadData()
        UIView.animate(views: tableView.visibleCells, animations: animations, completion: nil)
    }
    
    @IBAction func disMissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let adDetailVC = segue.destination as! AdDetailViewController
        if let selectAd = selectAd{
            adDetailVC.ad = selectAd
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return adArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as! AdTableViewCell
        
        let AD = adArray[indexPath.row]
        if let resID = AD.data()["resID"] as? String,
            let timeStamp = AD.data()["date"] as? Timestamp{
            
            let db = Firestore.firestore()
            db.collection("res").document(resID).getDocument { (res, error) in
                if let resData = res?.data(){
                    if let resName = resData["resName"] as? String,
                        let resImage = resData["resImage"] as? String{
                        cell.RestaurantNameLabel.text = resName
                        cell.resImageView.kf.setImage(with: URL(string: resImage))
                        let red = CGFloat.random(in: 150...255)
                        let green = CGFloat.random(in: 150...255)
                        let blue = CGFloat.random(in: 150...255)
                        cell.fuckView.backgroundColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
                        
//                        if indexPath.row == 0 {
//                            cell.fuckView.backgroundColor = .init(red: 100/255, green: 161/266, blue: 221/255, alpha: 1)
//                        }
//                        if indexPath.row == 1 {
//                            cell.fuckView.backgroundColor = .init(red: 229/255, green: 166/266, blue: 105/255, alpha: 1)
//                        }
//                        if indexPath.row == 2 {
//                            cell.fuckView.backgroundColor = .init(red: 218/255, green: 100/266, blue: 122/255, alpha: 1)
//                        }
//                        if indexPath.row == 3 {
//                            cell.fuckView.backgroundColor = .init(red: 152/255, green: 127/266, blue: 237/255, alpha: 1)
//                        }
//                        if indexPath.row == 4 {
//                            cell.fuckView.backgroundColor = .init(red: 57/255, green: 221/266, blue: 150/255, alpha: 1)
//                        }
//                        if indexPath.row == 5 {
//                            cell.fuckView.backgroundColor = .init(red: 100/255, green: 161/266, blue: 221/255, alpha: 1)
//                        }
//                        if indexPath.row == 6 {
//                            cell.fuckView.backgroundColor = .init(red: 229/255, green: 166/266, blue: 105/255, alpha: 1)
//                        }
                    }
                }
            }
            cell.dateLabel.text = self.format.string(from: timeStamp.dateValue())
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let AD = adArray[indexPath.row]
        selectAd = AD
        print(AD)
        performSegue(withIdentifier: "adDetailSegue", sender: self)
    }
}
