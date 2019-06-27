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
//    var performresid : String?
//    var typeID : String?
    
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
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!,
                   forRowAtIndexPath indexPath: NSIndexPath!){
        //设置cell的显示动画为3D缩放
        //xy方向缩放的初始值为0.1
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        //设置动画时间为0.25秒，xy方向缩放的最终值为1
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform=CATransform3DMakeScale(1, 1, 1)
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let prepare = segue.destination as! EditInfoViewController
        if let index = tableView.indexPathForSelectedRow{
            let documentID = adArray[index.row].documentID
            if let resID = adArray[index.row].data()["resID"] as? String{
                prepare.documentID = documentID
                prepare.resID = resID
            }
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
        
        let confirm = adArray[indexPath.row]
        let db = Firestore.firestore()
        if let resID = confirm.data()["resID"] as? String,
            let timeStamp = confirm.data()["date"] as? Timestamp {
            
            db.collection("res").document(resID).getDocument { (res, error) in
                if let resData = res?.data(){
                    if let resName = resData["resName"] as? String,
                        let resImage = resData["resImage"] as? String{
                        cell.nameLabel.text = resName
                        cell.imageVIew.kf.setImage(with: URL(string: resImage))
                        let red = CGFloat.random(in: 150...255)
                        let green = CGFloat.random(in: 150...255)
                        let blue = CGFloat.random(in: 150...255)
                        cell.fuckView.backgroundColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
                    }
                }
            }
            cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
            //设置动画时间为0.25秒，xy方向缩放的最终值为1
            UIView.animate(withDuration: 1, animations: {
                cell.layer.transform=CATransform3DMakeScale(100 , 100, 100)
            })
            cell.telLabel.text = self.format.string(from: timeStamp.dateValue())
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "performResId", sender: self)
    }
    
    
    
    
}
