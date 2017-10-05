//
//  GroupsVC.swift
//  Flash Chat
//
//  Created by Jose on 10/1/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
       // tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Data.instance.REF_GROUPS.observe(.value) { (snapshot) in
        
            Data.instance.getAllGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.tableView.reloadData()
            }
        }
    }

}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else{return UITableViewCell()}
        let group = groupsArray[indexPath.row]
        
        cell.configureCell(title: group.groupTitle , description: group.groupDesc  , memberCnt: group.memberCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chatFeedVC = storyboard?.instantiateViewController(withIdentifier: "chatVC") as? ChatViewController else {return}
        chatFeedVC.initData(forGroup: groupsArray[indexPath.row])
        present(chatFeedVC, animated: true, completion: nil)
    }
    
    
}
