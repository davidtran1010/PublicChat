//
//  ChatListTableViewController.swift
//  publicchat
//
//  Created by DavidTran on 2/12/18.
//  Copyright © 2018 DavidTran. All rights reserved.
//

import UIKit
import UserNotifications
protocol ChatListView {
    func updateChatList()
    func updateNewMessage()
}
class FriendListTableViewController: UITableViewController,ChatListView,UNUserNotificationCenterDelegate {
    func updateNewMessage() {
    
    }
    

    var selectedId = ""
    var selectedName = ""
    var friendList = [FriendModel]()
    

    func updateChatList() {
        self.friendList = ChatDataStore.CurrentUserList
        self.tableView.reloadData()
    }

    func fetchHistory(){
        let historyArray = CoreDataHandler.fetchHistoryData()
        if historyArray.count > 0{
            for data in historyArray{
                print("saved id:\(data.conversationid)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SocketIOManager.sharedInstance.chatListView = self
        SocketIOManager.sharedInstance.establishConnection()
        self.tableView.tableFooterView = UIView()
        for friend in CoreDataHandler.fetchFriendHistory(){
            ChatDataStore.CurrentUserList.append(FriendModel.init(id: friend, name: friend, photoURL: ""))
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fetchHistory()
        selectedId = friendList[indexPath.row].id!
        selectedName = friendList[indexPath.row].name!
        performSegue(withIdentifier: "ChatVCSegue", sender: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendList.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendReuseCell", for: indexPath) as! FriendTableViewCell
        cell.configure(model: friendList[indexPath.row])
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ChatVCSegue"{
            return false
        }
        return true
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatVCSegue"{
            if let vc = segue.destination as? ChatViewController{
                vc.friendId = selectedId
                vc.friendName = selectedName
                
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    }

}
