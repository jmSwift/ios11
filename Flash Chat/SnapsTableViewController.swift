//
//  SnapsTableViewController.swift
//  Flash Chat
//
//  Created by Jose on 10/15/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsTableViewController: UITableViewController {

    var snaps: [DataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  let currentUserUid = Auth.auth().currentUser?.uid{
            Data.instance.REF_USERS.child(currentUserUid).child("snaps").observe(.childAdded, with: { (snapshot) in
                self.snaps.append(snapshot)
                self.tableView.reloadData()
                
                //observe
                Data.instance.REF_USERS.child(currentUserUid).child("snaps").observe(.childRemoved, with: { (snapshot) in
                    
                    var index = 0
                    for snap in self.snaps{
                        if snapshot.key == snap.key{
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    
                    self.tableView.reloadData()
                })
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if there are no snaps
        if snaps.count == 0{
            return 1
        }else{
            return snaps.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if snaps.count == 0{
            cell.textLabel?.text = "You have no snaps 😭"
        }else{
        
            let snap = snaps[indexPath.row]
            
            if let snapDictionary = snap.value as? NSDictionary{
                if let fromEmail = snapDictionary["from"] as? String{
                    cell.textLabel?.text = fromEmail
                }
            }
        
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "toSnapsVC", sender: snap)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapsVC"{
           if let viewVC = segue.destination as? SnapsViewController{
            if let snap = sender as? DataSnapshot{
                
                viewVC.snap = snap
                }
            }
        }
        
    }

}
