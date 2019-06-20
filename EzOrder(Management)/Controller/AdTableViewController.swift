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
    
    @IBAction func disMissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

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
        
        let db = Firestore.firestore()
        db.collection("manage").document("check").collection("AD").whereField("ADStatus", isEqualTo: 0).order(by: "date", descending: false).getDocuments { (AD, error) in
            if let AD = AD{
                if AD.documents.isEmpty == false{
                    if let resID = AD.documents[indexPath.row].data()["resID"] as? String,
                        let timeStamp = AD.documents[indexPath.row].data()["date"] as? Timestamp{
                        print(resID)
                        
                        
                        db.collection("res").document(resID).getDocument { (res, error) in
                            if let resData = res?.data(){
                                if let resName = resData["resName"] as? String,
                                    let resImage = resData["resImage"] as? String{
                                    cell.RestaurantNameLabel.text = resName
                                    cell.resImageView.kf.setImage(with: URL(string: resImage))
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
                        cell.dateLabel.text = self.format.string(from: timeStamp.dateValue())
                    }
                }
            }
        }
        
        // cell.RestaurantNameLabel.text = Ads[indexPath.row]
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let AD = adArray[indexPath.row]
        selectAd = AD
        print(AD)
        performSegue(withIdentifier: "adDetailSegue", sender: self)
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
