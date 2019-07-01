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
        format.dateFormat = "yyyy年MM月dd日"
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
        performSegue(withIdentifier: "adDetailSegue", sender: self)
    }
}
