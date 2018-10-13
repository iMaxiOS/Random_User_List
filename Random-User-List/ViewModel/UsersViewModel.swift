//
//  UsersViewModel.swift
//  Random-User-List
//
//  Created by iMaxiOS on 10/8/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation

//MARK: - Protocol ViewModelDelegate
protocol UsersViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
}

//MARK: -
final class UsersViewModel {
    private weak var delegate: UsersViewModelDelegate?
    
    //MARK: Properties
    var users: [User] = []
    private var currentPage = 0
    private var total = 0
    private var isFetchInProgress = false
    
    let client = APIManager()
    var request: ParamsForRequst
    
    init(request: ParamsForRequst, delegate: UsersViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return users.count
    }
    
    func user(at index: Int) -> User {
        return users[index]
    }
    
    func fetchUsers() {
        
        //Bail out, if a fetch request is already in progress. This prevents multiple requests happening.
        guard !isFetchInProgress else {
            return
        }
        
        //If a fetch request is not in progress, set isFetchInProgress to true and send the request.
        isFetchInProgress = true
        
        //Increment by one page in the parameters
        self.currentPage += 1
        request.parameters["page"] = currentPage
        
        client.getUsersList(request.parameters as [String : AnyObject], completion: { [weak self] json in
            
            //Since the server is very fast, we cannot see that the loading of our pages clearly works, so here
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                //If it’s successful, append the new items to the users list and inform the delegate that there’s data available.
                //TODO: - It should be instead: "asyncAfter(deadline: .now() + 1.0)"
                //            DispatchQueue.main.async {
                let setupUser = User.setupUser(json: json)
                self?.isFetchInProgress = false
                
                //Total items on the server
                self?.total = 5000
                self?.users.append(contentsOf: setupUser)
                
                //If this isn't the first page, you'll need to determine how to update the table view content by calculating the index paths to reload.
                if (self?.currentPage)! > 1 {
                    let indexPathsToReload = self?.calculateIndexPathsToReload(from: setupUser)
                    self?.delegate?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self?.delegate?.onFetchCompleted(with: .none)
                }
            }
        })
    }
    
    private func calculateIndexPathsToReload(from newUsers: [User]) -> [IndexPath] {
        let startIndex = users.count - newUsers.count
        let endIndex = startIndex + newUsers.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
