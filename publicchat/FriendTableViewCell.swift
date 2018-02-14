//
//  FriendTableViewCell.swift
//  publicchat
//
//  Created by DavidTran on 2/12/18.
//  Copyright © 2018 DavidTran. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    func configure(model:FriendModel){
        userName.text = model.name
    }

}
