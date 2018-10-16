//
//  SavedTableViewController.swift
//  Random-User-List
//
//  Created by iMaxiOS on 10/12/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import UIKit
import RealmSwift

class SavedTableViewController: UITableViewController {
    
    private enum CellIdentifiers {
        static let savedUserTableViewCell = "SavedTableViewCell"
    }
    
    var info: UserOfRealm?
    var infoUnwind: UserOfRealm?
    
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: segue)
        let indexPath = self.tableView.indexPathForSelectedRow
        infoUnwind = UserOfRealm.listUsers[(indexPath?.row)!]
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
        if infoUnwind == nil {
            info = UserOfRealm.listUsers[indexPath.row]
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
