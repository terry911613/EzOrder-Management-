//
//  MemberShipTableViewController.swift
//  EzOrder(Management)
//
//  Created by Lee Chien Kuan on 2019/6/6.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ViewAnimator

class MemberShipTableViewController: UITableViewController {
    var adArray = [QueryDocumentSnapshot]()
    let format = DateFormatter()
    var performresid : String?
    var typeID : String?
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        print(adArray.count)
        let db = Firestore.firestore()
        db.collection("manage").document("check").collection("storeconfirm").whereField("status", isEqualTo: 0).addSnapshotListener  { (store, error) in
            if let store = store{
                if store.documents.isEmpty{
                    self.adArray.removeAll()
                    self.tableView.reloadData()
                }
                else{
                    print("dsfdsf")
                    self.adArray = store.documents
                    self.animateTableView()
                }
            }
        }
        format.locale = Locale(identifier: "zh_TW")
        format.dateFormat = "yyyy年MM月dd日 a hh:mm"
        super.viewDidLoad()
    }
    func animateTableView(){
        let animations = [AnimationType.from(direction: .top, offset: 30.0)]
        tableView.reloadData()
        UIView.animate(views: tableView.visibleCells, animations: animations, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let prepare = segue.destination as! EditInfoViewController
        if let performresid = performresid {
            prepare.documentID = typeID
            prepare.resIDdocument = performresid
        }
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantsCell", for: indexPath) as! MemberShipTableViewCell
        let db = Firestore.firestore()
        db.collection("manage").document("check").collection("storeconfirm").whereField("status", isEqualTo: 0).getDocuments { (store, error) in
            if let store = store{
                if store.documents.isEmpty == false{
                    if let resID = store.documents[indexPath.row].data()["resID"] as? String,let timeStamp = store.documents[indexPath.row].data()["date"] as? Timestamp {
                        db.collection("res").document(resID).getDocument { (res, error) in
                            if let resData = res?.data(){
                                if let resName = resData["resName"] as? String,
                                    let resImage = resData["resImage"] as? String{
                                    cell.nameLabel.text = resName
                                    cell.imageVIew.kf.setImage(with: URL(string: resImage))
                                    if indexPath.row == 0 {
                                        cell.fuckView.backgroundColor = .init(red: 100/255, green: 161/266, blue: 221/255, alpha: 1)
                                    }
                                    if indexPath.row == 1 {
                                        cell.fuckView.backgroundColor = .init(red: 229/255, green: 166/266, blue: 105/255, alpha: 1)
                                    }
                                    if indexPath.row == 2 {
                                        cell.fuckView.backgroundColor = .init(red: 218/255, green: 100/266, blue: 122/255, alpha: 1)

                                    }
                                    if indexPath.row == 3 {
                                        cell.fuckView.backgroundColor = .init(red: 152/255, green: 127/266, blue: 237/255, alpha: 1)

                                    }
                                    if indexPath.row == 4 {
                                        cell.fuckView.backgroundColor = .init(red: 57/255, green: 221/266, blue: 150/255, alpha: 1)

                                    }
                                    if indexPath.row == 5 {
                                        cell.fuckView.backgroundColor = .init(red: 100/255, green: 161/266, blue: 221/255, alpha: 1)

                                    }
                                    if indexPath.row == 6 {
                                        cell.fuckView.backgroundColor = .init(red: 229/255, green: 166/266, blue: 105/255, alpha: 1)

                                    }
                                    
                                }
                            }
                        }
                        cell.telLabel.text = self.format.string(from: timeStamp.dateValue())
                    }
                }
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let AD = adArray[indexPath.row]
        let typeAD = adArray[indexPath.row].documentID
        self.typeID = typeAD
        if let resID = AD.data()["resID"] as? String{
            self.performresid = resID
            
        }
        performSegue(withIdentifier: "performResId", sender: self)
        
    }
    
    
    
    
    
}
