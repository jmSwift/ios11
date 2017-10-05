//
//  UserCell.swift
//  Flash Chat
//
//  Created by Jose on 10/1/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    var showing = false
    
    func configureCell(profileImage: UIImage, email:String, isSelected:Bool){
        self.profileImage.image = profileImage
        self.emailLbl.text = email
        //checkmark hidden by default
        if(isSelected){
            self.checkImage.isHidden = false
        }else{
            self.checkImage.isHidden = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if(selected){
            if(showing == false){
                checkImage.isHidden = false
                showing = true
            }else{
                checkImage.isHidden = true
                showing = false
            }
        }
        
        // Configure the view for the selected state
    }

}
