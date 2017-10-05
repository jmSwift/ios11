//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class CustomMessageCell: UITableViewCell {

 
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var time: UILabel!
    /*
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
 */
    
    func configureCell(profileImage: UIImage, senderName: String, messageContent: String){
        
        self.profileImage.image = profileImage
        self.senderName.text = senderName
        self.messageContent.text = messageContent
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
        
    }


}
