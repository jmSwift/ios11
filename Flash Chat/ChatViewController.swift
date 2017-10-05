//
//  ViewController.swift
//  Flash Chat
//
//  Created by Jose meza
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    // Declare instance variables here

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupChatTitle: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    var group: Group?
    var groupMessages = [Message]()
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToGroupCells", sender: self)
    }
    
    func initData(forGroup group: Group){
        self.group = group
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupChatTitle.text = group?.groupTitle
        Data.instance.getEmailsFor(group: self.group!) { (returnedEmails) in
           self.membersLbl.text = returnedEmails.joined(separator: ", ")        }
        
        Data.instance.REF_GROUPS.observe(.value){(snapshot) in
            Data.instance.getAllMessagesFor(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
            })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
     
        
    }

  
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        if messageTextfield.text != "" {
            messageTextfield.isEnabled = false
            sendButton.isEnabled = false
            Data.instance.uploadPost(withMessage: messageTextfield.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key, sendComplete: { (complete) in
                if complete{
                    self.messageTextfield.text = ""
                    self.messageTextfield.isEnabled = true
                    self.sendButton.isEnabled = true
                }
            })
        }
        
        //TODO: Send the message to Firebase and save it in our database
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do{
           try Auth.auth().signOut()
        }
        catch{
            print("error: there was a problem signing out")
        }
        
        //make the root controller Active
        
        guard(navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("no view controllers to pop off")
                return
        }
        
        
    }
    


}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? CustomMessageCell else {return UITableViewCell()}
        let message = groupMessages[indexPath.row]
        Data.instance.getUsername(forUID: message.senderId) { (email) in
            cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, senderName: email, messageContent: message.content)
        }
        
        
        return cell
    }
    
}
