//
//  uploadVC.swift
//  SnapchatClone
//
//  Created by Mustafa Göktuğ İbolar on 10.08.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class uploadVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    let imageView = UIImageView()
    let uploadButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.size.width
        let height = view.frame.size.height
        view.backgroundColor = .yellow
        
        
        //IMAGEVIEW
        imageView.image = UIImage(named: "select.png")
        imageView.frame = CGRect(x: width * 0.1, y: height * 0.1, width: width * 0.8, height: height * 0.5)
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        imageView.addGestureRecognizer(gestureRecognizer)
        view.addSubview(imageView)
        
        //BUTTON
        uploadButton.setTitle("upload", for: UIControl.State.normal)
        uploadButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        uploadButton.addTarget(self, action: #selector(uploadButtonClicked), for: UIControl.Event.touchUpInside)
        uploadButton.frame = CGRect(x: width * 0.42, y: height * 0.63, width: width * 0.16 , height: height * 0.05)
        view.addSubview(uploadButton)
        

    }
    func makeAlert(title: String, message: String) {
             let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
             let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
             alert.addAction(okButton)
             self.present(alert, animated: true, completion: nil)
         }
    @objc func choosePicture() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadButtonClicked(){
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            //Firestore
                            
                            let fireStore = Firestore.firestore()
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { (snapshot, error) in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                }
                                else{
                                    if snapshot?.isEmpty == false && snapshot != nil{
                                        for document in snapshot!.documents {
                                            
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDictionary = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { (error) in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.imageView.image = UIImage(named: "select.png")
                                                    }
                                                    }
                                                
                                                
                                            }
                                            
                                            
                                        }
                                    }
                                    else {
                                        let snapDictionary = ["imageUrlArray" : [imageUrl!], "snapOwner" : UserSingleton.sharedUserInfo.username,"date":FieldValue.serverTimestamp()] as [String : Any]
                                        
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                                            if error != nil {
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.imageView.image = UIImage(named: "select.png")
                                            }
                                        }
                                    }
                                }
                            
                            
                        }
                            
                    }
        
                }
            }
        }
    }
    
}

            
}
