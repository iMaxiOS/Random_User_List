//
//  SavedUserTableViewCell.swift
//  Random-User-List
//
//  Created by iMaxiOS on 10/12/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import UIKit
import SDWebImage

class SavedUserTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    //MARK: Setttings
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
    }
    
    //MARK: - Assignment
    func configure(with user: UserOfRealm?) {
        if let user = user {
            userNameLabel.text = user.fullName
            phoneLabel.text = user.phone
            userImageView.sd_setImage(with: URL(string: user.thumbnail))
        }
    }
}
