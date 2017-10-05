//
//  PostsVC.swift
//  Flash Chat
//
//  Created by Jose on 10/2/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class PostsVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var postsBtn: UIButton!
    
    @IBOutlet weak var postsTableView: UITableView!
   // @IBOutlet weak var tableView: UITableView!
    
    var textviewEdited = false
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.delegate = self
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func postBtnPressed(_ sender: Any) {
        if messageTextView.text != nil && textviewEdited == true && messageTextView.text != "" {
            postsBtn.isEnabled = false
            Data.instance.uploadPost(withMessage: messageTextView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil
                , sendComplete: { (isComplete) in
                    if(isComplete){
                        self.postsBtn.isEnabled = true
                        self.messageTextView.text = ""
                        print("post successful")
                        Data.instance.getAllFeedMessages { (returnedMessagesArray) in
                            //self.messageArray = returnedMessagesArray
                            self.messageArray = Array(returnedMessagesArray.reversed())
                            self.postsTableView.reloadData()
                        }
                    }else{
                        print("there was an error")
                    }
            })
        }
    }
    
   

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Data.instance.getAllFeedMessages { (returnedMessagesArray) in
            self.messageArray = Array(returnedMessagesArray.reversed())
            self.postsTableView.reloadData()
        }
    }

}

extension PostsVC: UITextViewDelegate, UITableViewDelegate, UITableViewDataSource{
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageTextView.text = ""
        textviewEdited = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = postsTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostsCell else {return UITableViewCell()}
        let message = messageArray[indexPath.row]
        let image = UIImage(named: "defaultProfileImage")
        //
        Data.instance.getUsername(forUID: message.senderId) { (email) in
            cell.configureCell(profileImage: image!, email: email, content: message.content)
        }
       // let image = UIImage(named: "defaultProfileImage")
        
        //cell.configureCell(profileImage: image!, email: message.senderId, content: message.content)
        
        return cell
    }
    
    
}
