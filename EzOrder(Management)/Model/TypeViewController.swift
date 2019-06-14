//
//  addClassificationViewController.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/5/29.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class TypeViewController: UIViewController{
    
    @IBOutlet weak var typeNameTextfield: UITextField!
    @IBOutlet weak var typeImageView: UIImageView!
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func tapImageView(_ sender: UITapGestureRecognizer) {
        let imagePickerContorller = UIImagePickerController()
        imagePickerContorller.sourceType = .photoLibrary
        imagePickerContorller.delegate = self
        //imagePickerContorller.allowsEditing = true
        present(imagePickerContorller,animated: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        upload()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func upload() {
        if let typeName = typeNameTextfield.text, typeName.isEmpty == false,
            let typeImage = typeImageView.image,
            let resID = resID,
            let index = index{
            //DocumentReference 指定位置
            //照片參照
            SVProgressHUD.show()
            let storageReference = Storage.storage().reference()
            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
            let size = CGSize(width: 640, height: typeImage.size.height * 640 / typeImage.size.width)
            UIGraphicsBeginImageContext(size)
            typeImage.draw(in: CGRect(origin: .zero, size: size))
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
                        let data: [String: Any] = ["typeName": typeName,
                                                   "typeImage": downloadURL.absoluteString,
                                                   "index": index]
                        self.db.collection("res").document(resID).collection("foodType").document(typeName).setData(data, completion: { (error) in
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

extension TypeViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selece = info[.originalImage] as? UIImage {
            typeImageView.image = selece
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

