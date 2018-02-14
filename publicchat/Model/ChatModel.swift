//
//  ChatModel.swift
//  publicchat
//
//  Created by DavidTran on 2/12/18.
//  Copyright © 2018 DavidTran. All rights reserved.
//

import Foundation

class ChatModel{
    var MyInfo:FriendModel?
    var FriendInfo:FriendModel?
    var MyMessage:String?
    var FriendMessage:String?

init(MyInfo: FriendModel?, FriendInfo: FriendModel?, MyMessage: String?, FriendMessage: String?) {
    self.MyInfo = MyInfo
    self.FriendInfo = FriendInfo
    self.MyMessage = MyMessage
    self.FriendMessage = FriendMessage
}
}
