//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by ahmetburakozturk on 21.10.2023.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var imageUrlArray = [String]()
    var documentIDArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        getFromFirestore()
    }
    
    func getFromFirestore(){
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil {
                
                print(error?.localizedDescription ?? "Error")
            } else {
                
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.imageUrlArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                            
                            if let postDescription = document.get("postDescription") as? String {
                                self.userCommentArray.append(postDescription)
                                
                                if let likes = document.get("likes") as? Int {
                                    self.likeArray.append(likes)
                                    
                                    if let imageUrl = document.get("imageUrl") as? String {
                                        self.imageUrlArray.append(imageUrl)
                                    }
                                }
                            }
                        }
                        
                        self.mainTableView.reloadData()
                    }
                }
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        cell.usermailLabel.text = self.userEmailArray[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: self.imageUrlArray[indexPath.row]))
        cell.descriptionLabel.text = self.userCommentArray[indexPath.row]
        cell.likeCountLabel.text = String(self.likeArray[indexPath.row])
        cell.documentIDLabel.text = self.documentIDArray[indexPath.row]
        return cell
    }

}
