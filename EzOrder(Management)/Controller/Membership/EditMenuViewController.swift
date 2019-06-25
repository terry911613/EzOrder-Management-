//
//  EditMenuViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/7.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ViewAnimator

class EditMenuViewController: UIViewController {
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet var foodCollections: [UICollectionView]!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet var optinss: [UIButton]!
    var editState = false
    var p: CGPoint?
    var isEditPressed = false
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    var typeArray = [QueryDocumentSnapshot]()
    var foodArray = [QueryDocumentSnapshot]()
    var typeIndex: Int?
    var foodIndex: Int?
    var selectIndex: IndexPath?
    var prepare = false
    var prepares : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for optinasss in foodCollections {
            UIView.animate(withDuration: 0.8, animations: {optinasss.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
        print("??????????????????????????????????????")
        getType()
        if typeArray.isEmpty == false, let typeIndex = typeIndex{
            if let type = typeArray[typeIndex].data()["typeDocumentID"] as? String{
                print("1",type)
                
                getFood(typeDocumentID: type)
                
            }
        }
    }
    
    func getType(){
        if let prepares = prepares{
            db.collection("res").document(prepares).collection("foodType").order(by: "index", descending: false).addSnapshotListener { (type, error) in
                if let type = type{
                    if type.documentChanges.isEmpty{
                        self.typeArray.removeAll()
                        self.typeCollectionView.reloadData()
                    }
                    else{
                        let documentChange = type.documentChanges[0]
                        if documentChange.type == .added {
                            self.typeArray = type.documents
                            self.typeAnimateCollectionView()
                            //  print("getType")
                        }
                    }
                }
            }
        }
    }
    func getFood(typeDocumentID: String){
        print("-------------")
           print(typeDocumentID)
        if let prepares = prepares{
            db.collection("res").document(prepares).collection("foodType").document(typeDocumentID).collection("menu").order(by: "foodIndex", descending: false).addSnapshotListener { (food, error) in
                if let food = food{
                    if food.documents.isEmpty{
                        self.foodArray.removeAll()
                        self.foodCollectionView.reloadData()
                        
                    }
                    else{
                        let documentChange = food.documentChanges[0]
                        if documentChange.type == .added {
                            self.foodArray = food.documents
                            print(self.foodArray.count)
                            self.foodAnimateCollectionView()
                            print("getFood Success")
                            print("-------------")
                        }
                    }
                }
            }
        }
    }
    //  顯示特效
    func typeAnimateCollectionView(){
        print(2000)
        typeCollectionView.reloadData()
        let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
        typeCollectionView.performBatchUpdates({
            UIView.animate(views: self.typeCollectionView.orderedVisibleCells,
                           animations: animations, completion: nil)
        }, completion: nil)
    }
    func foodAnimateCollectionView(){
        foodCollectionView.reloadData()
        let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
        foodCollectionView.performBatchUpdates({
            UIView.animate(views: self.foodCollectionView.orderedVisibleCells,
                           animations: animations, completion: nil)
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func stackAction(_ sender: Any) {
        for optina in optinss {
            UIView.animate(withDuration: 0.3, animations:{ optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension EditMenuViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeCollectionView{
            return typeArray.count
        }
        else{
            return foodArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == typeCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! EditTypeCollectionViewCell
            let type = typeArray[indexPath.row]
            cell.typeLabel.text = type.data()["typeName"] as? String
            cell.typeImage.kf.setImage(with: URL(string: type.data()["typeImage"] as! String))
            if isEditPressed {
                let anim = CABasicAnimation(keyPath: "transform.rotation")
                anim.toValue = 0
                anim.fromValue = Double.pi/32
                anim.duration = 0.1
                anim.repeatCount = MAXFLOAT
                anim.autoreverses = true
                cell.layer.add(anim, forKey: "SpringboardShake")
                }else {
                cell.layer.removeAllAnimations()
            }
            
            return cell
        }
        else{
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! EditFoodCollectionViewCell
            
            let food = foodArray[indexPath.row]
            if let foodName = food.data()["foodName"] as? String,
                let foodImage = food.data()["foodImage"] as? String,
                let foodMoney = food.data()["foodPrice"] as? Int{
                
                cell.foodNameLabel.text = foodName
                cell.foodImageView.kf.setImage(with: URL(string: foodImage))
                cell.foodMoneyLabel.text = "$\(foodMoney)"
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == typeCollectionView{
            
            selectIndex = indexPath
            
//            let cell = collectionView.cellForItem(at: indexPath) as! EditTypeCollectionViewCell
            typeIndex = indexPath.row
            if let type = typeArray[indexPath.row].data()["typeDocumentID"] as? String{
                getFood(typeDocumentID: type)
            }
            
        }
        else{
            foodIndex = indexPath.row
            performSegue(withIdentifier: "foodDetailSegue", sender: self)
            print(69)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView{
            
            let cell = collectionView.cellForItem(at: indexPath) as! EditTypeCollectionViewCell
        //    cell.backView.backgroundColor = UIColor(red: 255/255, green: 162/255, blue: 195/255, alpha: 1)
            print(20)
            //            print("diddeselect:\(indexPath.row)")
        }
        
    }
}





