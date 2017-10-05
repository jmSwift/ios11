//
//  NewGroupsVC.swift
//  Flash Chat
//
//  Created by Jose on 10/1/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class NewGroupsVC: UIViewController {

    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descTextField: InsetTextField!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    @IBOutlet weak var groupMembersLbl: UILabel!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var emailArray = [String]()
    var chosenUserArray = [String]()
    
   // var groupIsCreated = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTextField.delegate = self as? UITextFieldDelegate

        
        //whenever email textfield is changed
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isEnabled  = false
    }
    
    //check if email textField is changed and update array
    @objc func textFieldDidChange(){
        if(emailSearchTextField.text == ""){
            emailArray = []
            tableView.reloadData()
        }else {
            Data.instance.getEmail(forSearchQuery: emailSearchTextField.text!, handler: { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.tableView.reloadData()
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    @IBAction func doneBtnPressed(_ sender: Any) {
        if titleTextField.text != "" && descTextField.text != ""{
            Data.instance.getIds(forUsername: chosenUserArray, handler: { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                //if(!self.groupIsCreated){
                Data.instance.createGroup(withTitle: self.titleTextField.text!, andDescription: self.descTextField.text!, forUserIds: userIds, handler: { (groupCreated) in
                    if (groupCreated == true){
                        self.dismiss(animated: true, completion: nil)
                        print("group created")
                        //self.groupIsCreated = true
                       
                    }else{
                        print("group not created")
                    }
                  })//end of data.instance
               // }
            })
            
           
            
        }
    }
    
}

extension NewGroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else{
            return UITableViewCell()
        }
        let profileImage = UIImage(named:"defaultProfileImage")
        
        if(chosenUserArray.contains(emailArray[indexPath.row])){
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        }else{
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at:  indexPath) as? UserCell else { return }
        if(!chosenUserArray.contains(cell.emailLbl.text!)){
            chosenUserArray.append(cell.emailLbl.text!)
            groupMembersLbl.text = chosenUserArray.joined(separator: ", ")
           doneBtn.isEnabled = true
        }else{
            //filter array to keep everybody that is not us!
            //return everyone in the array except the person that we tapped
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLbl.text! })
            if(chosenUserArray.count >= 1){
                groupMembersLbl.text = chosenUserArray.joined(separator: ",")
            }else{
                groupMembersLbl.text = "Add people to your group"
                //doneBtn.isEnabled = false
            }
        }
        
 

    }

}

extension NewGroupsVC: UITextFieldDelegate{
    
}


