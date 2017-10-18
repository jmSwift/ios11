//
//  SnapsTableViewCell.swift
//  Flash Chat
//
//  Created by Jose on 10/15/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit

class SnapsTableViewCell: UITableViewCell {

    @IBOutlet weak var emailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(email:String){
        
        self.emailLbl.text = email
       
    }
}
