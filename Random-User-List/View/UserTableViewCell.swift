//
//  UserTableViewCell.swift
//  Random-User-List
//
//  Created by iMaxiOS on 9/29/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    //MARK: Setttings
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
        indicatorView.hidesWhenStopped = true
    }
    
    //MARK: - Assignment
    func configure(with user: User?) {
        if let user = user {
            userNameLabel.text = user.fullNameOfUser
            phoneLabel.text = user.phone
            userImageView.sd_setImage(with: URL(string: user.thumbnail))
            indicatorView.stopAnimating()
            userNameLabel.alpha = 1
            phoneLabel.alpha = 1
            userImageView.alpha = 1
            
        } else {
            userNameLabel.alpha = 0
            phoneLabel.alpha = 0
            userImageView.alpha  = 0
            indicatorView.startAnimating()
        }
    }
}

