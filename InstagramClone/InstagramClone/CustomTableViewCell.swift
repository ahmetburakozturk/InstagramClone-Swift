//
//  CustomTableViewCell.swift
//  InstagramClone
//
//  Created by ahmetburakozturk on 21.10.2023.
//

import UIKit
import FirebaseFirestore

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var documentIDLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usermailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func likeButtonOnClicked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeCountLabel.text!) {
            let likeStore = ["likes": likeCount + 1] as [String: Any]
            
            firestoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
        }
    }
    
}
