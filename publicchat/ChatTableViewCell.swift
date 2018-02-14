//
//  ChatTableViewCell.swift
//  publicchat
//
//  Created by DavidTran on 2/12/18.
//  Copyright © 2018 DavidTran. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendMessage: UILabel!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myMessage: UILabel!

    func initUICell(){
      
        
        myMessage.numberOfLines = 0
        friendMessage.numberOfLines = 0
        myMessage.layer.masksToBounds = true
        friendMessage.layer.masksToBounds = true
        myMessage.layer.cornerRadius = 5
        friendMessage.layer.cornerRadius = 5
    }
    func showUIContent(isOfMe:Bool){
        if isOfMe == true{
            friendName.text = ""
            friendMessage.text = ""
            friendName.isHidden = true
            friendMessage.isHidden = true
            
            myName.isHidden = false
            myMessage.isHidden = false
        }else{
            myName.text = ""
            myMessage.text = ""
            myName.isHidden = true
            myMessage.isHidden = true
            
            friendName.isHidden = false
            friendMessage.isHidden = false
            
        }
    }
    func configure(model: ChatModel){
        initUICell()
        if model.MyInfo != nil{
            showUIContent(isOfMe: true)
            myName.text = model.MyInfo?.name
            myMessage.text = model.MyMessage
            
        }
        else{
            showUIContent(isOfMe: false)
            friendName.text = model.FriendInfo?.name
            friendMessage.text = model.FriendMessage
           
        }
    }
}
