//
//  PostsCell.swift
//  Flash Chat
//
//  Created by Jose on 10/2/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class PostsCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
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

}


