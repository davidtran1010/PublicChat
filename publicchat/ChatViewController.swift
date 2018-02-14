//
//  ViewController.swift
//  publicchat
//
//  Created by DavidTran on 2/12/18.
//  Copyright © 2018 DavidTran. All rights reserved.
//

import UIKit
protocol ChatView {
    func updateChatModelList()
}
class ChatViewController: UIViewController, ChatView{

    
    var friendId:String?
    var friendName:String?
    var messageList = [ChatModel]()
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextView!
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let message = messageTextField.text
        let myInfo = FriendModel.init(id: "", name: "Me", photoURL: "")
        let chatModel = ChatModel.init(MyInfo: myInfo, FriendInfo: nil, MyMessage: message, FriendMessage: nil)
        ChatDataStore.HistoryChatDic[friendId!]!.append(chatModel)
        SocketIOManager.sharedInstance.sendMessage(message: message!, toUserID: friendId!)
    }
    
    func updateChatModelList() {
        messageList = ChatDataStore.HistoryChatDic[friendId!]!
        chatTableView.reloadData()
        chatTableView.scrollToBottom()
    }
    func hideKeyboardWhenNotUsed(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenNotUsed()
        if ChatDataStore.HistoryChatDic[friendId!] == nil{
            ChatDataStore.HistoryChatDic[friendId!] = [ChatModel]()
        }
        
        chatTableView.tableFooterView = UIView()
        chatTableView.estimatedRowHeight = 45
        chatTableView.rowHeight = UITableViewAutomaticDimension
        
        SocketIOManager.sharedInstance.chatView = self
        messageList = ChatDataStore.HistoryChatDic[friendId!]!
        self.navigationItem.title = friendName!
        chatTableView.delegate = self
        chatTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatReuseCell", for: indexPath) as! ChatTableViewCell

        cell.configure(model: messageList[indexPath.row])
        return cell
    }

}
