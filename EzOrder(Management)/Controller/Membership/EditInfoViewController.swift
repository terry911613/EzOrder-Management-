//
//  ViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/5/15.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SVProgressHUD
import MapKit
class EditInfoViewController: UIViewController,CLLocationManagerDelegate{
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var resLogoImageView: UIImageView!
    
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var resTelLabel: UILabel!
    @IBOutlet weak var resLocationLabel: UILabel!
    @IBOutlet weak var resBookingLimitLabel: UILabel!
    @IBOutlet weak var resTaxIDLabel: UILabel!
    @IBOutlet weak var resTimeLabel: UILabel!
    //    @IBOutlet weak var resPeriodLabel: UILabel!
    
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var noonButton: UIButton!
    @IBOutlet weak var eveningButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var myMap: MKMapView!
    
    let db = Firestore.firestore()
    var isEdit = false
    var isEditImage = false
    var resImage: String?
    var resName: String?
    var resTel: String?
    var resLocation: String?
    var resBookingLimit: Int?
    var resTaxID: String?
    var resTime: String?
    var resPeriod: String?
    var typeArray = [QueryDocumentSnapshot]()
    var locations:CLLocationManager!
    var coordinates: CLLocationCoordinate2D?
    var isMorning = false
    var isNoon = false
    var isEvening = false
    var resID : String?
    var documentID : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        getType()
        if let resID = resID{
            db.collection("res").document(resID).addSnapshotListener { (res, error) in
                if let resData = res?.data(){
                    if let resImage = resData["resImage"] as? String,
                        let resName = resData["resName"] as? String,
                        let resTel = resData["resTel"] as? String,
                        let resLocation = resData["resLocation"] as? String,
                        let resBookingLimit = resData["resBookingLimit"] as? Int,
                        let resTaxID = resData["resTaxID"] as? String,
                        let resTime = resData["resTime"] as? String,
                        let resPeriod = resData["resPeriod"] as? String{
                        self.resImage = resImage
                        self.resName = resName
                        self.resTel = resTel
                        self.resLocation = resLocation
                        self.resBookingLimit = resBookingLimit
                        self.resTaxID = resTaxID
                        self.resTime = resTime
                        
                        self.isEdit = false
                        self.resLogoImageView.kf.setImage(with: URL(string: resImage))
                        self.resNameLabel.text = resName
                        self.resTelLabel.text = resTel
                        self.resLocationLabel.text = resLocation
                        self.resBookingLimitLabel.text = "\(resBookingLimit)"
                        self.resTaxIDLabel.text = resTaxID
                        self.resTimeLabel.text = resTime
                        
                        self.morningButton.isEnabled = false
                        self.noonButton.isEnabled = false
                        self.eveningButton.isEnabled = false
                        
                        self.resPeriod = resPeriod
                        for i in resPeriod{
                            if i == "1"{
                                self.morningButton.backgroundColor = .white
                                self.morningButton.alpha = 1
                            }
                            else if i == "2"{
                                self.noonButton.alpha = 1
                                self.noonButton.backgroundColor = .white
                            }
                            else{
                                self.eveningButton.alpha = 1
                                self.eveningButton.backgroundColor = .white
                            }
                        }
                        
                        
                        self.resLogoImageView.isUserInteractionEnabled = false
                        self.editButton.isHidden = true
                        self.locations = CLLocationManager()
                        self.locations.delegate = self
                        self.locations.requestWhenInUseAuthorization()
                        self.locations.startUpdatingLocation()
                        self.setMapRegion()
                        let text = resLocation
                        let geocoder = CLGeocoder()
                        geocoder.geocodeAddressString(text) { (placemarks, error) in
                            if error == nil && placemarks != nil && placemarks!.count > 0 {
                                if let placemark = placemarks!.first {
                                    let location = placemark.location!
                                    self.setMapCenter(center: location.coordinate)
                                    self.setMapAnnotation(location)
                                }
                            } else {
                                let title = "收尋失敗"
                                let message = "目前網路連線不穩定"
                                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default)
                                alertController.addAction(ok)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                        
                    }
                    
                }
                else{
                    
                    self.isEdit = true
                    print("fuck it")
                    
                    self.editButton.isHidden = false
                    self.morningButton.isEnabled = true
                    self.noonButton.isEnabled = true
                    self.eveningButton.isEnabled = true
                    self.resLogoImageView.isUserInteractionEnabled = true
                    
                    self.resNameLabel.isHidden = true
                    self.resTelLabel.isHidden = true
                    self.resLocationLabel.isHidden = true
                    self.resBookingLimitLabel.isHidden = true
                    self.resTaxIDLabel.isHidden = true
                    self.resTimeLabel.isHidden = true
                    //                    self.resPeriodLabel.isHidden = true
                    
                }
            }
        }
        
    }
    
    @IBAction func okay(_ sender: Any) {
        
        let alert = UIAlertController(title: "確定申請通過?", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default) { (ok) in
            
            let db = Firestore.firestore()
            if let documentID = self.documentID,
                let resID = self.resID{
                print(12)
                db.collection("manage").document("check").collection("storeconfirm").document(documentID).updateData(["status": 1])
                db.collection("res").document(resID).updateData(["status" : 1])
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func noay(_ sender: Any) {
        let alert = UIAlertController(title: "確定退回?", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default) { (ok) in
            print(123123123)
            let db = Firestore.firestore()
            print(self.documentID)
            print(self.resID)
            if let documentID = self.documentID,
                let resID = self.resID{
                db.collection("manage").document("check").collection("storeconfirm").document(documentID).updateData(["status": 2])
                db.collection("res").document(resID).updateData(["status" : 2])
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func storeconfirm() {
        let db = Firestore.firestore()
        if let resIDdocument = resID { db.collection("res").document(resIDdocument).collection("storeconfirm").document("status").updateData(["status" : 1])
        }
    }
    
    func storeconfirms () {
        let db = Firestore.firestore()
        if  let resIDdocument = resID { db.collection("res").document(resIDdocument).collection("storeconfirm").document("status").updateData(["status" : 2])
        }
    }
    
    
    func getType(){
        if let resIDdocument = resID{
            db.collection("res").document(resIDdocument).collection("foodType").getDocuments { (type, error) in
                if let type = type{
                    self.typeArray = type.documents
                    self.typeCollectionView.reloadData()
                }
            }
        }
    }
    @IBAction func periodButton(_ sender: UIButton) {
        if sender.tag == 0{
            isMorning = !isMorning
            if isMorning{
                morningButton.alpha = 1
            }
            else{
                morningButton.alpha = 0.5
            }
        }
        else if sender.tag == 1{
            isNoon = !isNoon
            if isNoon{
                noonButton.alpha = 1
            }
            else{
                noonButton.alpha = 0.5
            }
        }
        else{
            isEvening = !isEvening
            if isEvening{
                print(1)
                eveningButton.alpha = 1
            }
            else{
                eveningButton.alpha = 0.5
            }
        }
    }
    
    @IBAction func tapResLogoImageView(_ sender: UITapGestureRecognizer) {
        isEditImage = !isEditImage
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController,animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMenu" {
            let editMune = segue.destination as!  EditMenuViewController
            editMune.prepares = resID!
            
        }
    }
    func errorAlert(){
        let alert = UIAlertController(title: "上傳失敗", message: "請稍後再試一次", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    func setMapAnnotation(_ location: CLLocation) {
        if let text = resLocation {
            let coordinate = location.coordinate
            let annotation = MKPointAnnotation()
            self.coordinates = coordinate
            annotation.coordinate = coordinate
            annotation.title = text
            annotation.subtitle = "(\(coordinate.latitude), \(coordinate.longitude))"
            myMap.addAnnotation(annotation)
        }
        
        
    }
    func setMapCenter(center: CLLocationCoordinate2D) {
        myMap.setCenter(center, animated: true)
        
    }
    func setMapRegion() {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var region = MKCoordinateRegion()
        region.span = span
        myMap.setRegion(region, animated: true)
        myMap.regionThatFits(region)
    }
    
}

extension EditInfoViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainTypeCollectionViewCell
        let type = typeArray[indexPath.row]
        cell.typeLabel.text = type.data()["typeName"] as? String
        cell.typeImageView.kf.setImage(with: URL(string: type.data()["typeImage"] as! String))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = typeArray.remove(at: sourceIndexPath.item)
        typeArray.insert(item, at: destinationIndexPath.item)
    }
}
extension EditInfoViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let selsct = info[.originalImage] as? UIImage{
            resLogoImageView.image = selsct
        }
        self.dismiss(animated: true)
    }
}

