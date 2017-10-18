//
//  PostsCell.swift
//  Flash Chat
//
//  Created by Jose on 10/2/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PostsCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(profileImage: UIImage, email:String, content:String){
        self.profileImage.image = profileImage
        self.emailLbl.text = email
        self.contentLbl.text = content
    }
 
    
    func configureCell(profileImage: UIImage, email:String, content:String, postImage: UIImage){
        self.profileImage.image = profileImage
        self.emailLbl.text = email
        self.contentLbl.text = content
        self.postImage.image = postImage
        
    }

    //New for Posts
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.contentLbl.text = post.caption  
        //self.emailLbl.text! = post.senderId
        
        Data.instance.getUsername(forUID: post.senderId) { (email) in
            
            self.emailLbl.text! = email
            
        }
      
       // self.caption.text = post.caption
       
        
        if img != nil {
            self.postImage.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            //let ref = storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024 , completion: { (data , error) in
                if error != nil {
                    print("jose Unable to download image from Firebase storage")
                } else {
                    print("jose Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImage.image = img
                            //FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
           
        }
}

}


