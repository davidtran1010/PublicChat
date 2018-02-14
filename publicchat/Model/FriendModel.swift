//
//  FriendModel.swift
//  publicchat
//
//  Created by DavidTran on 2/12/18.
//  Copyright © 2018 DavidTran. All rights reserved.
//

import Foundation

class FriendModel{
    var id:String?
    var name:String?
    var photoURL:String?

init(id: String?, name: String?, photoURL: String?) {
    self.id = id
    self.name = name
    self.photoURL = photoURL
}
}
