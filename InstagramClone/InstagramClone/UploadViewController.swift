//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by ahmetburakozturk on 21.10.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var uploadImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        uploadImageView.isUserInteractionEnabled = true
        let imageViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        uploadImageView.addGestureRecognizer(imageViewGestureRecognizer)
        
        
    }
    

    @objc func pickImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func uploadOnClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        
        if let imageData = uploadImageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            
            imageReferance.putData(imageData,metadata: nil) { (metadata, error) in
                
                if error != nil {
                                    
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error on pushing data!")
                } else {
                    
                    imageReferance.downloadURL { (url, error) in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReferance : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl": imageUrl!, "postedBy": Auth.auth().currentUser!.email!, "postDescription": self.descriptionTextField.text! , "date": FieldValue.serverTimestamp(), "likes": 0] as [String : Any]
                            
                            firestoreReferance = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
                                } else {
                                    self.uploadImageView.image = UIImage(named: "imgClick")
                                    self.descriptionTextField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        } else {
            print("Image Convert Error!")
        }
        
    }
    
    
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
