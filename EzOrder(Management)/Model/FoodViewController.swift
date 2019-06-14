//
//  muneAddViewController.swift
//
//
//  Created by 劉十六 on 2019/6/2.
//

import UIKit
import Firebase
import SVProgressHUD

class FoodViewController: UIViewController{
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameTextfield: UITextField!
    @IBOutlet weak var foodPriceTextfield: UITextField!
    @IBOutlet weak var foodDetailTextfield: UITextView!
    
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    var typeArray = [QueryDocumentSnapshot]()
    var typeIndex: Int?
    var foodIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        upload()
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func tapMunefoodImage(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker,animated: true)
    }
    func upload(){
        
        if let foodImage = foodImageView.image,
            let foodName = foodNameTextfield.text, foodName.isEmpty == false,
            let foodPrice = Int(foodPriceTextfield.text!),
            let resID = resID,
            let foodIndex = foodIndex,
            let typeIndex = typeIndex,
            let typeName = self.typeArray[typeIndex].data()["typeName"] as? String{
            //DocumentReference 指定位置
            //照片參照
            SVProgressHUD.show()
            let storageReference = Storage.storage().reference()
            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
            let size = CGSize(width: 640, height: foodImage.size.height * 640 / foodImage.size.width)
            UIGraphicsBeginImageContext(size)
            foodImage.draw(in: CGRect(origin: .zero, size: size))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let data = resizeImage?.jpegData(compressionQuality: 0.8){
                fileReference.putData(data,metadata: nil) {(metadate, error) in
                    guard let _ = metadate, error == nil else {
                        SVProgressHUD.dismiss()
                        return
                    }
                    fileReference.downloadURL(completion: { (url, error) in
                        guard let downloadURL = url else {
                            SVProgressHUD.dismiss()
                            return
                        }
                        let data: [String: Any] = ["typeIndex": typeIndex,
                                                   "foodName": foodName,
                                                   "foodImage": downloadURL.absoluteString,
                                                   "foodPrice": foodPrice,
                                                   "foodIndex": foodIndex,
                                                   "foodDetail": self.foodDetailTextfield.text ?? ""]
                        self.db.collection("res").document(resID).collection("foodType").document(typeName).collection("menu").document(foodName).setData(data, completion: { (error) in
                            guard error == nil else {
                                SVProgressHUD.dismiss()
                                return
                            }
                            SVProgressHUD.dismiss()
                        })
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension FoodViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selece = info[.originalImage] as! UIImage
        foodImageView.image = selece
        picker.dismiss(animated: true, completion: nil)
    }
}

