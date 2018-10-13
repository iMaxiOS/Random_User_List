//
//  ViewController.swift
//  Random-User-List
//
//  Created by iMaxiOS on 9/28/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    private enum CellIdentifiers {
        static let userTableViewCell = "UserTableViewCell"
    }
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: UsersViewModel!
    
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.startAnimating()
        
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        let request = ParamsForRequst.from()
        viewModel = UsersViewModel(request: request, delegate: self)
        
        viewModel.fetchUsers()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "showEditVC")
        {
            //Upcoming is set to NewViewController
            let upcoming: EditViewController = segue.destination
                as! EditViewController
            //IndexPath is set to the path that was tapped
            let indexPath = self.tableView.indexPathForSelectedRow
            //Data of User is set to the dataOfUser at the row in the objects array.
            let objectOfUser = viewModel.user(at: (indexPath?.row)!)
            //The titleStringViaSegue property of NewViewController is set.
            upcoming.dataOfUser = objectOfUser
            //Removes graylight from the cell
            self.tableView.deselectRow(at: indexPath!, animated: true)
        }
    }
}

//MARK: - Extension DataSource
extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.userTableViewCell , for: indexPath) as? UserTableViewCell  else {
            fatalError("The dequeued cell is not an instance of UserTableViewCell.")
        }
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.user(at: indexPath.row))
        }
        return cell
    }
}

//MARK: - Extension UITableViewDelegate
extension UserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showEditVC", sender: self)
    }
}

//MARK: - Extension ViewModelDelegate
extension UserViewController: UsersViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
}

//MARK: - Extension DataSourcePrefetching
extension UserViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchUsers()
        }
    }
}

//MARK: - Private extension UserViewController
private extension UserViewController {
    
    //Allows you to determine whether the cell at that index path is beyond the count of the users you have received so far.
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    // This method calculates the cells of the table view that you need to reload when you receive a new page. It calculates the intersection of the IndexPaths passed in (previously calculated by the view model) with the visible ones. You'll use this to avoid refreshing cells that are not currently visible on the screen.
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

