//
//  SnapsViewController.swift
//  Flash Chat
//
//  Created by Jose on 10/15/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseAuth


class SnapsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var messageLbl: UILabel!
    
    var snap : DataSnapshot?
    
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snapDictionary = snap?.value as? NSDictionary{
            
            if let description = snapDictionary["description"] as? String{
                
                if let imageURL = snapDictionary["imageURL"] as? String{
                    messageLbl.text = description
                    
                    
                    if let url = URL(string: imageURL){
                        imageView.sd_setImage(with: url, completed: nil)

                    }
                    if let imageName = snapDictionary["imageName"] as? String {
                        self.imageName = imageName
                    }
                }
            }
        }
        

      

        print("inside viewDId LOad")
  

    }// end of view did load
    
    override func viewWillDisappear(_ animated: Bool) {
        if let currentUserUid = Auth.auth().currentUser?.uid{
        
            if let key = snap?.key{
                Data.instance.REF_USERS.child(currentUserUid).child("snaps").child(key).removeValue()
                storage.reference().child("images").child(imageName).delete(completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }//end of view will appear

}
