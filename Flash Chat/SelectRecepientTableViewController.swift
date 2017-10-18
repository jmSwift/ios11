//
//  SelectRecepientTableViewController.swift
//  Flash Chat
//
//  Created by Jose on 10/15/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SelectRecepientTableViewController: UITableViewController {

    @IBOutlet weak var sendBtn: UIButton!
    
    var downloadURL = ""
    var snapDescription = ""
    var imageName = ""
   // var users : [User] = []
    
    var user = [String]()
    var emailArray = [String]()
    var chosenArray = [String]()
    //var messageArray = [Message]()
    
    
    @IBOutlet var snapsTableView: UITableView!
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if let fromEmail = Auth.auth().currentUser?.email {
            
            var receiverUid = String()
            
            var receiversName = Data.instance.getIds(forUsername: user,handler: { (idArray) in
                
                for id in idArray{
                    
                    let snap  = ["from":fromEmail,"description":self.snapDescription,"imageURL":self.downloadURL,"imageName": self.imageName]
                
                    Data.instance.REF_USERS.child(id).child("snaps").childByAutoId().setValue(snap)
                    
                }
                
                
            })
            //self.presentAlert(alert: "Message Sent")
            //sendBtn.isEnabled = false
            self.performSegue(withIdentifier: "snapSent", sender: self)
        }//
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        snapsTableView.delegate = self
        snapsTableView.dataSource = self
        
       
        
        Data.instance.getEmail(forSearchQuery: "@", handler: { (returnedEmailArray) in
            self.emailArray = returnedEmailArray
          //  self.snapsTableView.reloadData()
        })
     
      //print(emailArray)
      //print(downloadURL)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.snapsTableView.reloadData()
        sendBtn.isEnabled  = false
       // print(emailArray)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func presentAlert(alert:String){
        let alertVC = UIAlertController(title: "Successful", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {(action) in alertVC.dismiss(animated: true, completion:nil)
            
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }

    

   

}

extension SelectRecepientTableViewController: UITextViewDelegate{
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return emailArray.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = snapsTableView.dequeueReusableCell(withIdentifier: "SnapTableViewCell", for: indexPath) as? SnapsTableViewCell else {return UITableViewCell()}
               // let user = emailArray[indexPath.row]
            
                cell.configureCell(email: emailArray[indexPath.row])
            
        
            return cell
        }
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             guard let cell = snapsTableView.cellForRow(at:  indexPath) as? SnapsTableViewCell else { return }
            if(!user.contains(cell.emailLbl.text!)){
                user.append(cell.emailLbl.text!)
                sendBtn.isEnabled = true
            }else{
                //filter array to keep everybody that is not us!
                //return everyone in the array except the person that we tapped
                user = user.filter({ $0 != cell.emailLbl.text! })
                
                }
            
            print(user)
        }
   
    
   

}
