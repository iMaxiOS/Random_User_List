//
//  SavedTableViewController.swift
//  Random-User-List
//
//  Created by iMaxiOS on 10/12/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import UIKit
import RealmSwift

protocol SavedTableVCDelegate {
    func fillTheLabelWith(info: UserOfRealm)
}

class SavedTableViewController: UITableViewController {
    
    private enum CellIdentifiers {
        static let savedUserTableViewCell = "SavedTableViewCell"
    }
    
    var delegate: SavedTableVCDelegate?
    var info: UserOfRealm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //All users from Realm
        UserOfRealm().allUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        navigationItem.hidesBackButton = true
    }
}


// MARK: - Table view data source
extension SavedTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserOfRealm.listUsers.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.savedUserTableViewCell , for: indexPath) as? SavedUserTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SavedUserTableViewCell.")
        }
        cell.configure(with: UserOfRealm.listUsers[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        info = UserOfRealm.listUsers[indexPath.row]
        delegate?.fillTheLabelWith(info: info!)
        if navigationController?.tabBarController?.selectedIndex == 0 {
            navigationController?.popViewController(animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "editVC") as! EditViewController
            vc.dataSavedUser = info
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            try! UserOfRealm.listUsers.realm!.write {
                let user = UserOfRealm.listUsers[indexPath.row]
                UserOfRealm.listUsers.realm?.delete(user)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
