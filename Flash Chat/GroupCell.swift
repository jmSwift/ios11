//
//  GroupCell.swift
//  Flash Chat
//
//  Created by Jose on 10/1/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var memberCount: UILabel!
    
    func configureCell(title:String, description:String, memberCnt: Int){
        self.groupTitleLbl.text = title
        self.groupDesc.text = description
        self.memberCount.text = "\(memberCnt) members"
    }

}
